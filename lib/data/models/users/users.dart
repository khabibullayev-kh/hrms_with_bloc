import 'package:hrms/data/models/users/meta.dart';
import 'package:hrms/data/models/users/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'users.g.dart';

@JsonSerializable()
class UsersResponse {
  @JsonKey(name: 'result')
  final Result result;

  UsersResponse({
    required this.result,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UsersResponseToJson(this);
}

@JsonSerializable()
class Result {
  List<User> users;
  Meta meta;

  Result({
    required this.users,
    required this.meta,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}