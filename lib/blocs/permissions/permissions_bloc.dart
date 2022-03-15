import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/data/models/permissions/permission.dart';
import 'package:hrms/data/models/permissions/permissions.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/permissions_service.dart';
import 'package:hrms/navigation/main_navigation.dart';

part 'permissions_state.dart';

part 'permissions_event.dart';

class PermissionsContainer extends Equatable {
  final List<Permission> permissions;
  final int currentPage;
  final int totalPage;
  final int countPerPage;

  bool get isMaxPage => currentPage >= totalPage;

  const PermissionsContainer({
    required this.permissions,
    required this.currentPage,
    required this.totalPage,
    required this.countPerPage,
  });

  const PermissionsContainer.initial()
      : permissions = const <Permission>[],
        currentPage = 0,
        totalPage = 1,
        countPerPage = 1;

  PermissionsContainer copyWith({
    List<Permission>? permissions,
    int? currentPage,
    int? totalPage,
    int? countPerPage,
  }) {
    return PermissionsContainer(
      permissions: permissions ?? this.permissions,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      countPerPage: countPerPage ?? this.countPerPage,
    );
  }

  @override
  List<Object?> get props =>
      [permissions, currentPage, totalPage, countPerPage];
}

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  final PermissionsService permissionsService;
  final _authService = AuthService();

  PermissionsBloc({
    required this.permissionsService,
  }) : super(const PermissionsState.initial()) {
    on<PermissionsEvent>(
      (event, emit) async {
        if (event is PermissionsFetchEvent) {
          await onPermissionsFetch(event, emit);
        } else if (event is PermissionsResetLoadEvent) {
          await onPermissionsEventLoadReset(event, emit);
        } else if (event is PermissionsReloadEvent) {
          await onPermissionsReload(event, emit);
        }
      },
    );
  }

  Future<void> onPermissionsFetch(
    PermissionsFetchEvent event,
    Emitter<PermissionsState> emit,
  ) async {
    if ((state.searchQuery == event.query &&
            state.permissionsStatus != PermissionsStatus.loading) &&
        state.currentPage == event.page) return;
    emit(state.copyWith(permissionsStatus: PermissionsStatus.loading));
    try {
      final container = await _loadPage(
        state.permissionsContainer,
        event.query,
        event.page,
        (nextPage, search) async {
          final result = await permissionsService.getPermissions(
            false,
            search,
            nextPage,
          );
          return result;
        },
      );

      if (container != null) {
        final newState = state.copyWith(
          permissionsContainer: container,
          searchQuery: event.query,
          totalPage: container.totalPage,
          perPage: container.countPerPage,
          currentPage: container.currentPage,
          permissionsStatus: PermissionsStatus.success,
        );
        emit(newState);

        if (container.permissions.isEmpty) {
          emit(
            state.copyWith(
              permissionsStatus: PermissionsStatus.nothingFound,
            ),
          );
        }
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onPermissionsEventLoadReset(
    PermissionsResetLoadEvent event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(state.copyWith(permissionsStatus: PermissionsStatus.loading));
    final container = await _loadPage(
      state.permissionsContainer,
      '',
      1,
      (nextPage, search) async {
        final result = await permissionsService.getPermissions(
          false,
          search,
          nextPage,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        permissionsContainer: container,
        searchQuery: '',
        currentPage: 1,
        perPage: container.countPerPage,
        permissionsStatus: PermissionsStatus.success,
      );
      if (container.permissions.isEmpty) {
        emit(
          state.copyWith(
            permissionsStatus: PermissionsStatus.nothingFound,
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

  Future<void> onPermissionsReload(
    PermissionsReloadEvent event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(state.copyWith(permissionsStatus: PermissionsStatus.loading));
    final container = await _loadPage(
      state.permissionsContainer,
      event.query,
      event.page,
      (nextPage, search) async {
        final result = await permissionsService.getPermissions(
          false,
          search,
          nextPage,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        permissionsContainer: container,
        searchQuery: event.query,
        currentPage: event.page,
        perPage: container.countPerPage,
        permissionsStatus: PermissionsStatus.success,
      );
      emit(newState);
    }
  }

  Future<PermissionsContainer?> _loadPage(
    PermissionsContainer container,
    String search,
    int page,
    Future<Permissions?> Function(int, String) loader,
  ) async {
    final result = await loader(page, search);
    final newContainer = container.copyWith(
      permissions: result?.result.permissions.toList(),
      currentPage: result?.result.meta!.pagination.currentPage,
      totalPage: result?.result.meta!.pagination.totalPages,
      countPerPage: result?.result.meta!.pagination.perPage,
    );
    return newContainer;
  }
}
