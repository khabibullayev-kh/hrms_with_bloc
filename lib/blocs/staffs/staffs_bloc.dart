import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/departments/department.dart';
import 'package:hrms/data/models/departments/departments.dart';
import 'package:hrms/data/models/staffs/quantity.dart';
import 'package:hrms/data/models/staffs/staff.dart';
import 'package:hrms/data/models/staffs/staffs.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/staffs_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/data/models/states/state.dart' as status;

part 'staffs_event.dart';

part 'staffs_state.dart';

class StaffsContainer extends Equatable {
  final List<Staff> staffs;
  final List<Quantity> qty;
  final int currentPage;
  final int totalPage;
  final int countPerPage;

  bool get isMaxPage => currentPage >= totalPage;

  const StaffsContainer({
    required this.staffs,
    required this.qty,
    required this.currentPage,
    required this.totalPage,
    required this.countPerPage,
  });

  const StaffsContainer.initial()
      : staffs = const <Staff>[],
  qty = const <Quantity>[],
        currentPage = 0,
        totalPage = 1,
        countPerPage = 1;

  StaffsContainer copyWith({
    List<Staff>? staffs,
    List<Quantity>? qty,
    int? currentPage,
    int? totalPage,
    int? countPerPage,
  }) {
    return StaffsContainer(
      staffs: staffs ?? this.staffs,
      qty: qty ?? this.qty,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      countPerPage: countPerPage ?? this.countPerPage,
    );
  }

  @override
  List<Object?> get props => [staffs,qty, currentPage, totalPage, countPerPage];
}

class StaffsBloc extends Bloc<StaffsEvent, StaffsState> {
  final _staffsService = StaffsService();
  final _authService = AuthService();

  StaffsBloc() : super(StaffsState.initial()) {
    on<StaffsEvent>(
      (event, emit) async {
        if (event is StaffsPageInitializeEvent) {
          await onStaffsPageInitialize(event, emit);
        } else if (event is StaffsFetchEvent) {
          await onStaffsFetch(event, emit);
        } else if (event is StaffsResetLoadEvent) {
          await onStaffsResetLoad(event, emit);
        } else if (event is StaffsReloadEvent) {
          await onStaffsReload(event, emit);
        } else if (event is StaffsDeleteEvent) {
          await onStaffDelete(event, emit);
        }
      },
    );
  }

