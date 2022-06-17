import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/data/models/users/user.dart';
import 'package:hrms/data/models/users/users.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/network/user_management_api/user_api_client.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/navigation/main_navigation.dart';

part 'user_state.dart';

part 'users_event.dart';

class UsersContainer extends Equatable {
  final List<User> users;
  final int currentPage;
  final int totalPage;
  final int countPerPage;

  bool get isMaxPage => currentPage >= totalPage;

  const UsersContainer({
    required this.users,
    required this.currentPage,
    required this.totalPage,
    required this.countPerPage,
  });

  const UsersContainer.initial()
      : users = const <User>[],
        currentPage = 0,
        totalPage = 1,
        countPerPage = 1;

  UsersContainer copyWith({
    List<User>? users,
    int? currentPage,
    int? totalPage,
    int? countPerPage,
  }) {
    return UsersContainer(
      users: users ?? this.users,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      countPerPage: countPerPage ?? this.countPerPage,
    );
  }

  @override
  List<Object?> get props => [users, currentPage, totalPage, countPerPage];
}

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersApiClient usersRepository;
  final _authService = AuthService();

  UsersBloc({
    required this.usersRepository,
  }) : super(const UsersState.initial()) {
    on<UsersEvent>(
      (event, emit) async {
        if (event is UsersFetchEvent) {
          await onUsersFetch(event, emit);
        } else if (event is UsersResetLoadEvent) {
          await onUsersEventLoadReset(event, emit);
        } else if (event is UsersReloadEvent) {
          await onUsersReload(event, emit);
        }
      },
    );
  }

  Future<void> onUsersFetch(
    UsersFetchEvent event,
    Emitter<UsersState> emit,
  ) async {
    if ((state.searchQuery == event.query &&
            state.usersStatus != UsersStatus.loading) &&
        state.currentPage == event.page) return;
    emit(state.copyWith(usersStatus: UsersStatus.loading));
    try {
      final container = await _loadPage(
        state.usersListContainer,
        event.query,
        event.page,
        (nextPage, search) async {
          final result = await usersRepository.getUsersRequest(
            nextPage,
            search,
          );
          return result;
        },
      );

      if (container != null) {
        final newState = state.copyWith(
          usersListContainer: container,
          searchQuery: event.query,
          totalPage: container.totalPage,
          perPage: container.countPerPage,
          currentPage: container.currentPage,
          usersStatus: UsersStatus.success,
        );
        emit(newState);
        if (container.users.isEmpty) {
          emit(
            state.copyWith(
              usersStatus: UsersStatus.nothingFound,
            ),
          );
        }
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onUsersEventLoadReset(
    UsersResetLoadEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(state.copyWith(usersStatus: UsersStatus.loading));
    final container = await _loadPage(
      state.usersListContainer,
      '',
      1,
      (nextPage, search) async {
        final result = await usersRepository.getUsersRequest(
          nextPage,
          search,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        usersListContainer: container,
        searchQuery: '',
        currentPage: 1,
        perPage: container.countPerPage,
        usersStatus: UsersStatus.success,
      );
      if (container.users.isEmpty) {
        emit(
          state.copyWith(
            usersStatus: UsersStatus.nothingFound,
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

  Future<void> onUsersReload(
    UsersReloadEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(state.copyWith(usersStatus: UsersStatus.loading));
    final container = await _loadPage(
      state.usersListContainer,
      event.query,
      event.page,
      (nextPage, search) async {
        final result = await usersRepository.getUsersRequest(
          nextPage,
          search,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        usersListContainer: container,
        searchQuery: event.query,
        currentPage: event.page,
        perPage: container.countPerPage,
        usersStatus: UsersStatus.success,
      );
      emit(newState);
    }
  }

  Future<UsersContainer?> _loadPage(
    UsersContainer container,
    String search,
    int page,
    Future<UsersResponse?> Function(int, String) loader,
  ) async {
    final result = await loader(page, search);
    final newContainer = container.copyWith(
      users: result?.result.users.toList(),
      currentPage: result?.result.meta.pagination.currentPage,
      totalPage: result?.result.meta.pagination.totalPages,
    );
    return newContainer;
  }
}
