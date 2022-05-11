
import 'package:json_annotation/json_annotation.dart';

part 'ad_sources.g.dart';

@JsonSerializable()
class AdSource {
  AdSource({
    required this.id,
    required this.slug,
    required this.name,
  });

  int id;
  String slug;
  String name;

  factory AdSource.fromJson(Map<String, dynamic> json) =>
      _$AdSourceFromJson(json);

  Map<String, dynamic> toJson() => _$AdSourceToJson(this);
}