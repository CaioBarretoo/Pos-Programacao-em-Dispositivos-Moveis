// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoData _$GeoDataFromJson(Map<String, dynamic> json) => GeoData(
      query: json['query'] as String?,
      country: json['country'] as String?,
      countryCode: json['countryCode'] as String?,
      region: json['region'] as String?,
      regionName: json['regionName'] as String?,
      city: json['city'] as String?,
      zip: json['zip'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GeoDataToJson(GeoData instance) => <String, dynamic>{
      'query': instance.query,
      'country': instance.country,
      'countryCode': instance.countryCode,
      'region': instance.region,
      'regionName': instance.regionName,
      'city': instance.city,
      'zip': instance.zip,
      'lat': instance.lat,
      'lon': instance.lon,
    };
