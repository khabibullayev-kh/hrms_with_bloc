import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/models/users/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'candidates.g.dart';

@JsonSerializable()
class Candidates {
  @JsonKey(name: 'result')
  final Result result;

  Candidates({
    required this.result,
  });

  factory Candidates.fromJson(Map<String, dynamic> json) =>
      _$CandidatesFromJson(json);

  Map<String, dynamic> toJson() => _$CandidatesToJson(this);
}

@JsonSerializable()
class Result {
  List<Candidate> candidates;
  Counts counts;
  Meta? meta;

  Result({
    required this.candidates,
    required this.counts,
    required this.meta,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Counts {
  Counts({
    this.hot,
    this.countsNew,
    this.all,
    this.employed,
    this.newVacancies,
  });

  int? hot;
  int? countsNew;
  int? all;
  int? employed;
  int? newVacancies;

  factory Counts.fromJson(Map<String, dynamic> json) => _$CountsFromJson(json);

  Map<String, dynamic> toJson() => _$CountsToJson(this);
}
