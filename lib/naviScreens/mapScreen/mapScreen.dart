import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition initPosition = CameraPosition(
    target: LatLng(37.3626138, 126.9264801),
    zoom: 17.0,
  );

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Set<Circle> circles = {};
  Set<Polygon> polygons = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            polylines: polylines,
            circles: circles,
            polygons: polygons,
            markers: markers,
            initialCameraPosition: initPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: (LatLng latLng) async {
              final GoogleMapController controller = await _controller.future;

              setState(() {
                markers.add(Marker(
                  markerId: MarkerId(latLng.toString()),
                  position: latLng,
                  infoWindow: InfoWindow(title: "${latLng.latitude}/${latLng.longitude}"),
                ));
                controller.animateCamera(CameraUpdate.newLatLng(latLng));
              });
            },
          ),
          Positioned(
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: const Text('직선'),
                    onPressed: () {
                      List<LatLng> list = const [
                        LatLng(37.3625806, 126.9248464),
                        LatLng(37.3626138, 126.9264801),
                        LatLng(37.3632727, 126.9280313),
                      ];

                      setState(() {
                        clearMap();

                        polylines.add(Polyline(
                          polylineId: const PolylineId("1"),
                          points: list,
                          color: Colors.red,
                          width: 4,
                        ));

                        fitBounds(list);
                      });
                    },
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton(
                      child: const Text('원'),
                      onPressed: () {
                        LatLng center = const LatLng(37.3626138, 126.9264801);

                        clearMap();

                        setState(() {
                          circles.add(Circle(circleId: const CircleId("1"), center: center, radius: 34.0, strokeColor: Colors.red, strokeWidth: 4));
                        });
                      }),
                  const SizedBox(width: 4),
                  ElevatedButton(
                    child: const Text('다각형'),
                    onPressed: () {
                      List<LatLng> polygon1 = const [
                        LatLng(37.3625806, 126.9248464),
                        LatLng(37.3626138, 126.9264801),
                        LatLng(37.3632727, 126.9280313),
                      ];

                      List<LatLng> polygon2 = const [
                        LatLng(37.36119, 126.9193982),
                        LatLng(37.3534215, 126.9295909),
                        LatLng(37.3549206, 126.9327015),
                      ];

                      setState(() {
                        clearMap();

                        polygons.add(Polygon(polygonId: const PolygonId("1"), points: polygon1, fillColor: Colors.transparent, strokeColor: Colors.red, strokeWidth: 4));
                        polygons.add(Polygon(polygonId: const PolygonId("2"), points: polygon2, fillColor: Colors.transparent, strokeColor: Colors.red, strokeWidth: 4));

                        fitBounds([...polygon1, ...polygon2]);
                      });
                    },
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton(
                    child: const Text('다각형-반전'),
                    onPressed: () {
                      List<LatLng> polygon1 = const [
                        LatLng(37.3625806, 126.9248464),
                        LatLng(37.3626138, 126.9264801),
                        LatLng(37.3632727, 126.9280313),
                      ];

                      List<LatLng> polygon2 = const [
                        LatLng(37.36119, 126.9193982),
                        LatLng(37.3534215, 126.9295909),
                        LatLng(37.3549206, 126.9327015),
                      ];

                      setState(() {
                        clearMap();

                        polygons.add(
                          Polygon(
                            polygonId: const PolygonId("1"),
                            points: createOuterBounds(),
                            holes: [polygon1, polygon2],
                            fillColor: Colors.black38,
                            strokeColor: Colors.red,
                            strokeWidth: 4,
                          ),
                        );

                        fitBounds([...polygon1, ...polygon2]);
                      });
                    },
                  ),
                  const SizedBox(width: 4),
                ],
              )),
        ],
      ),
    );
  }

  List<LatLng> createOuterBounds() {
    double delta = 0.01;

    List<LatLng> list = [];

    list.add(LatLng(90 - delta, -180 + delta));
    list.add(LatLng(0, -180 + delta));
    list.add(LatLng(-90 + delta, -180 + delta));
    list.add(LatLng(-90 + delta, 0));
    list.add(LatLng(-90 + delta, 180 - delta));
    list.add(LatLng(0, 180 - delta));
    list.add(LatLng(90 - delta, 180 - delta));
    list.add(LatLng(90 - delta, 0));
    list.add(LatLng(90 - delta, -180 + delta));

    return list;
  }

  clearMap() {
    polylines.clear();
    circles.clear();
    polygons.clear();
  }

  fitBounds(List<LatLng> bounds) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(boundsFromLatLngList(bounds), 0));
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);

    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }
}