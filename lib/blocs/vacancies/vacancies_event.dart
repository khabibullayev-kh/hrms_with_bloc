part of 'vacancies_bloc.dart';


abstract class VacanciesEvent extends Equatable {
  const VacanciesEvent();
}

class VacanciesPageInitializeEvent extends VacanciesEvent {
  final BuildContext context;

  const VacanciesPageInitializeEvent(this.context);

  VacanciesPageInitializeEvent copyWith({
    BuildContext? context,
  }) {
    return VacanciesPageInitializeEvent(context ?? this.context);
  }

  @override
  List<Object?> get props => [context];
}

class VacanciesFetchEvent extends VacanciesEvent {
  final String query;
  final int page;
  final int? jobPositionId;
  final int? regionId;
  final int? recruiterId;
  final int? stateId;
  final int? branchId;
  final BuildContext context;

  const VacanciesFetchEvent({
    required this.query,
    required this.page,
    this.jobPositionId,
    this.regionId,
    this.recruiterId,
    this.stateId,
    this.branchId,
    required this.context,
  });

  VacanciesFetchEvent copyWith({
    String? query,
    int? page,
    int? jobPositionId,
    int? regionId,
    int? recruiterId,
    int? stateId,
    int? branchId,
    BuildContext? context,
  }) {
    return VacanciesFetchEvent(
      query: query ?? this.query,
      page: page ?? this.page,
      jobPositionId: jobPositionId,
      regionId: regionId,
      recruiterId: recruiterId,
      stateId: stateId,
      branchId: branchId,
      context: context ?? this.context,
    );
  }

  @override
  List<Object?> get props => [
    query,
    page,
    context,
    jobPositionId,
    regionId,
    recruiterId,
    stateId,
    branchId,
  ];
}

class VacanciesResetLoadEvent extends VacanciesEvent {

  const VacanciesResetLoadEvent();

  @override
  List<Object?> get props => [];
}

class VacanciesReloadEvent extends VacanciesEvent {
  final BuildContext context;

  const  VacanciesReloadEvent(
      this.context
      );

  VacanciesReloadEvent copyWith({
    BuildContext? context,
  }) {
    return VacanciesReloadEvent(
      context ?? this.context,
    );
  }

  @override
  List<Object?> get props => [context];
}
