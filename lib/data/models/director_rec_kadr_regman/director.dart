import 'package:json_annotation/json_annotation.dart';

part 'director.g.dart';


@JsonSerializable()
class Director {
  int id;
  String fullName;

  Director({
    required this.id,
    required this.fullName,
  });


  factory Director.fromJson(Map<String, dynamic> json) =>
      _$DirectorFromJson(json);

  Map<String, dynamic> toJson() => _$DirectorToJson(this);
}