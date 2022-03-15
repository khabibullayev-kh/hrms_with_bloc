import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/data/models/roles/role.dart';
import 'package:hrms/data/models/roles/roles.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/roles_service.dart';
import 'package:hrms/navigation/main_navigation.dart';

part 'roles_state.dart';

part 'roles_event.dart';

class RolesContainer extends Equatable {
  final List<Role> roles;
  final int currentPage;
  final int totalPage;
  final int countPerPage;

  bool get isMaxPage => currentPage >= totalPage;

  const RolesContainer({
    required this.roles,
    required this.currentPage,
    required this.totalPage,
    required this.countPerPage,
  });

  const RolesContainer.initial()
      : roles = const <Role>[],
        currentPage = 0,
        totalPage = 1,
  countPerPage = 1;

  RolesContainer copyWith({
    List<Role>? roles,
    int? currentPage,
    int? totalPage,
    int? countPerPage,
  }) {
    return RolesContainer(
      roles: roles ?? this.roles,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      countPerPage: countPerPage ?? this.countPerPage
    );
  }

  @override
  List<Object?> get props => [roles, currentPage, totalPage];
}

class RolesBloc extends Bloc<RolesEvent, RolesState> {
  final RolesService rolesService;
  final _authService = AuthService();

  RolesBloc({
    required this.rolesService,
  }) : super(const RolesState.initial()) {
    on<RolesEvent>(
      (event, emit) async {
        if (event is RolesFetchEvent) {
          await onRolesFetch(event, emit);
        } else if (event is RolesResetLoadEvent) {
          await onRolesEventLoadReset(event, emit);
        } else if (event is RolesReloadEvent) {
          await onRolesReload(event, emit);
        }
      },
    );
  }

  Future<void> onRolesFetch(
    RolesFetchEvent event,
    Emitter<RolesState> emit,
  ) async {
    if ((state.searchQuery == event.query &&
            state.usersStatus != RolesStatus.loading) &&
        state.currentPage == event.page) return;
    emit(state.copyWith(usersStatus: RolesStatus.loading));
    try {
      final container = await _loadPage(
        state.rolesContainer,
        event.query,
        event.page,
        (nextPage, search) async {
          final result = await rolesService.getRoles(
            false,
            event.query,
            event.page,
          );
          return result;
        },
      );

      if (container != null) {
        final newState = state.copyWith(
          rolesContainer: container,
          searchQuery: event.query,
          totalPage: container.totalPage,
          perPage: container.countPerPage,
          currentPage: container.currentPage,
          usersStatus: RolesStatus.success,
        );
        emit(newState);
        if (container.roles.isEmpty) {
          emit(
            state.copyWith(
              usersStatus: RolesStatus.nothingFound,
            ),
          );
        }
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onRolesEventLoadReset(
    RolesResetLoadEvent event,
    Emitter<RolesState> emit,
  ) async {
    emit(state.copyWith(usersStatus: RolesStatus.loading));
    final container = await _loadPage(
      state.rolesContainer,
      '',
      1,
      (nextPage, search) async {
        final result = await rolesService.getRoles(
          false,
          search,
          nextPage,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        rolesContainer: container,
        searchQuery: '',
        currentPage: 1,
        perPage: container.countPerPage,
        usersStatus: RolesStatus.success,
      );
      if (container.roles.isEmpty) {
        emit(
          state.copyWith(
            usersStatus: RolesStatus.nothingFound,
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
        print(exception);
    }
  }

  Future<void> onRolesReload(
    RolesReloadEvent event,
    Emitter<RolesState> emit,
  ) async {
    emit(state.copyWith(usersStatus: RolesStatus.loading));
    final container = await _loadPage(
      state.rolesContainer,
      event.query,
      event.page,
      (nextPage, search) async {
        final result = await rolesService.getRoles(
          false,
          search,
          nextPage,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        rolesContainer: container,
        searchQuery: event.query,
        currentPage: event.page,
        perPage: container.countPerPage,
        usersStatus: RolesStatus.success,
      );
      emit(newState);
    }
  }

  Future<RolesContainer?> _loadPage(
    RolesContainer container,
    String search,
    int page,
    Future<Roles?> Function(int, String) loader,
  ) async {
    final result = await loader(page, search);
    final newContainer = container.copyWith(
      roles: result?.result.roles.toList(),
      currentPage: result?.result.meta?.pagination.currentPage,
      totalPage: result?.result.meta?.pagination.totalPages,
      countPerPage: result?.result.meta?.pagination.perPage,
    );
    return newContainer;
  }
}
