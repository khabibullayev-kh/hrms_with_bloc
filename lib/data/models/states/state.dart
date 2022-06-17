import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

@JsonSerializable()
class State {
  State({
    required this.id,
    this.name,
    this.nameUz,
    this.nameRu,
    this.slug,
    this.tableName,
  });

  int id;
  String? name;
  String? nameRu;
  String? nameUz;
  String? slug;
  String? tableName;

  factory State.fromJson(Map<String, dynamic> json) => _$StateFromJson(json);

  Map<String, dynamic> toJson() => _$StateToJson(this);
}
