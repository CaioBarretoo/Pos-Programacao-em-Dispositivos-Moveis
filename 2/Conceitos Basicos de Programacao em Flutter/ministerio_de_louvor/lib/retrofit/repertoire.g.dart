// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repertoire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repertoire _$RepertoireFromJson(Map<String, dynamic> json) => Repertoire(
      id: (json['id'] as num).toInt(),
      music: json['music'] as String,
      youtube: json['youtube'] as String,
      cifra: json['cifra'] as String,
    );

Map<String, dynamic> _$RepertoireToJson(Repertoire instance) =>
    <String, dynamic>{
      'id': instance.id,
      'music': instance.music,
      'youtube': instance.youtube,
      'cifra': instance.cifra,
    };
