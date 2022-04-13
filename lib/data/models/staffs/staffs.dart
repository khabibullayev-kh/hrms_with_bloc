import 'package:hrms/data/models/users/meta.dart';
import 'package:hrms/data/models/staffs/quantity.dart';
import 'package:hrms/data/models/staffs/staff.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staffs.g.dart';

@JsonSerializable()
class Staffs {
  @JsonKey(name: 'result')
  final Result result;

  Staffs({
    required this.result,
  });

  factory Staffs.fromJson(Map<String, dynamic> json) =>
      _$StaffsFromJson(json);

  Map<String, dynamic> toJson() => _$StaffsToJson(this);
}

@JsonSerializable()
class Result {
  List<Staff> staffs;
  List<Quantity>? qty;
  Meta? meta;

  Result({
    required this.staffs,
    required this.qty,
    required this.meta,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

