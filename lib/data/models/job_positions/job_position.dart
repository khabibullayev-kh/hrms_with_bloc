import 'package:json_annotation/json_annotation.dart';

part 'job_position.g.dart';

@JsonSerializable()
class JobPosition {
  JobPosition({
    required this.id,
    this.slug,
    this.nameUz,
    this.nameRu,
    this.name,
    this.department,
  });

  int id;
  String? name;
  String? slug;
  String? nameUz;
  String? nameRu;
  String? department;

  factory JobPosition.fromJson(Map<String, dynamic> json) =>
      _$JobPositionFromJson(json);

  Map<String, dynamic> toJson() => _$JobPositionToJson(this);
}
