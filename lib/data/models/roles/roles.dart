import 'package:hrms/data/models/meta.dart';
import 'package:hrms/data/models/roles/role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'roles.g.dart';

@JsonSerializable()
class Roles {
  @JsonKey(name: 'result')
  final Result result;

  Roles({
    required this.result,
  });

  factory Roles.fromJson(Map<String, dynamic> json) =>
      _$RolesFromJson(json);

  Map<String, dynamic> toJson() => _$RolesToJson(this);
}

@JsonSerializable()
class Result {
  List<Role> roles;
  Meta? meta;

  Result({
    required this.roles,
    this.meta,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}