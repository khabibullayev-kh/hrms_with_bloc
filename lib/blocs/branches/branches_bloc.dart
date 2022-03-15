import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/region_district/district.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/branches_service.dart';
import 'package:hrms/navigation/main_navigation.dart';

part 'branches_state.dart';

part 'branches_event.dart';

class BranchesContainer extends Equatable {
  final List<Branch> branches;
  final int currentPage;
  final int totalPage;
  final int countPerPage;

  bool get isMaxPage => currentPage >= totalPage;

  const BranchesContainer({
    required this.branches,
    required this.currentPage,
    required this.totalPage,
    required this.countPerPage,
  });

  const BranchesContainer.initial()
      : branches = const <Branch>[],
        currentPage = 0,
        totalPage = 1,
        countPerPage = 1;

  BranchesContainer copyWith({
    List<Branch>? branches,
    int? currentPage,
    int? totalPage,
    int? countPerPage,
  }) {
    return BranchesContainer(
      branches: branches ?? this.branches,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      countPerPage: countPerPage ?? this.countPerPage,
    );
  }

  @override
  List<Object?> get props => [branches, currentPage, totalPage, countPerPage];
}

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  final BranchesService branchesService = BranchesService();
  final _authService = AuthService();

  BranchesBloc() : super(BranchesState.initial()) {
    on<BranchesEvent>(
      (event, emit) async {
        if (event is BranchesPageInitializeEvent) {
          await onBranchesPageInitialize(event, emit);
        } else if (event is BranchesFetchEvent) {
          await onBranchesFetch(event, emit);
        } else if (event is BranchesResetLoadEvent) {
          await onBranchesEventLoadReset(event, emit);
        } else if (event is BranchesReloadEvent) {
          await onBranchesReload(event, emit);
        }
      },
    );
  }

  Future<void> onBranchesPageInitialize(
    BranchesPageInitializeEvent event,
    Emitter<BranchesState> emit,
  ) async {
    state.copyWith(
      branchesStatus: BranchesStatus.loading,
    );
    try {
      final results = await Future.wait([
        branchesService.getRegions(),
        branchesService.getBranches(
          searchQuery: '',
          page: 1,
          shopCategory: null,
          regionId: null,
        ),
      ]);
      List<DropdownMenuItem<int?>> regionItems = [];
      List<DropdownMenuItem<String?>> shopCategoriesItem = [];
      List<DropdownMenuItem<String?>> shopCategoriesItems =
      shopCategories.values.map((shopCategories classType) {
        return DropdownMenuItem<String?>(
          value: classType.convertToString,
          child: Text(classType.convertToString),
        );
      }).toList();
      const nullItem = DropdownMenuItem(
        child: Text('Все'),
        value: null,
      );
      regionItems.add(nullItem);
      shopCategoriesItem.add(nullItem);
      shopCategoriesItem.addAll(shopCategoriesItems);
      final List<District> regions = results[0];
      for (District region in regions) {
        regionItems.add(
          DropdownMenuItem(
            child: Text(region.name!),
            value: region.id,
          ),
        );
      }
      final Branches branches = results[1];
      emit(state.copyWith(
          branchesStatus: BranchesStatus.success,
          regionItems: regionItems,
          shopCategoryItems: shopCategoriesItem,
          branchesContainer: BranchesContainer(
            branches: branches.result.branches,
            currentPage: branches.result.meta!.pagination.currentPage,
            totalPage: branches.result.meta!.pagination.totalPages,
            countPerPage: branches.result.meta!.pagination.perPage,
          )));
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onBranchesFetch(
    BranchesFetchEvent event,
    Emitter<BranchesState> emit,
  ) async {
    if (state.searchQuery == event.query &&
        state.branchesStatus != BranchesStatus.loading &&
        state.currentPage == event.page &&
        state.regionId == event.regionId &&
        state.shopCategory == event.shopCategory) return;
    emit(state.copyWith(branchesStatus: BranchesStatus.loading));
    try {
      final container = await _loadPage(
        state.branchesContainer,
        event.query,
        event.page,
        (nextPage, search) async {
          final result = await branchesService.getBranches(
            searchQuery: search,
            page: nextPage,
            regionId: event.regionId,
            shopCategory: event.shopCategory,
          );
          return result;
        },
      );

      if (container != null) {
        final newState = state.copyWith(
          branchesContainer: container,
          searchQuery: event.query,
          shopCategory: event.shopCategory,
          regionId: event.regionId,
          totalPage: container.totalPage,
          perPage: container.countPerPage,
          currentPage: container.currentPage,
          branchesStatus: BranchesStatus.success,
        );
        emit(newState);
        if (container.branches.isEmpty) {
          emit(
            state.copyWith(
              branchesStatus: BranchesStatus.nothingFound,
              shopCategory: event.shopCategory,
              regionId: event.regionId,
            ),
          );
        }
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onBranchesEventLoadReset(
    BranchesResetLoadEvent event,
    Emitter<BranchesState> emit,
  ) async {
    emit(state.copyWith(branchesStatus: BranchesStatus.loading));
    final container = await _loadPage(
      state.branchesContainer,
      '',
      1,
      (nextPage, search) async {
        final result = await branchesService.getBranches(
          searchQuery: search,
          page: nextPage,
          shopCategory: null,
          regionId: null,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        branchesContainer: container,
        shopCategory: null,
        regionId: null,
        searchQuery: '',
        currentPage: 1,
        perPage: container.countPerPage,
        branchesStatus: BranchesStatus.success,
      );
      if (container.branches.isEmpty) {
        emit(
          state.copyWith(
            branchesStatus: BranchesStatus.nothingFound,
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

  Future<void> onBranchesReload(
    BranchesReloadEvent event,
    Emitter<BranchesState> emit,
  ) async {
    emit(state.copyWith(branchesStatus: BranchesStatus.loading));
    final container = await _loadPage(
      state.branchesContainer,
      event.query,
      event.page,
      (nextPage, search) async {
        final result = await branchesService.getBranches(
          searchQuery: search,
          page: nextPage,
          regionId: event.regionId,
          shopCategory: event.shopCategory,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        branchesContainer: container,
        searchQuery: event.query,
        currentPage: event.page,
        perPage: container.countPerPage,
        branchesStatus: BranchesStatus.success,
      );
      emit(newState);
    }
  }

  Future<BranchesContainer?> _loadPage(
    BranchesContainer container,
    String search,
    int page,
    Future<Branches?> Function(int, String) loader,
  ) async {
    final result = await loader(page, search);
    final newContainer = container.copyWith(
      branches: result?.result.branches.toList(),
      currentPage: result?.result.meta!.pagination.currentPage,
      totalPage: result?.result.meta!.pagination.totalPages,
      countPerPage: result?.result.meta!.pagination.perPage,
    );
    return newContainer;
  }
}
