import 'package:json_annotation/json_annotation.dart';

part 'auth_info.g.dart';

@JsonSerializable()
class AuthInfo {
  int? id;
  String firstName;
  String lastName;
  String? username;
  String? sex;
  String? email;
  String? role;
  List<String>? permissions;
  DateTime? createdAt;

  AuthInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.sex,
    required this.email,
    required this.role,
    required this.permissions,
    required this.createdAt,
  });

  factory AuthInfo.fromJson(Map<String, dynamic> json) => _$AuthInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthInfoToJson(this);
}
