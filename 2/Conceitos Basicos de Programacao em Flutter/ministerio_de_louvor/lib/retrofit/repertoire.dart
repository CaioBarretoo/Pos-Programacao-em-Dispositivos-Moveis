import 'package:json_annotation/json_annotation.dart';

part 'repertoire.g.dart';

@JsonSerializable()
class Repertoire {
  final int id;
  final String music;
  final String youtube;
  final String cifra;

  Repertoire(
      {required this.id,
      required this.music,
      required this.youtube,
      required this.cifra});

  factory Repertoire.fromJson(Map<String, dynamic> json) =>
      _$RepertoireFromJson(json);

  Map<String, dynamic> toJson() => _$RepertoireToJson(this);
}
