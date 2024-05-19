import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:map_project/controller/map_screen_controller.dart';
import 'package:map_project/widgets/components.dart';
import 'package:map_project/constants/dimens.dart';
import 'package:map_project/constants/my_strings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapScreenController _mapScreenController = MapScreenController();
  // MapController mapController = MapController(
  //   initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
  //   areaLimit: BoundingBox(
  //     east: 10.4922941,
  //     north: 47.8084648,
  //     south: 45.817995,
  //     west: 5.9559113,
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // OSMFlutter(
            //     controller: mapController,
            //     // mapIsLoading: SpinKitCircle(
            //     //   color: Colors.black,
            //     // ),
            //     osmOption: OSMOption(
            //       userLocationMarker: UserLocationMaker(
            //           directionArrowMarker: MarkerIcon(
            //             iconWidget: beginingMarker,
            //           ),
            //           personMarker: MarkerIcon(
            //             iconWidget: beginingMarker,
            //           )),
            //       zoomOption: ZoomOption(
            //           initZoom: 15,
            //           minZoomLevel: 8,
            //           maxZoomLevel: 18,
            //           stepZoom: 1),
            //     )),
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
                  _mapScreenController.chooseStateOnForward();
                });
              }),
            ),
            Positioned(
                top: Dimens.large,
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
      ),
    );
  }
}
