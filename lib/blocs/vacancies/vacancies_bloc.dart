import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/director_rec_kadr_regman/director.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/data/models/region_district/district.dart';
import 'package:hrms/data/models/vacancy/vacancies.dart';
import 'package:hrms/data/models/vacancy/vacancy.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/vacancies_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/data/models/states/state.dart' as status;

part 'vacancies_event.dart';

part 'vacancies_state.dart';

class VacanciesContainer extends Equatable {
  final List<Vacancy> vacancies;
  final int currentPage;
  final int totalPage;
  final int countPerPage;
  final String sum;

  bool get isMaxPage => currentPage >= totalPage;

  const VacanciesContainer({
    required this.vacancies,
    required this.currentPage,
    required this.totalPage,
    required this.countPerPage,
    required this.sum,
  });

  const VacanciesContainer.initial()
      : vacancies = const <Vacancy>[],
        currentPage = 0,
        totalPage = 1,
        countPerPage = 1,
  sum = '1';

  VacanciesContainer copyWith({
    List<Vacancy>? vacancies,
    int? currentPage,
    int? totalPage,
    int? countPerPage,
    String? sum,
  }) {
    return VacanciesContainer(
      vacancies: vacancies ?? this.vacancies,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      countPerPage: countPerPage ?? this.countPerPage,
      sum: sum ?? this.sum,
    );
  }

  @override
  List<Object?> get props => [vacancies, currentPage, totalPage, countPerPage, sum];
}

class VacanciesBloc extends Bloc<VacanciesEvent, VacanciesState> {
  final _vacanciesService = VacanciesService();
  final _authService = AuthService();

  VacanciesBloc() : super(VacanciesState.initial()) {
    on<VacanciesEvent>(
      (event, emit) async {
        if (event is VacanciesPageInitializeEvent) {
          await onVacanciesPageInitialize(event, emit);
        } else if (event is VacanciesFetchEvent) {
          await onVacanciesFetch(event, emit);
        } else if (event is VacanciesResetLoadEvent) {
          await onVacanciesResetLoad(event, emit);
        } else if (event is VacanciesReloadEvent) {
          await onVacanciesReload(event, emit);
        }
      },
    );
  }

