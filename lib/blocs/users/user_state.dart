part of 'users_bloc.dart';

enum UsersStatus {
  loading,
  success,
  failure,
  nothingFound,
}

class UsersState extends Equatable {
  final UsersStatus usersStatus;
  final UsersContainer usersListContainer;
  final int currentPage;
  final int totalPage;
  final int perPage;
  final String searchQuery;
  final BuildContext? context;

  const UsersState(
      {required this.usersStatus,
      required this.usersListContainer,
      required this.currentPage,
      required this.totalPage,
        required this.perPage,
      required this.searchQuery,
      this.context});

  const UsersState.initial()
      : usersStatus = UsersStatus.loading,
        usersListContainer = const UsersContainer.initial(),
        currentPage = 1,
        totalPage = 1,
  perPage = 1,
        searchQuery = '',
        context = null;

  UsersState copyWith({
    UsersStatus? usersStatus,
    UsersContainer? usersListContainer,
    int? currentPage,
    int? totalPage,
    int? perPage,
    String? searchQuery,
    BuildContext? context,
  }) {
    return UsersState(
      usersStatus: usersStatus ?? this.usersStatus,
      usersListContainer: usersListContainer ?? this.usersListContainer,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      perPage: perPage ?? this.perPage,
      searchQuery: searchQuery ?? this.searchQuery,
      context: context ?? this.context,
    );
  }

  @override
  List<Object?> get props =>
      [usersStatus, usersListContainer, currentPage, totalPage, searchQuery];
}