  Future<void> onStaffDelete(
    StaffsDeleteEvent event,
    Emitter<StaffsState> emit,
  ) async {
    emit(state.copyWith(staffsStatus: StaffsStatus.loading));
    await _staffsService.deleteStaff(event.id).whenComplete(() async {
      final container = await _loadPage(
        state.staffsContainer,
            () async {
          final result = await _staffsService.getStaffs(
            searchQuery: state.searchQuery,
            page: state.currentPage,
            departmentId: state.departmentsId,
            branchId: state.branchId,
            stateId: state.statesId,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(
          staffsContainer: container,
          searchQuery: state.searchQuery,
          totalPage: container.totalPage,
          perPage: container.countPerPage,
          currentPage: container.currentPage,
          staffsStatus: StaffsStatus.success,
        );
        emit(newState);
        if (container.staffs.isEmpty) {
          emit(
            state.copyWith(
              staffsStatus: StaffsStatus.nothingFound,
              searchQuery: state.searchQuery,
            ),
          );
        }
      }
    });
  }

  Future<void> onStaffsPageInitialize(
    StaffsPageInitializeEvent event,
    Emitter<StaffsState> emit,
  ) async {
    try {
      final results = await Future.wait([
        _staffsService.getStaffs(searchQuery: '', page: 1),
        _staffsService.getBranches(),
        _staffsService.getStates(),
        _staffsService.getDepartments(),
      ]);
      const nullItem = DropdownMenuItem(
        child: Text('Все'),
        value: null,
      );
      List<DropdownMenuItem<int?>> branchesItems = [nullItem];
      List<DropdownMenuItem<int?>> statesItems = [nullItem];
      List<DropdownMenuItem<int?>> departmentsItems = [nullItem];
      final Branches branches = results[1] as Branches;
      for (Branch branch in branches.result.branches) {
        branchesItems.add(
          DropdownMenuItem(
            child: Text(branch.name!),
            value: branch.id,
          ),
        );
      }
      final List<status.State> states = results[2] as List<status.State>;
      for (status.State state in states) {
        statesItems.add(
          DropdownMenuItem(
            child: Text(state.name!),
            value: state.id,
          ),
        );
      }
      final Departments departments = results[3] as Departments;
      for (Department department in departments.result.departments) {
        departmentsItems.add(
          DropdownMenuItem(
            child: Text(department.name),
            value: department.id,
          ),
        );
      }
      final Staffs staffs = results[0] as Staffs;
      emit(state.copyWith(
          staffsStatus: StaffsStatus.success,
          departmentsItems: departmentsItems,
          statesItems: statesItems,
          branchesItems: branchesItems,
          staffsContainer: StaffsContainer(
            staffs: staffs.result.staffs,
            qty: staffs.result.qty!,
            currentPage: staffs.result.meta!.pagination.currentPage,
            totalPage: staffs.result.meta!.pagination.totalPages,
            countPerPage: staffs.result.meta!.pagination.perPage,
          )));
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onStaffsFetch(
    StaffsFetchEvent event,
    Emitter<StaffsState> emit,
  ) async {
    if (state.searchQuery == event.query &&
        state.staffsStatus != StaffsStatus.loading &&
        state.currentPage == event.page &&
        state.departmentsId == event.departmentId &&
        state.branchId == event.branchId &&
        state.statesId == event.stateId) return;
    emit(state.copyWith(staffsStatus: StaffsStatus.loading));
    try {
      final container = await _loadPage(
        state.staffsContainer,
        () async {
          final result = await _staffsService.getStaffs(
            searchQuery: event.query,
            page: event.page,
            departmentId: event.departmentId,
            branchId: event.branchId,
            stateId: event.stateId,
          );
          return result;
        },
      );

      if (container != null) {
        final newState = state.copyWith(
          staffsContainer: container,
          searchQuery: event.query,
          totalPage: container.totalPage,
          perPage: container.countPerPage,
          currentPage: container.currentPage,
          departmentsId: event.departmentId,
          branchId: event.branchId,
          statesId: event.stateId,
          staffsStatus: StaffsStatus.success,
        );
        emit(newState);

        if (container.staffs.isEmpty) {
          emit(state.copyWith(staffsStatus: StaffsStatus.nothingFound));
        }
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onStaffsResetLoad(
    StaffsResetLoadEvent event,
    Emitter<StaffsState> emit,
  ) async {
    emit(state.copyWith(staffsStatus: StaffsStatus.loading));
    final container = await _loadPage(
      state.staffsContainer,
      () async {
        final result = await _staffsService.getStaffs(
          searchQuery: '',
          page: 1,
          departmentId: null,
          stateId: null,
          branchId: null,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        staffsContainer: container,
        searchQuery: '',
        currentPage: 1,
        perPage: container.countPerPage,
        staffsStatus: StaffsStatus.success,
      );
      emit(newState);
      if (container.staffs.isEmpty) {
        emit(
          state.copyWith(staffsStatus: StaffsStatus.nothingFound),
        );
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

  Future<void> onStaffsReload(
    StaffsReloadEvent event,
    Emitter<StaffsState> emit,
  ) async {
    emit(state.copyWith(staffsStatus: StaffsStatus.loading));
    final container = await _loadPage(
      state.staffsContainer,
      () async {
        final result = await _staffsService.getStaffs(
          searchQuery: state.searchQuery,
          page: state.currentPage,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        staffsContainer: container,
        searchQuery: state.searchQuery,
        totalPage: container.totalPage,
        perPage: container.countPerPage,
        currentPage: container.currentPage,
        departmentsId: state.departmentsId,
        branchId: state.branchId,
        statesId: state.statesId,
        staffsStatus: StaffsStatus.success,
      );
      emit(newState);
    }
  }

  Future<StaffsContainer?> _loadPage(
    StaffsContainer container,
    Future<Staffs?> Function() loader,
  ) async {
    final result = await loader();
    final newContainer = container.copyWith(
      staffs: result?.result.staffs.toList(),
      qty: result?.result.qty!.toList(),
      currentPage: result?.result.meta!.pagination.currentPage,
      totalPage: result?.result.meta!.pagination.totalPages,
      countPerPage: result?.result.meta!.pagination.perPage,
    );
    return newContainer;
  }
}
