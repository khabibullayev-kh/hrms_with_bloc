import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/data/models/persons/person.dart';
import 'package:hrms/data/models/persons/persons.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/persons_service.dart';
import 'package:hrms/navigation/main_navigation.dart';

part 'persons_state.dart';

part 'persons_event.dart';

class PersonsContainer extends Equatable {
  final List<Person> persons;
  final int currentPage;
  final int totalPage;
  final int countPerPage;

  bool get isMaxPage => currentPage >= totalPage;

  const PersonsContainer({
    required this.persons,
    required this.currentPage,
    required this.totalPage,
    required this.countPerPage,
  });

  const PersonsContainer.initial()
      : persons = const <Person>[],
        currentPage = 0,
        totalPage = 1,
        countPerPage = 1;

  PersonsContainer copyWith({
    List<Person>? persons,
    int? currentPage,
    int? totalPage,
    int? countPerPage,
  }) {
    return PersonsContainer(
      persons: persons ?? this.persons,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      countPerPage: countPerPage ?? this.countPerPage,
    );
  }

  @override
  List<Object?> get props => [persons, currentPage, totalPage, countPerPage];
}

class PersonsBloc extends Bloc<PersonsEvent, PersonsState> {
  final _personsService = PersonsService();
  final _authService = AuthService();

  PersonsBloc() : super(const PersonsState.initial()) {
    on<PersonsEvent>(
          (event, emit) async {
        if (event is PersonsFetchEvent) {
          await onPersonsFetch(event, emit);
        } else if (event is PersonsResetLoadEvent) {
          await onPersonsResetLoadEvent(event, emit);
        } else if (event is PersonsReloadEvent) {
          await onPersonsReload(event, emit);
        } else if (event is PersonsDeleteEvent) {
          await onPersonDelete(event, emit);
        }
      },
    );
  }

  Future<void> onPersonDelete(PersonsDeleteEvent event,
      Emitter<PersonsState> emit,) async {
    emit(state.copyWith(personsStatus: PersonsStatus.loading));
    await _personsService.deletePerson(event.id).whenComplete(() async {
      final container = await _loadPage(
        state.personsContainer,
        state.searchQuery,
        state.currentPage,
            (nextPage, search) async {
          final result = await _personsService.getPersons(
            page: nextPage,
            search: search,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(
          personsContainer: container,
          searchQuery: state.searchQuery,
          totalPage: container.totalPage,
          perPage: container.countPerPage,
          currentPage: container.currentPage,
          personsStatus: PersonsStatus.success,
        );
        emit(newState);
        if (container.persons.isEmpty) {
          emit(
            state.copyWith(
              personsStatus: PersonsStatus.nothingFound,
              searchQuery: state.searchQuery,
            ),
          );
        }
      }
    });
  }

  Future<void> onPersonsFetch(PersonsFetchEvent event,
      Emitter<PersonsState> emit,) async {
    if ((state.searchQuery == event.query &&
        state.personsStatus != PersonsStatus.loading) &&
        state.currentPage == event.page) return;
    emit(state.copyWith(personsStatus: PersonsStatus.loading));
    try {
      final container = await _loadPage(
        state.personsContainer,
        event.query,
        event.page,
            (nextPage, search) async {
          final result = await _personsService.getPersons(
            page: nextPage,
            search: search,
          );
          return result;
        },
      );

      if (container != null) {
        final newState = state.copyWith(
          personsContainer: container,
          searchQuery: event.query,
          totalPage: container.totalPage,
          perPage: container.countPerPage,
          currentPage: container.currentPage,
          personsStatus: PersonsStatus.success,
        );
        emit(newState);
        if (container.persons.isEmpty) {
          emit(
            state.copyWith(
              personsStatus: PersonsStatus.nothingFound,
              searchQuery: state.searchQuery,
            ),
          );
        }
      }
    } on ApiClientException catch (e) {
      _handleApiClientException(e, event.context);
    }
  }

  Future<void> onPersonsResetLoadEvent(PersonsResetLoadEvent event,
      Emitter<PersonsState> emit,) async {
    emit(state.copyWith(personsStatus: PersonsStatus.loading));
    final container = await _loadPage(
      state.personsContainer,
      '',
      1,
          (nextPage, search) async {
        final result = await _personsService.getPersons(
          page: nextPage,
          search: search,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        personsContainer: container,
        searchQuery: '',
        currentPage: 1,
        perPage: container.countPerPage,
        personsStatus: PersonsStatus.success,
      );
      if (container.persons.isEmpty) {
        emit(
          state.copyWith(
            personsStatus: PersonsStatus.nothingFound,
          ),
        );
      } else {
        emit(newState);
      }
    }
  }

  void _handleApiClientException(ApiClientException exception,
      BuildContext context,) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        throw UnimplementedError();
    }
  }

  Future<void> onPersonsReload(PersonsReloadEvent event,
      Emitter<PersonsState> emit,) async {
    emit(state.copyWith(personsStatus: PersonsStatus.loading));
    final container = await _loadPage(
      state.personsContainer,
      state.searchQuery,
      state.currentPage,
          (nextPage, search) async {
        final result = await _personsService.getPersons(
          page: nextPage,
          search: search,
        );
        return result;
      },
    );
    if (container != null) {
      final newState = state.copyWith(
        personsContainer: container,
        searchQuery: state.searchQuery,
        currentPage: state.currentPage,
        perPage: container.countPerPage,
        personsStatus: PersonsStatus.success,
      );
      emit(newState);
    }
  }

  Future<PersonsContainer?> _loadPage(PersonsContainer container,
      String search,
      int page,
      Future<Persons?> Function(int, String) loader,) async {
    final result = await loader(page, search);
    final newContainer = container.copyWith(
      persons: result?.result.persons.toList(),
      currentPage: result?.result.meta!.pagination.currentPage,
      totalPage: result?.result.meta!.pagination.totalPages,
    );
    return newContainer;
  }
}
