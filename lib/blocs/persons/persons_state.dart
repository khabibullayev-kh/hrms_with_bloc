part of 'persons_bloc.dart';

enum PersonsStatus {
  loading,
  success,
  failure,
  nothingFound,
}

class PersonsState extends Equatable {
  final PersonsStatus personsStatus;
  final PersonsContainer personsContainer;
  final int currentPage;
  final int totalPage;
  final int perPage;
  final String searchQuery;
  final BuildContext? context;

  const PersonsState(
      {required this.personsStatus,
        required this.personsContainer,
        required this.currentPage,
        required this.totalPage,
        required this.perPage,
        required this.searchQuery,
        this.context});

  const PersonsState.initial()
      : personsStatus = PersonsStatus.loading,
        personsContainer = const PersonsContainer.initial(),
        currentPage = 1,
        totalPage = 1,
        perPage = 1,
        searchQuery = '',
        context = null;

  PersonsState copyWith({
    PersonsStatus? personsStatus,
    PersonsContainer? personsContainer,
    int? currentPage,
    int? totalPage,
    int? perPage,
    String? searchQuery,
    BuildContext? context,
  }) {
    return PersonsState(
      personsStatus: personsStatus ?? this.personsStatus,
      personsContainer: personsContainer ?? this.personsContainer,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      perPage: perPage ?? this.perPage,
      searchQuery: searchQuery ?? this.searchQuery,
      context: context ?? this.context,
    );
  }

  @override
  List<Object?> get props =>
      [personsStatus, personsContainer, currentPage, totalPage, searchQuery];
}
