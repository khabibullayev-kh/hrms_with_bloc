import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/users/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'branches.g.dart';

@JsonSerializable()
class Branches {
  @JsonKey(name: 'result')
  final Result result;

  Branches({
    required this.result,
  });

  factory Branches.fromJson(Map<String, dynamic> json) =>
      _$BranchesFromJson(json);

  Map<String, dynamic> toJson() => _$BranchesToJson(this);
}

@JsonSerializable()
class Result {
  List<Branch> branches;
  Meta? meta;

  Result({
    required this.branches,
    required this.meta,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}