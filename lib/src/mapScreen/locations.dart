/*
This file reads marker data from assets/locations.json
*/

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'locations.g.dart';

@JsonSerializable()
class LocLatLng {
  LocLatLng({
    required this.lat,
    required this.lng,
  });

  factory LocLatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  final double lat;
  final double lng;
}

@JsonSerializable() //Office -> Marker
class Marker {
  Marker(
      {required this.id,
      required this.image,
      required this.lat,
      required this.lng,
      required this.description,
      required this.type});

  factory Marker.fromJson(Map<String, dynamic> json) => _$MarkerFromJson(json);
  Map<String, dynamic> toJson() => _$MarkerToJson(this);

  final String id;
  final String image;
  final double lat;
  final double lng;
  final String description;
  final String type;
}

@JsonSerializable()
class Locations {
  Locations({
    required this.markers,
  });

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<Marker> markers;
}

Future<Locations> getGoogleMarkers() async {
  /*TODO get marker locations live
  const googleLocationsURL = 'https://about.google/static/data/locations.json';

  // Retrieve the locations of Google offices
  try {
    final response = await http.get(Uri.parse(googleLocationsURL));
    if (response.statusCode == 200) {
      return Locations.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  */

  // Fallback for when the above HTTP request fails.
  return Locations.fromJson(
    json.decode(
      await rootBundle.loadString('assets/locations.json'),
    ) as Map<String, dynamic>,
  );
}