  Future<void> onVacanciesPageInitialize(
    VacanciesPageInitializeEvent event,
    Emitter<VacanciesState> emit,
  ) async {
    try {
      final results = await Future.wait([
        _vacanciesService.getVacancies(searchQuery: '', page: 1),
        _vacanciesService.getBranches(),
        _vacanciesService.getStates(),
        _vacanciesService.getJobPositions(null),
        _vacanciesService.getRoles(),
        _vacanciesService.getRegions(),
      ]);
      List<DropdownMenuItem<int?>> branchesItems = [dropDownItem];
      List<DropdownMenuItem<int?>> statesItems = [dropDownItem];
      List<DropdownMenuItem<int?>> jobPositionsItems = [dropDownItem];
      List<DropdownMenuItem<int?>> recruitersItems = [dropDownItem];
      List<DropdownMenuItem<int?>> regionsItems = [dropDownItem];
      final Branches branches = results[1];
      for (Branch branch in branches.result.branches) {
        branchesItems.add(
          DropdownMenuItem(
            child: Text(branch.name!),
            value: branch.id,
          ),
        );
      }
      final List<status.State> states = results[2];
      for (status.State state in states) {
        statesItems.add(
          DropdownMenuItem(
            child: Text(state.name!),
            value: state.id,
          ),
        );
      }
      final List<JobPosition> jobPositions = results[3];
      for (JobPosition jobPosition in jobPositions) {
        jobPositionsItems.add(
          DropdownMenuItem(
            child: Text(jobPosition.name!),
            value: jobPosition.id,
          ),
        );
      }
      final List<Director> recruiters = results[4];
      for (Director director in recruiters) {
        recruitersItems.add(
          DropdownMenuItem(
            child: Text(director.fullName),
            value: director.id,
          ),
        );
      }

      final List<District> regions = results[5];
      for (District district in regions) {
        regionsItems.add(
          DropdownMenuItem(
            child: Text(district.name!),
            value: district.id,
          ),
        );
      }
      final Vacancies vacancies = results[0];
      emit(state.copyWith(
          vacanciesStatus: VacanciesStatus.success,
          jobPositionsItem: jobPositionsItems,
          regionsItems: regionsItems,
          recruitersItems: recruitersItems,
          statesItems: statesItems,
          branchesItems: branchesItems,
          vacanciesContainer: VacanciesContainer(
            vacancies: vacancies.vacancy,
            currentPage: vacancies.meta!.pagination.currentPage,
            totalPage: vacancies.meta!.pagination.totalPages,
            countPerPage: vacancies.meta!.pagination.perPage,
            sum: vacancies.sum.toString(),
          )));
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onVacanciesFetch(
    VacanciesFetchEvent event,
    Emitter<VacanciesState> emit,
  ) async {
    if (state.searchQuery == event.query &&
        state.vacanciesStatus != VacanciesStatus.loading &&
        state.currentPage == event.page &&
        state.jobPositionId == event.jobPositionId &&
        state.branchId == event.branchId &&
        state.statesId == event.stateId) return;
    emit(state.copyWith(vacanciesStatus: VacanciesStatus.loading));
    try {
      final container = await _loadPage(
        state.vacanciesContainer,
        () async {
          final result = await _vacanciesService.getVacancies(
            searchQuery: event.query,
            page: event.page,
            jobPositionId: event.jobPositionId,
            regionId: event.regionId,
            recruiterId: event.recruiterId,
            branchId: event.branchId,
            stateId: event.stateId,
          );
          return result;
        },
      );

      if (container != null) {
        final newState = state.copyWith(
          vacanciesContainer: container,
          searchQuery: event.query,
          totalPage: container.totalPage,
          perPage: container.countPerPage,
          currentPage: container.currentPage,
          jobPositionId: event.jobPositionId,
          recruiterId: event.recruiterId,
          regionId: event.regionId,
          branchId: event.branchId,
          statesId: event.stateId,
          vacanciesStatus: VacanciesStatus.success,
        );
        emit(newState);

        if (container.vacancies.isEmpty) {
          emit(state.copyWith(
            vacanciesStatus: VacanciesStatus.nothingFound,
            searchQuery: event.query,
            jobPositionId: event.jobPositionId,
            recruiterId: event.recruiterId,
            regionId: event.regionId,
            branchId: event.branchId,
            statesId: event.stateId,
          ));
        }
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onVacanciesResetLoad(
    VacanciesResetLoadEvent event,
    Emitter<VacanciesState> emit,
  ) async {
    emit(state.copyWith(vacanciesStatus: VacanciesStatus.loading));
    final container = await _loadPage(
      state.vacanciesContainer,
      () async {
        final result = await _vacanciesService.getVacancies(
          searchQuery: '',
          page: 1,
          jobPositionId: null,
          regionId: null,
          recruiterId: null,
          stateId: null,
          branchId: null,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        vacanciesContainer: container,
        searchQuery: '',
        currentPage: 1,
        jobPositionId: null,
        regionId: null,
        recruiterId: null,
        statesId: null,
        branchId: null,
        perPage: container.countPerPage,
        vacanciesStatus: VacanciesStatus.success,
      );
      if (container.vacancies.isEmpty) {
        emit(
          state.copyWith(vacanciesStatus: VacanciesStatus.nothingFound),
        );
      } else {
        emit(newState);
      }
    }
  }

  void _handleApiClientException(
    ApiClientException exception,
    BuildContext context,
  ) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        throw UnimplementedError();
    }
  }

  Future<void> onVacanciesReload(
    VacanciesReloadEvent event,
    Emitter<VacanciesState> emit,
  ) async {
    emit(state.copyWith(vacanciesStatus: VacanciesStatus.loading));
    final container = await _loadPage(
      state.vacanciesContainer,
      () async {
        final result = await _vacanciesService.getVacancies(
          searchQuery: state.searchQuery,
          page: state.currentPage,
          jobPositionId: state.jobPositionId,
          regionId: state.regionId,
          recruiterId: state.recruiterId,
          branchId: state.branchId,
          stateId: state.statesId,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        vacanciesContainer: container,
        searchQuery: state.searchQuery,
        totalPage: container.totalPage,
        perPage: container.countPerPage,
        currentPage: container.currentPage,
        jobPositionId: state.jobPositionId,
        branchId: state.branchId,
        statesId: state.statesId,
        vacanciesStatus: VacanciesStatus.success,
      );
      emit(newState);
    }
  }

  Future<VacanciesContainer?> _loadPage(
    VacanciesContainer container,
    Future<Vacancies?> Function() loader,
  ) async {
    final result = await loader();
    final newContainer = container.copyWith(
      vacancies: result?.vacancy.toList(),
      currentPage: result?.meta!.pagination.currentPage,
      totalPage: result?.meta!.pagination.totalPages,
      countPerPage: result?.meta!.pagination.perPage,
      sum: result?.sum.toString(),
    );
    return newContainer;
  }
}
