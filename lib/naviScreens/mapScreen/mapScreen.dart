import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition initPosition = CameraPosition(
    target: LatLng(36.05, 127.75),
    zoom: 7.2,
  );

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Set<Circle> circles = {};
  Set<Polygon> polygons = {};

  CameraPosition _currentCameraPosition = initPosition;

  //센터 계산을 위해서
  // Map 2개의 PolygonId는 같음
  Map<PolygonId, List<LatLng>> SIDO_Individual = {};
  Map<PolygonId, List<LatLng>> SIGUNGU_Individual = {};

  //한번에 표시하기 위해
  List<Polygon> SIDO_Polygons = [];
  Map<PolygonId, List<Polygon>> SIGUNGU_Polygons = {};

  //시도군구 이름 저장
  Map<PolygonId, String> SIDOGUNGU_Name = {};

  Map<PolygonId, LatLngBounds> polyBounds = {};

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
              // setState(() {
              //   markers.add(Marker(
              //     markerId: MarkerId(latLng.toString()),
              //     position: latLng,
              //     infoWindow: InfoWindow(title: "${latLng.latitude}/${latLng.longitude}"),
              //   ));
              //   controller.animateCamera(CameraUpdate.newLatLng(latLng));
              // });
            },
            onCameraMove: (CameraPosition position) {
              _currentCameraPosition = position;
            },
            onCameraIdle: () async {
              //showCurrentCenterPosition();
            },
          ),
          Positioned(
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: const Text('시도 표시'),
                    onPressed: () async {
                      //!시도
                      if (SIDO_Polygons.isEmpty) {
                        final String SIDOgeoJsonString = await rootBundle.loadString('assets/GeoJSON/BND_SIDO_PG.json');

                        final SIDOgeoJsonData = jsonDecode(SIDOgeoJsonString);
                        for (var feature in SIDOgeoJsonData['features']) {
                          var geometry = feature['geometry'];
                          var type = geometry['type'];
                          var coordinates = geometry['coordinates'];
                          String id = feature['properties']['SIDO_CD'].toString();
                          String name = feature['properties']['SIDO_NM'].toString();
                          SIDOGUNGU_Name[PolygonId(id)] = name;
                          void SIDO_Function() {
                            onSIDOPolygonTapped(PolygonId(id));
                          }
                          List<LatLng> allCoordinates = [];
                          late Polygon polygon;
                          if (type == 'Polygon') {
                            allCoordinates = coordinates[0].map<LatLng>((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble())).toList();
                            polygon = createPolygon(PolygonId(id), allCoordinates, 1, SIDO_Function);
                            SIDO_Polygons.add(polygon);
                          } else if (type == 'MultiPolygon') {
                            for (var i = 0; i < coordinates.length; i++) {
                              List<LatLng> tempCoordinates =
                                  coordinates[i][0].map<LatLng>((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble())).toList();
                              allCoordinates.addAll(tempCoordinates);
                              polygon = createPolygon(PolygonId("$id-$i"), tempCoordinates, 0, SIDO_Function);
                              SIDO_Polygons.add(polygon);
                            }
                          }
                          SIDO_Individual[PolygonId(id)] = allCoordinates;
                        }
                      }
                      //!시군구
                      if (SIGUNGU_Individual.isEmpty) {
                        final String SIGUNGUgeoJsonString = await rootBundle.loadString('assets/GeoJSON/BND_SIGUNGU_PG.json');
                        final SIGUNGUgeoJsonData = jsonDecode(SIGUNGUgeoJsonString);
                        for (var feature in SIGUNGUgeoJsonData['features']) {
                          var geometry = feature['geometry'];
                          if (geometry != null) {
                            var type = geometry['type'];
                            var coordinates = geometry['coordinates'];
                            String id = feature['properties']['SIGUNGU_CD'].toString();
                            String name = feature['properties']['SIGUNGU_NM'].toString();
                            SIDOGUNGU_Name[PolygonId(id)] = name;
                            String SIDO_ID = id.substring(0, 2);
                            void SIGUNGU_Function() {
                              onSIGUNGUPolygonTapped(PolygonId(id));
                            }

                            List<Polygon>? existing_SIGUNGU_Polygons = SIGUNGU_Polygons[PolygonId(SIDO_ID)];
                            List<Polygon> tempPoly = [];
                            List<LatLng> allCoordinates = [];
                            late Polygon polygon;
                            if (type == 'Polygon') {
                              allCoordinates = coordinates[0].map<LatLng>((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble())).toList();
                              polygon = createPolygon(PolygonId(id), allCoordinates, 2, SIGUNGU_Function);
                              tempPoly.add(polygon);
                            } else if (type == 'MultiPolygon') {
                              for (var i = 0; i < coordinates.length; i++) {
                                List<LatLng> tempCoordinates =
                                    coordinates[i][0].map<LatLng>((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble())).toList();
                                allCoordinates.addAll(tempCoordinates);
                                polygon = createPolygon(PolygonId("$id-$i"), tempCoordinates, 2, SIGUNGU_Function);
                                tempPoly.add(polygon);
                              }
                            }
                            if (existing_SIGUNGU_Polygons != null) {
                              existing_SIGUNGU_Polygons.addAll(tempPoly);
                              SIGUNGU_Polygons[PolygonId(SIDO_ID)] = existing_SIGUNGU_Polygons;
                            } else {
                              SIGUNGU_Polygons[PolygonId(SIDO_ID)] = List.from(tempPoly);
                            }
                            SIGUNGU_Individual[PolygonId(id)] = allCoordinates;
                          }
                        }
                      }
                      setState(() {
                        clearMap();
                        polygons = SIDO_Polygons.toSet();
                      });
                      final GoogleMapController controller = await _controller.future;
                      controller.animateCamera(CameraUpdate.newCameraPosition(initPosition));
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }

  createPolygon(PolygonId polygonId, List<LatLng> points, int zIndex, void Function()? onTapFunction) {
    Polygon polygon = Polygon(
        polygonId: polygonId,
        points: points,
        fillColor: Colors.black38,
        strokeColor: Colors.blue,
        strokeWidth: 3,
        zIndex: zIndex,
        consumeTapEvents: true,
        onTap: onTapFunction);
    return polygon;
  }

  void showCurrentCenterPosition() {
    Fluttertoast.showToast(
      msg: "Current Center: ${_currentCameraPosition.target.latitude}, ${_currentCameraPosition.target.longitude}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  // Method to handle polygon tap
  Future<void> onSIDOPolygonTapped(PolygonId polygonId) async {
    String id = polygonId.toString();
    if (id.contains('-')) {
      polygonId = PolygonId(id.split('-')[0]);
    }
    // Calculate bounds
    if (polyBounds[polygonId] == null) {
      polyBounds[polygonId] = calculatePolygonBounds(SIDO_Individual[polygonId]!);
    }
    clearMap();
    List<Polygon>? data = SIGUNGU_Polygons[polygonId];
    setState(() {
      polygons = SIDO_Polygons.toSet();
      if (data != null) {
        polygons.addAll(data.toSet());
      }
    });
    // Animate camera
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(polyBounds[polygonId]!, 20.0));
  }

  Future<void> onSIGUNGUPolygonTapped(PolygonId polygonId) async {
    String name = SIDOGUNGU_Name[polygonId] ?? '정보 없음';
    // Calculate bounds
    if (polyBounds[polygonId] == null) {
      polyBounds[polygonId] = calculatePolygonBounds(SIGUNGU_Individual[polygonId]!);
    }
    // Animate camera
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(polyBounds[polygonId]!, 60.0));
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          margin: const EdgeInsets.only(
            left: 25,
            right: 25,
            bottom: 40,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Text(name),
            ),
          ),
        );
      },
      backgroundColor: Colors.transparent, // 앱 <=> 모달의 여백 부분을 투명하게 처리
    );
  }

  // Calculate the bounds from polygon points
  LatLngBounds calculatePolygonBounds(List<LatLng> polygonPoints) {
    double? north, south, east, west;
    for (final point in polygonPoints) {
      if (north == null || point.latitude > north) north = point.latitude;
      if (south == null || point.latitude < south) south = point.latitude;
      if (east == null || point.longitude > east) east = point.longitude;
      if (west == null || point.longitude < west) west = point.longitude;
    }
    return LatLngBounds(northeast: LatLng(north!, east!), southwest: LatLng(south!, west!));
  }

  clearMap() {
    polylines.clear();
    circles.clear();
    polygons.clear();
  }
}
