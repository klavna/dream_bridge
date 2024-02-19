class GeoFeature {
  final String type;
  final Geometry geometry;
  final Properties properties;

  GeoFeature({
    required this.type,
    required this.geometry,
    required this.properties,
  });

  factory GeoFeature.fromJson(Map<String, dynamic> json) {
    // geometry와 properties를 처리하기 전에 각각의 맵을 명시적으로 변환
    Map<String, dynamic> geometryJson = Map<String, dynamic>.from(json['geometry']);
    Map<String, dynamic> propertiesJson = Map<String, dynamic>.from(json['properties']);

    return GeoFeature(
      type: json['type'],
      geometry: Geometry.fromJson(geometryJson),
      properties: Properties.fromJson(propertiesJson),
    );
  }

}

class Geometry {
  final String type;
  final List<List<List<List<double>>>> coordinates;

  Geometry({
    required this.type,
    required this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    var coordinatesList = json['coordinates'];
    List<List<List<List<double>>>> parsedCoordinates = [];

    String type = json['type'];
    if (type == 'Polygon') {
      List<List<List<double>>> polygon = [];
      for (var linearRing in coordinatesList) {
        List<List<double>> ring = [];
        for (var coord in linearRing) {
          List<double> point = coord.map<double>((value) {
            // value가 int일 경우 double로 변환, 그렇지 않으면 (이미 double이면) 그대로 사용
            return (value is int) ? value.toDouble() : (value as double);
          }).toList();

          ring.add(point);
        }
        polygon.add(ring);
      }
      parsedCoordinates.add(polygon);
    } else if (type == 'MultiPolygon') {
      for (var polygon in coordinatesList) {
        List<List<List<double>>> multiPolygon = [];
        for (var linearRing in polygon) {
          List<List<double>> ring = [];
          for (var coord in linearRing) {
            List<double> point = coord.map<double>((value) {
              // value가 int일 경우 double로 변환, 그렇지 않으면 (이미 double이면) 그대로 사용
              return (value is int) ? value.toDouble() : (value as double);
            }).toList();

            ring.add(point);
          }
          multiPolygon.add(ring);
        }
        parsedCoordinates.add(multiPolygon);
      }
    }

    return Geometry(
      type: type,
      coordinates: parsedCoordinates,
    );
  }


}

class Properties {
  final String baseDate;
  final String sidoCd;
  final String sidoNm;

  Properties({
    required this.baseDate,
    required this.sidoCd,
    required this.sidoNm,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      baseDate: json['BASE_DATE'],
      sidoCd: json['SIDO_CD'],
      sidoNm: json['SIDO_NM'],
    );
  }
}
