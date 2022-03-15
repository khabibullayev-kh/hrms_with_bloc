part of 'staffs_bloc.dart';

enum StaffsStatus {
  loading,
  success,
  failure,
  nothingFound,
}

class StaffsState extends Equatable {
  final StaffsStatus staffsStatus;
  final StaffsContainer staffsContainer;
  final List<DropdownMenuItem<int?>> departmentsItems;
  final List<DropdownMenuItem<int?>> statesItems;
  final List<DropdownMenuItem<int?>> branchesItems;
  final int? departmentsId;
  final int? statesId;
  final int? branchId;
  final int currentPage;
  final int totalPage;
  final int perPage;
  final String searchQuery;
  final BuildContext? context;

  const StaffsState({
    required this.staffsStatus,
    required this.staffsContainer,
    required this.departmentsItems,
    required this.statesItems,
    required this.branchesItems,
    required this.departmentsId,
    required this.statesId,
    required this.branchId,
    required this.currentPage,
    required this.totalPage,
    required this.perPage,
    required this.searchQuery,
    this.context,
  });

  StaffsState.initial()
      : staffsStatus = StaffsStatus.loading,
        staffsContainer = const StaffsContainer.initial(),
        departmentsItems = <DropdownMenuItem<int?>>[
          const DropdownMenuItem(
            child: Text('Все'),
            value: null,
          ),
        ],
        statesItems = <DropdownMenuItem<int?>>[
          const DropdownMenuItem(
            child: Text('Все'),
            value: null,
          ),
        ],
        branchesItems = <DropdownMenuItem<int?>>[
          const DropdownMenuItem(
            child: Text('Все'),
            value: null,
          ),
        ],
        departmentsId = null,
        statesId = null,
        branchId = null,
        currentPage = 1,
        totalPage = 1,
        perPage = 1,
        searchQuery = '',
        context = null;

  StaffsState copyWith({
    StaffsStatus? staffsStatus,
    StaffsContainer? staffsContainer,
    List<DropdownMenuItem<int?>>? departmentsItems,
    List<DropdownMenuItem<int?>>? statesItems,
    List<DropdownMenuItem<int?>>? branchesItems,
    int? departmentsId,
    int? statesId,
    int? branchId,
    int? currentPage,
    int? totalPage,
    int? perPage,
    String? searchQuery,
    bool? isLoadingNextPage,
    BuildContext? context,
  }) {
    return StaffsState(
      staffsStatus: staffsStatus ?? this.staffsStatus,
      staffsContainer: staffsContainer ?? this.staffsContainer,
      departmentsItems: departmentsItems ?? this.departmentsItems,
      statesItems: statesItems ?? this.statesItems,
      branchesItems: branchesItems ?? this.branchesItems,
      departmentsId: departmentsId,
      statesId: statesId,
      branchId: branchId,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      perPage: perPage ?? this.perPage,
      searchQuery: searchQuery ?? this.searchQuery,
      context: context ?? this.context,
    );
  }

  @override
  List<Object?> get props => [
    staffsStatus,
    staffsContainer,
    departmentsItems,
    statesItems,
    branchesItems,
    departmentsId,
    statesId,
    branchId,
    currentPage,
    totalPage,
    perPage,
    searchQuery,
    context,
  ];
}
