
import 'package:json_annotation/json_annotation.dart';

part 'education.g.dart';

@JsonSerializable()
class Education {
  int id;
  String name;
  String nameUz;
  String nameRu;

  Education({
    required this.id,
    required this.name,
    required this.nameUz,
    required this.nameRu,
  });

  factory Education.fromJson(Map<String, dynamic> json) => _$EducationFromJson(json);

  Map<String, dynamic> toJson() => _$EducationToJson(this);
}
