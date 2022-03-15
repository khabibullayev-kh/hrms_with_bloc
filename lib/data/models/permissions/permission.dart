import 'package:json_annotation/json_annotation.dart';

part 'permission.g.dart';

@JsonSerializable()
class Permission {
  Permission({
    required this.id,
    required this.name,
    required this.nameUz,
    required this.nameRu,
  });

  int id;
  String name;
  String nameUz;
  String nameRu;

  factory Permission.fromJson(Map<String, dynamic> json) => _$PermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionToJson(this);
}
