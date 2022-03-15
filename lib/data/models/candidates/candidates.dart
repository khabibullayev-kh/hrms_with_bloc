import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/models/meta.dart';
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
  int hotCandidatesCount;
  Meta? meta;

  Result({
    required this.candidates,
    required this.hotCandidatesCount,
    required this.meta,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}