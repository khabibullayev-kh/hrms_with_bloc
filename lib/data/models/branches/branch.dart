import 'package:hrms/data/models/director_rec_kadr_regman/director.dart';
import 'package:hrms/data/models/region_district/district.dart';
import 'package:json_annotation/json_annotation.dart';

part 'branch.g.dart';

@JsonSerializable()
class Branch {
  int id;
  String? address;
  DateTime? createdAt;
  String? name;
  String? nameUz;
  String? nameRu;
  @JsonKey(name: 'region')
  District? region;
  District? district;
  String? landmark;
  String? shopCategory;
  String? slug;
  //String freeVacancySum;
  Director? director;
  @JsonKey(name: 'recruiters')
  List<Director>? recruiters;
  @JsonKey(name: 'personnel_officers')
  List<Director>? kadrs;
  @JsonKey(name: 'regional_manager')
  Director? regionalManager;

  Branch({
    required this.id,
    required this.address,
    required this.createdAt,
    required this.name,
    required this.nameUz,
    required this.nameRu,
    required this.region,
    required this.district,
    required this.landmark,
    required this.shopCategory,
    required this.slug,
    //required this.freeVacancySum,
    required this.director,
    required this.recruiters,
    required this.kadrs,
    required this.regionalManager,
  });

  factory Branch.fromJson(Map<String, dynamic> json) =>
      _$BranchFromJson(json);

  Map<String, dynamic> toJson() => _$BranchToJson(this);

}