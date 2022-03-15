part of 'permissions_bloc.dart';


enum PermissionsStatus {
  loading,
  success,
  failure,
  nothingFound,
}

class PermissionsState extends Equatable {
  final PermissionsStatus permissionsStatus;
  final PermissionsContainer permissionsContainer;
  final int currentPage;
  final int totalPage;
  final int perPage;
  final String searchQuery;
  final BuildContext? context;

  const PermissionsState(
      {required this.permissionsStatus,
        required this.permissionsContainer,
        required this.currentPage,
        required this.totalPage,
        required this.perPage,
        required this.searchQuery,
        this.context});

  const PermissionsState.initial()
      : permissionsStatus = PermissionsStatus.loading,
        permissionsContainer = const PermissionsContainer.initial(),
        currentPage = 1,
        totalPage = 1,
        perPage = 1,
        searchQuery = '',
        context = null;

  PermissionsState copyWith({
    PermissionsStatus? permissionsStatus,
    PermissionsContainer? permissionsContainer,
    int? currentPage,
    int? totalPage,
    int? perPage,
    String? searchQuery,
    BuildContext? context,
  }) {
    return PermissionsState(
      permissionsStatus: permissionsStatus ?? this.permissionsStatus,
      permissionsContainer: permissionsContainer ?? this.permissionsContainer,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      perPage: perPage ?? this.perPage,
      searchQuery: searchQuery ?? this.searchQuery,
      context: context ?? this.context,
    );
  }

  @override
  List<Object?> get props =>
      [permissionsStatus, permissionsContainer, currentPage, totalPage, searchQuery];
}
