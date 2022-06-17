import 'package:hrms/data/models/permissions/permission.dart';
import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

@JsonSerializable()
class Role {
  Role({
    required this.id,
    required this.name,
    this.nameUz,
    this.nameRu,
    this.permissions,
  });

  int id;
  String name;
  String? nameUz;
  String? nameRu;
  List<Permission>? permissions;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
