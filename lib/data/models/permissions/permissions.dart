import 'package:hrms/data/models/meta.dart';
import 'package:hrms/data/models/permissions/permission.dart';
import 'package:json_annotation/json_annotation.dart';

part 'permissions.g.dart';

@JsonSerializable()
class Permissions {
  @JsonKey(name: 'result')
  final Result result;

  Permissions({
    required this.result,
  });

  factory Permissions.fromJson(Map<String, dynamic> json) =>
      _$PermissionsFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionsToJson(this);
}

@JsonSerializable()
class Result {
  List<Permission> permissions;
  Meta? meta;

  Result({
    required this.permissions,
    required this.meta,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}