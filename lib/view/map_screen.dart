import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:map_project/constants/my_text_styles.dart';
import 'package:map_project/controller/map_screen_controller.dart';
import 'package:map_project/widgets/components.dart';
import 'package:map_project/constants/dimens.dart';
import 'package:map_project/constants/my_strings.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  final MapScreenController _mapScreenController = MapScreenController();
  MapController mapController = MapController();
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
    _mapScreenController.determinePosition();
    _mapScreenController.timer(
        setState,
        _mapScreenController,
        mapController,
        context,
        Center(
          child: Text(
            'متاسفانه لوکیشن شما یافت نشد',
            style: MyTextStyles.snackBarTextStyle,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: const MapOptions(
                initialZoom: 17, initialCenter: LatLng(35.699, 51.338)),
            children: [
              TileLayer(
                  tms: false,
                  // urlTemplate: "${MyApi.mapUrl}?x-api-key=${MyApi.mapApiKey}"
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
              MarkerLayer(
                markers: _mapScreenController.markers,
                rotate: true,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Center(
                  child: _mapScreenController.curentState == 0
                      ? beginingMarker(0)
                      : _mapScreenController.curentState == 1
                          ? endingMarker(0)
                          : const SizedBox.shrink(),
                ),
              )
            ],
          ),
          _mapScreenController.curentState == 2
              ? Container(
                  color: Colors.transparent,
                )
              : const SizedBox.shrink(),
          Positioned(
            bottom: Dimens.xLarge,
            left: Dimens.large,
            right: Dimens.large,
            child: myElevatedBtn(
                context,
                _mapScreenController.curentState == 0
                    ? MyStrings.chooseBeginingPointBtn
                    : _mapScreenController.curentState == 1
                        ? MyStrings.chooseEndPointBtn
                        : MyStrings.requestTripBtn, () {
              setState(() {
                _mapScreenController.chooseStateOnForward(mapController, 24);

                if (_mapScreenController.curentState == 2) {
                  mapController.fitCamera(CameraFit.bounds(
                      padding: EdgeInsets.fromLTRB(
                          100, 100, 100, Dimens.phoneHeight(context) / 2),
                      maxZoom: 16,
                      bounds: LatLngBounds.fromPoints(
                          _mapScreenController.points)));
                }
                if (_mapScreenController.curentState == 3) {
                  setState(() {});
                }
              });
            }),
          ),
          Positioned(
              top: Dimens.xxLarge,
              left: Dimens.large,
              child: BackBtn(
                function: () {
                  setState(() {
                    _mapScreenController.chooseStateOnBack();
                  });
                },
              )),
          Positioned(
              bottom: Dimens.xxxLarge,
              left: Dimens.large,
              right: Dimens.large,
              child: _mapScreenController.curentState == 2
                  ? Container(
                      width: Dimens.phoneWidth(context),
                      height: Dimens.phoneHeight(context) / 7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _mapScreenController.getDistance()['km'] == "0"
                                ? distMsg(context, _mapScreenController).first
                                : distMsg(context, _mapScreenController).last,
                            FutureBuilder(
                              future: _mapScreenController.getAddress(0),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Text(
                                    'آدرس مبدا : ${snapshot.data!}',
                                    style: MyTextStyles.msgTextStyle,
                                  );
                                }
                                return const SpinKitCircle(
                                  color: Colors.black,
                                  size: 10,
                                );
                              },
                            ),
                            FutureBuilder(
                              future: _mapScreenController.getAddress(1),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Text(
                                    'آدرس مقصد : ${snapshot.data!}',
                                    style: MyTextStyles.msgTextStyle,
                                  );
                                }
                                return const SpinKitCircle(
                                  color: Colors.black,
                                  size: 10,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
          _mapScreenController.loading == true
              ? Container(
                  color: Colors.white,
                  child: const SpinKitCircle(
                    color: Color.fromARGB(255, 65, 193, 69),
                  ),
                )
              : const SizedBox.shrink(),
          _mapScreenController.curentState == 3
              ? findDriver(context, setState, _mapScreenController)
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
