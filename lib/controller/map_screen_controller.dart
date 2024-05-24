import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_project/widgets/components.dart';

class MapScreenController {
  static const chooseBeginingPointState = 0;
  static const chooseEndPointState = 1;
  static const requestTripState = 2;
  static const findDriver = 3;
  int curentState = 0;
  List screenStates = [chooseBeginingPointState];
  List<Marker> markers = [];
  List<LatLng> points = [];
  final Distance distance = const Distance();
  late final Position myPosition;
  bool loading = true;

  chooseStateOnForward(controller, double animationValue) {
    switch (screenStates.last) {
      case chooseBeginingPointState:
        getPoint(controller.camera.center, animationValue);
        screenStates.add(chooseEndPointState);

        break;

      case chooseEndPointState:
        getPoint(controller.camera.center, animationValue);
        screenStates.add(requestTripState);

        break;

      case requestTripState:
        screenStates.add(findDriver);
        break;
    }
    curentState = screenStates.last;
  }

  chooseStateOnBack() {
    if (screenStates.length > 1) {
      if (screenStates.length == 2 || screenStates.length == 3) {
        markers.removeLast();
      }

      if (screenStates.length == 2) {
        points.clear();
      }
      screenStates.removeLast();

      curentState = screenStates.last;
    }
  }

  List<Marker> getPoint(LatLng point, double animationValue) {
    switch (curentState) {
      case 0:
        markers
            .add(Marker(point: point, child: beginingMarker(animationValue)));

        break;

      case 1:
        markers.add(Marker(
          point: point,
          child: endingMarker(animationValue),
        ));
        for (int i = 0; i < markers.length; i++) {
          points.add(markers[i].point);
        }

        break;
      case 2:
        break;
    }

    return markers;
  }

  Map getDistance() {
    num distMeter = 0;
    num distKMeter = 0;

    if (points.length > 1) {
      distMeter =
          distance.calculator.distance(points.first, points.last).round();

      if (distMeter < 1000) {
        distMeter;
        distKMeter = 0;
      } else {
        distKMeter = (distMeter / 1000).floor();
        distMeter = distMeter - distKMeter * 1000;
      }
    }

    return {'km': distKMeter.toString(), 'm': distMeter.toString()};
  }

  Future<String> getAddress(int index) async {
    String address = '';
    await setLocaleIdentifier('fa');
    try {
      await placemarkFromCoordinates(
        points[index].latitude,
        points[index].longitude,
      ).then((List<Placemark> list) {
        address = '${list.first.locality} ${list.first.street}';
      });
    } catch (e) {
      address = 'آدرس یافت نشد';
    }
    return address;
  }

  // getUserPosition() async {
  //   position = await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high)
  //       .then((value) {
  //     log(position.toString());
  //     return position;
  //   });
  // }

  // checkUserLocationPermission() async {
  //   await Geolocator.isLocationServiceEnabled().then((bool isEnable) async {
  //     if (isEnable) {
  //       await Geolocator.checkPermission()
  //           .then((LocationPermission permission) async {
  //         if (permission != LocationPermission.denied &&
  //             permission != LocationPermission.deniedForever &&
  //             permission != LocationPermission.unableToDetermine) {
  //           await Geolocator.requestPermission()
  //               .then((LocationPermission permission) => {
  //                     log(permission.toString()),
  //                     if (permission == LocationPermission.always ||
  //                         permission == LocationPermission.whileInUse)
  //                       {getUserPosition()}
  //                     else
  //                       {throw ('couldnt get permission')}
  //                   });
  //         }
  //       });
  //     }
  //   });
  // }

  Future<Position?> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      log(permission.toString());
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        myPosition = await Geolocator.getCurrentPosition();
        log(myPosition.toString());
        loading = false;
      }
      throw Exception('Error');
    }

    return await Geolocator.getCurrentPosition();
  }

  Timer timer(Function setState, controller, MapController mapController,
      BuildContext context, Widget errorSnackBar) {
    bool myTimer = true;
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      bool myTimer = true;
      if (controller.loading == false) {
        myTimer = false;

        mapController.move(
            LatLng(myPosition.latitude, myPosition.longitude), 17);
      }
      if (myTimer == false || timer.tick > 10) {
        if (timer.tick > 9) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: errorSnackBar,
              backgroundColor: Colors.white,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        setState(() {
          timer.cancel();
          controller.loading = false;
        });
      }
    });
  }
}
