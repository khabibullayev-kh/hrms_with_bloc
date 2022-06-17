part of 'candidates_bloc.dart';

abstract class CandidatesEvent extends Equatable {
  const CandidatesEvent();
}

class CandidatesPageInitializeEvent extends CandidatesEvent {
  final BuildContext context;

  const CandidatesPageInitializeEvent(this.context);

  CandidatesPageInitializeEvent copyWith({
    BuildContext? context,
  }) {
    return CandidatesPageInitializeEvent(context ?? this.context);
  }

  @override
  List<Object?> get props => [context];
}

class CandidatesFetchEvent extends CandidatesEvent {
  final String query;
  final int page;
  final String? sex;
  final int? jobPositionId;
  final int? stateId;
  final int? regionId;
  final int? branchId;
  final BuildContext context;

  const CandidatesFetchEvent({
    required this.query,
    required this.page,
    this.sex,
    this.jobPositionId,
    this.stateId,
    this.regionId,
    this.branchId,
    required this.context,
  });

  CandidatesFetchEvent copyWith({
    String? query,
    int? page,
    String? sex,
    int? jobPositionId,
    int? stateId,
    int? regionId,
    int? branchId,
    BuildContext? context,
  }) {
    return CandidatesFetchEvent(
      query: query ?? this.query,
      page: page ?? this.page,
      sex: sex,
      jobPositionId: jobPositionId,
      stateId: stateId,
      regionId: regionId,
      branchId: branchId,
      context: context ?? this.context,
    );
  }

  @override
  List<Object?> get props => [
        query,
        page,
        context,
        sex,
        jobPositionId,
        stateId,
        regionId,
        branchId,
      ];
}

class CandidatesResetLoadEvent extends CandidatesEvent {
  final String query;
  final int page;

  const CandidatesResetLoadEvent(this.query, this.page);

  CandidatesResetLoadEvent copyWith({
    String? query,
    int? page,
  }) {
    return CandidatesResetLoadEvent(query ?? this.query, page ?? this.page);
  }

  @override
  List<Object?> get props => [query, page];
}

class CandidatesReloadEvent extends CandidatesEvent {
  final String? sex;
  final int? jobPositionId;
  final int? stateId;
  final int? regionId;
  final int? branchId;
  final BuildContext context;

  const  CandidatesReloadEvent(
      {
    required this.context,
    required this.sex,
    required this.jobPositionId,
    required this.stateId,
    required this.regionId,
    required this.branchId,
  });

  CandidatesReloadEvent copyWith({
    BuildContext? context,
    String? sex,
    int? jobPositionId,
    int? stateId,
    int? regionId,
    int? branchId,
  }) {
    return CandidatesReloadEvent(
      context: context ?? this.context,
      sex: sex,
      jobPositionId: jobPositionId,
      stateId: stateId,
      regionId: regionId,
      branchId: branchId,
    );
  }

  @override
  List<Object?> get props => [context];
}

class ShowHotCandidatesEvent extends CandidatesEvent {
  final bool isHotCandidates;
  final BuildContext context;

  const ShowHotCandidatesEvent(this.isHotCandidates, this.context);

  ShowHotCandidatesEvent copyWith({
    bool? isHotCandidates,
    BuildContext? context,
  }) {
    return ShowHotCandidatesEvent(isHotCandidates ?? this.isHotCandidates, context ?? this.context);
  }

  @override
  List<Object?> get props => [isHotCandidates, context];
}
