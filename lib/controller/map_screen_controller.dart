import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_project/widgets/components.dart';

class MapScreenController {
  static const chooseBeginingPointState = 0;
  static const chooseEndPointState = 1;
  static const requestTripState = 2;
  int curentState = 0;
  List screenStates = [chooseBeginingPointState];
  List<Marker> markers = [];
  List<LatLng> points = [];

  chooseStateOnForward(controller) {
    switch (screenStates.last) {
      case chooseBeginingPointState:
        screenStates.add(chooseEndPointState);
        getPoint(controller.camera.center);

        break;

      case chooseEndPointState:
        screenStates.add(requestTripState);
        getPoint(controller.camera.center);

        break;

      case requestTripState:
        break;
    }
    curentState = screenStates.last;
  }

  chooseStateOnBack() {
    if (screenStates.length > 1) {
      screenStates.removeLast();
      markers.removeLast();
      curentState = screenStates.last;
      points.clear();
    }
  }

  List<Marker> getPoint(LatLng point) {
    switch (curentState) {
      case 0:
        markers.add(Marker(
            point: point,
            child: Transform.scale(scale: 1.5, child: beginingMarker)));

        break;

      case 1:
        markers.add(Marker(
            point: point,
            child: Transform.scale(scale: 1.5, child: endingMarker)));
        for (int i = 0; i < markers.length; i++) {
          points.add(markers[i].point);
        }

        break;
      case 2:
        break;
    }

    return markers;
  }
}
