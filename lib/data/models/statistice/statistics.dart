
import 'package:json_annotation/json_annotation.dart';

part 'statistics.g.dart';

@JsonSerializable()
class Statistics {
  int id;
  String? label;
  String? name;
  int? sortId;
  Object value;

  Statistics({
    required this.id,
    required this.label,
    required this.name,
    required this.sortId,
    required this.value,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) =>
      _$StatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticsToJson(this);
}
