// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Music _$MusicFromJson(Map<String, dynamic> json) => Music(
      id: (json['id'] as num).toInt(),
      music: json['music'] as String,
      youtube: json['youtube'] as String,
      cifra: json['cifra'] as String,
    );

Map<String, dynamic> _$MusicToJson(Music instance) => <String, dynamic>{
      'id': instance.id,
      'music': instance.music,
      'youtube': instance.youtube,
      'cifra': instance.cifra,
    };
