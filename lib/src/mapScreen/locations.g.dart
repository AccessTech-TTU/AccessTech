// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLng _$LatLngFromJson(Map<String, dynamic> json) => LatLng(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$LatLngToJson(LatLng instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

Marker _$MarkerFromJson(Map<String, dynamic> json) => Marker(
      id: json['id'] as String,
      image: json['image'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      description: json['description'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$MarkerToJson(Marker instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'lat': instance.lat,
      'lng': instance.lng,
      'description': instance.description,
      'type': instance.type
    };

Locations _$LocationsFromJson(Map<String, dynamic> json) => Locations(
      markers: (json['markers'] as List<dynamic>)
          .map((e) => Marker.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationsToJson(Locations instance) => <String, dynamic>{
      'markers': instance.markers,
    };
