import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:map_project/constants/my_text_styles.dart';
import 'package:map_project/controller/map_screen_controller.dart';
import 'package:map_project/gen/assets.gen.dart';
import 'package:map_project/widgets/components.dart';
import 'package:map_project/constants/dimens.dart';
import 'package:map_project/constants/my_strings.dart';
import 'package:map_project/constants/api_key.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapScreenController _mapScreenController = MapScreenController();
  final MapController mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: const MapOptions(
              initialZoom: 17,
              initialCenter: LatLng(35.71, 51.5),
            ),
            children: [
              TileLayer(
                  tms: false,
                  // urlTemplate: "${MyApi.mapUrl}?x-api-key=${MyApi.mapApiKey}"
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
              MarkerLayer(
                markers: _mapScreenController.markers,
                alignment: Alignment.bottomCenter,
              ),
              Center(
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: _mapScreenController.curentState == 0
                        ? beginingMarker
                        : _mapScreenController.curentState == 1
                            ? endingMarker
                            : const SizedBox.shrink()),
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
                _mapScreenController.chooseStateOnForward(mapController);
                if (_mapScreenController.curentState == 2) {
                  mapController.fitCamera(CameraFit.insideBounds(
                      padding: const EdgeInsets.all(200),
                      maxZoom: 16,
                      minZoom: 8,
                      bounds: LatLngBounds.fromPoints(
                          _mapScreenController.points)));
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
        ],
      ),
    );
  }
}
