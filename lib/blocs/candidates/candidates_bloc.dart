import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/models/candidates/candidates.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/data/models/region_district/district.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/candidates_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/data/models/states/state.dart' as status;
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

part 'candidates_state.dart';

part 'candidates_event.dart';

class CandidatesContainer extends Equatable {
  final List<Candidate> candidates;
  final int currentPage;
  final int totalPage;
  final int countPerPage;
  final int hotCandidatesCount;

  bool get isMaxPage => currentPage >= totalPage;

  const CandidatesContainer({
    required this.candidates,
    required this.currentPage,
    required this.totalPage,
    required this.countPerPage,
    required this.hotCandidatesCount,
  });

  const CandidatesContainer.initial()
      : candidates = const <Candidate>[],
        currentPage = 0,
        totalPage = 1,
        countPerPage = 1,
        hotCandidatesCount = 0;

  CandidatesContainer copyWith({
    List<Candidate>? candidates,
    int? currentPage,
    int? totalPage,
    int? countPerPage,
    int? hotCandidatesCount,
  }) {
    return CandidatesContainer(
      candidates: candidates ?? this.candidates,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      countPerPage: countPerPage ?? this.countPerPage,
      hotCandidatesCount: hotCandidatesCount ?? this.hotCandidatesCount,
    );
  }

  @override
  List<Object?> get props =>
      [candidates, currentPage, totalPage, countPerPage, hotCandidatesCount];
}

class CandidatesBloc extends Bloc<CandidatesEvent, CandidatesState> {
  final _candidatesService = CandidatesService();
  final _authService = AuthService();

  CandidatesBloc() : super(CandidatesState.initial()) {
    on<CandidatesEvent>(
      (event, emit) async {
        if (event is CandidatesPageInitializeEvent) {
          await onCandidatesPageInitialize(event, emit);
        } else if (event is CandidatesFetchEvent) {
          await onCandidatesFetch(event, emit);
        } else if (event is CandidatesResetLoadEvent) {
          await onCandidatesResetLoad(event, emit);
        } else if (event is CandidatesReloadEvent) {
          await onCandidatesReload(event, emit);
        } else if (event is ShowHotCandidatesEvent) {
          await onShowHotCandidates(event, emit);
        }
      },
    );
  }

