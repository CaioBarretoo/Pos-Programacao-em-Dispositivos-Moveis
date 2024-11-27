import 'package:json_annotation/json_annotation.dart';

part 'music.g.dart';

@JsonSerializable()
class Music {
  final int id;
  final String music;
  final String youtube;
  final String cifra;

  Music({required this.id, required this.music, required this.youtube, required this.cifra});

  factory Music.fromJson(Map<String, dynamic> json) => _$MusicFromJson(json);

  Map<String, dynamic> toJson() => _$MusicToJson(this);
}