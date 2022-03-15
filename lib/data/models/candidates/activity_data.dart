import 'package:hrms/data/models/director_rec_kadr_regman/director.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_data.g.dart';

@JsonSerializable()
class Activities {
  Activities({
    required this.data,
  });

  List<ActivitiesData>? data;

  factory Activities.fromJson(Map<String, dynamic> json) =>
      _$ActivitiesFromJson(json);

  Map<String, dynamic> toJson() => _$ActivitiesToJson(this);
}

@JsonSerializable()
class ActivitiesData {
  int? id;
  String? nameRu;
  String? nameUz;
  String? tableName;
  String? hint;
  int? objectId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Director? user;
  Comment? comment;

  ActivitiesData({
    required this.id,
    required this.nameRu,
    required this.nameUz,
    required this.tableName,
    required this.hint,
    required this.objectId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.comment,
  });

  factory ActivitiesData.fromJson(Map<String, dynamic> json) =>
      _$ActivitiesDataFromJson(json);

  Map<String, dynamic> toJson() => _$ActivitiesDataToJson(this);
}

@JsonSerializable()
class Comment {
  Comment({
    required this.id,
    required this.message,
    required this.createdAt,
  });

  int id;
  String message;
  DateTime createdAt;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
