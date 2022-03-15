part of 'roles_bloc.dart';

enum RolesStatus {
  loading,
  success,
  failure,
  nothingFound,
}

class RolesState extends Equatable {
  final RolesStatus usersStatus;
  final RolesContainer rolesContainer;
  final int currentPage;
  final int totalPage;
  final int perPage;
  final String searchQuery;
  final BuildContext? context;

  const RolesState(
      {required this.usersStatus,
      required this.rolesContainer,
      required this.currentPage,
      required this.totalPage,
      required this.perPage,
      required this.searchQuery,
      this.context});

  const RolesState.initial()
      : usersStatus = RolesStatus.loading,
        rolesContainer = const RolesContainer.initial(),
        currentPage = 1,
        totalPage = 1,
        perPage = 1,
        searchQuery = '',
        context = null;

  RolesState copyWith({
    RolesStatus? usersStatus,
    RolesContainer? rolesContainer,
    int? currentPage,
    int? totalPage,
    int? perPage,
    String? searchQuery,
    BuildContext? context,
  }) {
    return RolesState(
      usersStatus: usersStatus ?? this.usersStatus,
      rolesContainer: rolesContainer ?? this.rolesContainer,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      perPage: perPage ?? this.perPage,
      searchQuery: searchQuery ?? this.searchQuery,
      context: context ?? this.context,
    );
  }

  @override
  List<Object?> get props => [
        usersStatus,
        rolesContainer,
        currentPage,
        totalPage,
        perPage,
        searchQuery,
      ];
}
