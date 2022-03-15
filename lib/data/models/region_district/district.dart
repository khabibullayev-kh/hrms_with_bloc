import 'package:json_annotation/json_annotation.dart';

part 'district.g.dart';

@JsonSerializable()
class District {
  int id;
  String? name;
  String? nameUz;
  String? nameRu;

  District({
    required this.id,
    required this.name,
    required this.nameUz,
    required this.nameRu,
  });

  factory District.fromJson(Map<String, dynamic> json) =>
      _$DistrictFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictToJson(this);
}