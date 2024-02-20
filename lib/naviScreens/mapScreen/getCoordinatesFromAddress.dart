import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

Future<LatLng> getCoordinatesFromAddress(String address) async {
  await dotenv.load(fileName: "secrets.env");
  final apiKey = dotenv.env['geoCoding'];

  final String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeFull(address)}&key=$apiKey';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data['results'].isNotEmpty) {
      var firstResult = data['results'][0]['geometry']['location'];
      var lat = firstResult['lat'];
      var lng = firstResult['lng'];
      return LatLng(lat, lng);
    } else {
      throw Exception('No results found');
    }
  } else {
    throw Exception('Failed to load coordinates');
  }
}
