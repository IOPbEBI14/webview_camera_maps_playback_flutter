import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'widgets/map_page.dart';

class MapControlsPage extends MapPage {
  const MapControlsPage() : super('Map controls example');

  @override
  Widget build(BuildContext context) {
    return _MapControlsExample();
  }
}

class _MapControlsExample extends StatefulWidget {
  @override
  _MapControlsExampleState createState() => _MapControlsExampleState();
}

class _MapControlsExampleState extends State<_MapControlsExample> {
  late YandexMapController controller;

  static const Point _myHomePoint =
      Point(latitude: 4.175446, longitude: 73.501908);
  final animation =
      const MapAnimation(type: MapAnimationType.smooth, duration: 2.0);
  final shift = 0.001;
  static const double _scale = 17.0;

  bool tiltGesturesEnabled = true;
  bool zoomGesturesEnabled = true;
  bool rotateGesturesEnabled = true;
  bool scrollGesturesEnabled = true;
  bool modelsEnabled = true;
  bool nightModeEnabled = false;
  bool fastTapEnabled = false;
  bool mode2DEnabled = false;
  bool indoorEnabled = false;
  bool liteModeEnabled = false;
  ScreenRect? focusRect;
  MapType mapType = MapType.map;
  int? poiLimit;
  double currentSliderValue = _scale;

  void onArrowPressed(YandexMapController localController,
      {double left = 0,
      double right = 0,
      double up = 0,
      double down = 0}) async {
    final position = await localController.getCameraPosition();
    await localController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: Point(
                latitude: position.target.latitude + up - down,
                longitude: position.target.longitude + right - left))));
  }

  void setMinZoom(YandexMapController localController, double value) async {
    value = await localController.getMinZoom();
  }

  Future<double> getMaxZoom(YandexMapController localController) async {
    final maxZoom = await localController.getMaxZoom();
    return maxZoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        YandexMap(
          mapType: mapType,
          poiLimit: poiLimit,
          tiltGesturesEnabled: tiltGesturesEnabled,
          zoomGesturesEnabled: zoomGesturesEnabled,
          rotateGesturesEnabled: rotateGesturesEnabled,
          scrollGesturesEnabled: scrollGesturesEnabled,
          modelsEnabled: modelsEnabled,
          nightModeEnabled: nightModeEnabled,
          fastTapEnabled: fastTapEnabled,
          mode2DEnabled: mode2DEnabled,
          indoorEnabled: indoorEnabled,
          liteModeEnabled: liteModeEnabled,
          logoAlignment: const MapAlignment(
              horizontal: HorizontalAlignment.left,
              vertical: VerticalAlignment.bottom),
          focusRect: focusRect,
          onMapCreated: (YandexMapController yandexMapController) async {
            controller = yandexMapController;
            await controller.moveCamera(
                CameraUpdate.newCameraPosition(CameraPosition(
                    target: _myHomePoint, zoom: currentSliderValue)),
                animation: animation);
          },
          onMapTap: (Point point) async {
            await controller.deselectGeoObject();
          },
          onObjectTap: (GeoObject geoObject) async {
            if (geoObject.selectionMetadata != null) {
              await controller.selectGeoObject(geoObject.selectionMetadata!.id,
                  geoObject.selectionMetadata!.layerId);
            }
          },
        ),
        Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16)),
                        child: IconButton(
                            iconSize: 40,
                            color: Colors.black54,
                            onPressed: () async {
                              await controller.moveCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: _myHomePoint,
                                      zoom: currentSliderValue)),
                                  animation: animation);
                            },
                            icon: const Icon(Icons.home_outlined)),
                      ),
                    ],
                  )
                ],
              ),
            )),
        Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3 + 40,
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16)),
                        child: IconButton(
                            iconSize: 40,
                            color: Colors.black54,
                            onPressed: () async {
                              onArrowPressed(controller, left: shift);
                            },
                            icon: const Icon(Icons.arrow_circle_left_outlined)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: [
                            IconButton(
                                iconSize: 40,
                                color: Colors.black54,
                                onPressed: () async {
                                  onArrowPressed(controller, up: shift);
                                },
                                icon:
                                    const Icon(Icons.arrow_circle_up_outlined)),
                            IconButton(
                                iconSize: 40,
                                color: Colors.black54,
                                onPressed: () async {
                                  onArrowPressed(controller, down: shift);
                                },
                                icon: const Icon(
                                    Icons.arrow_circle_down_outlined)),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16)),
                        child: IconButton(
                            iconSize: 40,
                            color: Colors.black54,
                            onPressed: () async {
                              onArrowPressed(controller, right: shift);
                            },
                            icon:
                                const Icon(Icons.arrow_circle_right_outlined)),
                      ),
                    ],
                  )
                ],
              ),
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child:
              // MySlider(controller: controller,startZoom: currentSliderValue,),)
              SizedBox(
            height: 50,
            child: Slider(
              value: currentSliderValue,
              min: -10,
              max: _scale,
              divisions: 100,
              label: currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  currentSliderValue = value;
                  controller.moveCamera(CameraUpdate.zoomTo(currentSliderValue),
                      animation: animation);
                });
              },
            ),
          ),
        ),
      ]),
    );
  }
}
