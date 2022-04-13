import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/data/models/shifts/shift.dart';
import 'package:hrms/data/models/shifts/shifts.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/shifts_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/data/models/states/state.dart' as status;

part 'shifts_event.dart';

part 'shifts_state.dart';

class ShiftsContainer extends Equatable {
  final List<Shift> shifts;
  final int currentPage;
  final int totalPage;
  final int countPerPage;

  bool get isMaxPage => currentPage >= totalPage;

  const ShiftsContainer({
    required this.shifts,
    required this.currentPage,
    required this.totalPage,
    required this.countPerPage,
  });

  const ShiftsContainer.initial()
      : shifts = const <Shift>[],
        currentPage = 0,
        totalPage = 1,
        countPerPage = 1;

  ShiftsContainer copyWith({
    List<Shift>? shifts,
    int? currentPage,
    int? totalPage,
    int? countPerPage,
  }) {
    return ShiftsContainer(
      shifts: shifts ?? this.shifts,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      countPerPage: countPerPage ?? this.countPerPage,
    );
  }

  @override
  List<Object?> get props => [shifts, currentPage, totalPage, countPerPage];
}

class ShiftsBloc extends Bloc<ShiftsEvent, ShiftsState> {
  final _shiftsService = ShiftsService();
  final _authService = AuthService();

  ShiftsBloc() : super(ShiftsState.initial()) {
    on<ShiftsEvent>(
      (event, emit) async {
        if (event is ShiftsPageInitializeEvent) {
          await onShiftsPageInitialize(event, emit);
        } else if (event is ShiftsFetchEvent) {
          await onShiftsFetch(event, emit);
        } else if (event is ShiftsResetLoadEvent) {
          await onShiftsResetLoad(event, emit);
        } else if (event is ShiftsReloadEvent) {
          await onShiftsReload(event, emit);
        }
      },
    );
  }

  Future<void> onShiftsPageInitialize(
    ShiftsPageInitializeEvent event,
    Emitter<ShiftsState> emit,
  ) async {
    try {
      final results = await Future.wait([
        _shiftsService.getShifts(searchQuery: '', page: 1),
        _shiftsService.getBranches(),
        _shiftsService.getStates(),
        _shiftsService.getJobPositions(),
      ]);
      List<DropdownMenuItem<int?>> branchesItems = [dropDownItem];
      List<DropdownMenuItem<int?>> statesItems = [dropDownItem];
      List<DropdownMenuItem<int?>> jobPositionsItems = [dropDownItem];
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
      final Shifts shifts = results[0];
      emit(state.copyWith(
          shiftsStatus: ShiftsStatus.success,
          toJobPositionsItem: jobPositionsItems,
          statesItems: statesItems,
          branchesItems: branchesItems,
          shiftsContainer: ShiftsContainer(
            shifts: shifts.result.shifts,
            currentPage: shifts.result.meta!.pagination.currentPage,
            totalPage: shifts.result.meta!.pagination.totalPages,
            countPerPage: shifts.result.meta!.pagination.perPage,
          )));
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onShiftsFetch(
    ShiftsFetchEvent event,
    Emitter<ShiftsState> emit,
  ) async {
    if (state.searchQuery == event.query &&
        state.shiftsStatus != ShiftsStatus.loading &&
        state.currentPage == event.page &&
        state.toJobPositionsId == event.toJobPositionId &&
        state.branchId == event.branchId &&
        state.statesId == event.stateId) return;
    emit(state.copyWith(shiftsStatus: ShiftsStatus.loading));
    try {
      final container = await _loadPage(
        state.shiftsContainer,
        () async {
          final result = await _shiftsService.getShifts(
            searchQuery: event.query,
            page: event.page,
            toJobPositionId: event.toJobPositionId,
            branchId: event.branchId,
            stateId: event.stateId,
          );
          return result;
        },
      );

      if (container != null) {
        final newState = state.copyWith(
          shiftsContainer: container,
          searchQuery: event.query,
          totalPage: container.totalPage,
          perPage: container.countPerPage,
          currentPage: container.currentPage,
          toJobPositionId: event.toJobPositionId,
          branchId: event.branchId,
          statesId: event.stateId,
          shiftsStatus: ShiftsStatus.success,
        );
        emit(newState);
        if (container.shifts.isEmpty) {
          emit(state.copyWith(
            shiftsStatus: ShiftsStatus.nothingFound,
            searchQuery: event.query,
            totalPage: container.totalPage,
            perPage: container.countPerPage,
            currentPage: container.currentPage,
            toJobPositionId: event.toJobPositionId,
            branchId: event.branchId,
            statesId: event.stateId,
          ));
        }
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onShiftsResetLoad(
    ShiftsResetLoadEvent event,
    Emitter<ShiftsState> emit,
  ) async {
    emit(state.copyWith(shiftsStatus: ShiftsStatus.loading));
    final container = await _loadPage(
      state.shiftsContainer,
      () async {
        final result = await _shiftsService.getShifts(
          searchQuery: '',
          page: 1,
          toJobPositionId: null,
          stateId: null,
          branchId: null,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        shiftsContainer: container,
        searchQuery: '',
        currentPage: 1,
        toJobPositionId: null,
        statesId: null,
        branchId: null,
        perPage: container.countPerPage,
        shiftsStatus: ShiftsStatus.success,
      );
      if (container.shifts.isEmpty) {
        emit(
          state.copyWith(
            shiftsStatus: ShiftsStatus.nothingFound,
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

  Future<void> onShiftsReload(
    ShiftsReloadEvent event,
    Emitter<ShiftsState> emit,
  ) async {
    emit(state.copyWith(shiftsStatus: ShiftsStatus.loading));
    final container = await _loadPage(
      state.shiftsContainer,
      () async {
        final result = await _shiftsService.getShifts(
          searchQuery: state.searchQuery,
          page: state.currentPage,
          toJobPositionId: state.toJobPositionsId,
          stateId: state.statesId,
          branchId: state.branchId,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        shiftsContainer: container,
        searchQuery: event.query,
        totalPage: container.totalPage,
        perPage: container.countPerPage,
        currentPage: event.page,
        toJobPositionId: event.toJobPositionId,
        branchId: event.branchId,
        statesId: event.stateId,
        shiftsStatus: ShiftsStatus.success,
      );
      emit(newState);
    }
  }

  Future<ShiftsContainer?> _loadPage(
    ShiftsContainer container,
    Future<Shifts?> Function() loader,
  ) async {
    final result = await loader();
    final newContainer = container.copyWith(
      shifts: result?.result.shifts.toList(),
      currentPage: result?.result.meta!.pagination.currentPage,
      totalPage: result?.result.meta!.pagination.totalPages,
      countPerPage: result?.result.meta!.pagination.perPage,
    );
    return newContainer;
  }
}
