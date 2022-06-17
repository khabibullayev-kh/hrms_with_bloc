import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';


@JsonSerializable()
class User {
  int id;
  int? personId;
  String? firstName;
  String? lastName;
  String username;
  String? sex;
  String? email;
  String role;
  int roleId;

  User({
    required this.id,
    required this.personId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.sex,
    required this.email,
    required this.role,
    required this.roleId,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