  Future<void> onShowHotCandidates(
    ShowHotCandidatesEvent event,
    Emitter<CandidatesState> emit,
  ) async {
    emit(state.copyWith(
      candidatesStatus: CandidatesStatus.loading,
      isShowingHotCandidates: !state.isShowingHotCandidates,
    ));
    try {
      final container = await _loadPage(
        state.candidatesContainer,
        () async {
          final result = await _candidatesService.getCandidates(
            searchQuery: '',
            page: 1,
            showOnlyHotCandidates: state.isShowingHotCandidates,
          );
          return result;
        },
      );

      if (container != null) {
        final newState = state.copyWith(
          candidatesContainer: container,
          totalPage: container.totalPage,
          perPage: container.countPerPage,
          currentPage: container.currentPage,
          isShowingHotCandidates: state.isShowingHotCandidates,
          candidatesStatus: CandidatesStatus.success,
        );
        emit(newState);
        if (container.candidates.isEmpty) {
          emit(state.copyWith(
            candidatesStatus: CandidatesStatus.nothingFound,
            isShowingHotCandidates: state.isShowingHotCandidates,
          ));
        }
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onCandidatesPageInitialize(
    CandidatesPageInitializeEvent event,
    Emitter<CandidatesState> emit,
  ) async {
    try {
      final results = await Future.wait([
        _candidatesService.getCandidates(searchQuery: '', page: 1),
        _candidatesService.getBranches(isPaginated: true),
        _candidatesService.getRegions(),
        _candidatesService.getStates(),
        _candidatesService.getJobPositions(),
      ]);
      List<DropdownMenuItem<int?>> regionItems = [dropDownItem];
      List<DropdownMenuItem<int?>> branchesItems = [dropDownItem];
      List<DropdownMenuItem<int?>> statesItems = [dropDownItem];
      List<DropdownMenuItem<int?>> jobPositionsItems = [dropDownItem];
      List<DropdownMenuItem<String?>> sexItems = [dropDownItem];
      List<DropdownMenuItem<String?>> sexItem =
          sexEnums.values.map((sexEnums classType) {
        return DropdownMenuItem<String?>(
          value: classType.convertToString ==  LocaleKeys.man.tr() ? 'MALE' : 'FEMALE',
          child: Text(classType.convertToString),
        );
      }).toList();
      sexItems.addAll(sexItem);
      final Branches branches = results[1];
      for (Branch branch in branches.result.branches) {
        branchesItems.add(
          DropdownMenuItem(
            child: Text(branch.name!),
            value: branch.id,
          ),
        );
      }
      final List<District> regions = results[2];
      for (District district in regions) {
        regionItems.add(
          DropdownMenuItem(
            child: Text(district.name!),
            value: district.id,
          ),
        );
      }
      final List<status.State> states = results[3];
      for (status.State state in states) {
        statesItems.add(
          DropdownMenuItem(
            child: Text(state.name!),
            value: state.id,
          ),
        );
      }
      final List<JobPosition> jobPositions = results[4];
      for (JobPosition jobPosition in jobPositions) {
        jobPositionsItems.add(
          DropdownMenuItem(
            child: Text(jobPosition.name!),
            value: jobPosition.id,
          ),
        );
      }
      final Candidates candidates = results[0];
      emit(state.copyWith(
          candidatesStatus: CandidatesStatus.success,
          regionItems: regionItems,
          sexItems: sexItems,
          jobPositionItems: jobPositionsItems,
          statesItems: statesItems,
          branchesItems: branchesItems,
          candidatesContainer: CandidatesContainer(
            candidates: candidates.result.candidates,
            currentPage: candidates.result.meta!.pagination.currentPage,
            totalPage: candidates.result.meta!.pagination.totalPages,
            countPerPage: candidates.result.meta!.pagination.perPage,
            hotCandidatesCount: candidates.result.hotCandidatesCount,
          )));
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onCandidatesFetch(
    CandidatesFetchEvent event,
    Emitter<CandidatesState> emit,
  ) async {
    if (state.searchQuery == event.query &&
        state.candidatesStatus != CandidatesStatus.loading &&
        state.currentPage == event.page &&
        state.sex == event.sex &&
        event.jobPositionId == state.jobPositionId &&
        state.regionId == event.regionId &&
        state.branchId == event.branchId &&
        state.statesId == event.stateId) return;
    emit(state.copyWith(candidatesStatus: CandidatesStatus.loading));
    try {
      final container = await _loadPage(
        state.candidatesContainer,
        () async {
          final result = await _candidatesService.getCandidates(
            searchQuery: event.query,
            page: event.page,
            sex: event.sex,
            jobPositionId: event.jobPositionId,
            regionId: event.regionId,
            branchId: event.branchId,
            stateId: event.stateId,
            showOnlyHotCandidates: state.isShowingHotCandidates,
          );
          return result;
        },
      );

      if (container != null) {
        final newState = state.copyWith(
          candidatesContainer: container,
          searchQuery: event.query,
          totalPage: container.totalPage,
          perPage: container.countPerPage,
          currentPage: container.currentPage,
          sex: event.sex,
          jobPositionId: event.jobPositionId,
          regionId: event.regionId,
          branchId: event.branchId,
          statesId: event.stateId,
          candidatesStatus: CandidatesStatus.success,
        );
        emit(newState);

        if (container.candidates.isEmpty) {
          emit(state.copyWith(
            candidatesStatus: CandidatesStatus.nothingFound,
            searchQuery: event.query,
            totalPage: container.totalPage,
            perPage: container.countPerPage,
            currentPage: container.currentPage,
            sex: event.sex,
            jobPositionId: event.jobPositionId,
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

  Future<void> onCandidatesResetLoad(
    CandidatesResetLoadEvent event,
    Emitter<CandidatesState> emit,
  ) async {
    emit(state.copyWith(candidatesStatus: CandidatesStatus.loading));
    final container = await _loadPage(
      state.candidatesContainer,
      () async {
        final result = await _candidatesService.getCandidates(
          searchQuery: '',
          page: 1,
          jobPositionId: null,
          stateId: null,
          sex: null,
          branchId: null,
          regionId: null,
          showOnlyHotCandidates: false,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        candidatesContainer: container,
        searchQuery: '',
        currentPage: 1,
        perPage: container.countPerPage,
        candidatesStatus: CandidatesStatus.success,
      );
      if (container.candidates.isEmpty) {
        emit(
          state.copyWith(
            candidatesStatus: CandidatesStatus.nothingFound,
          ),
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

  Future<void> onCandidatesReload(
    CandidatesReloadEvent event,
    Emitter<CandidatesState> emit,
  ) async {
    emit(state.copyWith(candidatesStatus: CandidatesStatus.loading));
    final container = await _loadPage(
      state.candidatesContainer,
      () async {
        final result = await _candidatesService.getCandidates(
          searchQuery: state.searchQuery,
          page: state.currentPage,
          sex: event.sex,
          jobPositionId: event.jobPositionId,
          regionId: event.regionId,
          branchId: event.branchId,
          stateId: event.stateId,
          showOnlyHotCandidates: state.isShowingHotCandidates,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        candidatesContainer: container,
        searchQuery: state.searchQuery,
        totalPage: container.totalPage,
        perPage: container.countPerPage,
        currentPage: container.currentPage,
        sex: event.sex,
        jobPositionId: event.jobPositionId,
        regionId: event.regionId,
        branchId: event.branchId,
        statesId: event.stateId,
        isShowingHotCandidates: state.isShowingHotCandidates,
        candidatesStatus: CandidatesStatus.success,
      );
      emit(newState);
    }
  }

  Future<CandidatesContainer?> _loadPage(
    CandidatesContainer container,
    Future<Candidates?> Function() loader,
  ) async {
    final result = await loader();
    final newContainer = container.copyWith(
      candidates: result?.result.candidates.toList(),
      currentPage: result?.result.meta!.pagination.currentPage,
      totalPage: result?.result.meta!.pagination.totalPages,
      countPerPage: result?.result.meta!.pagination.perPage,
      hotCandidatesCount: result?.result.hotCandidatesCount,
    );
    return newContainer;
  }
}
