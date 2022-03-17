part of 'shifts_bloc.dart';

enum ShiftsStatus {
  loading,
  success,
  failure,
  nothingFound,
}

class ShiftsState extends Equatable {
  final ShiftsStatus shiftsStatus;
  final ShiftsContainer shiftsContainer;
  final List<DropdownMenuItem<int?>> toJobPositionsItem;
  final List<DropdownMenuItem<int?>> statesItems;
  final List<DropdownMenuItem<int?>> branchesItems;
  final int? toJobPositionsId;
  final int? statesId;
  final int? branchId;
  final int currentPage;
  final int totalPage;
  final int perPage;
  final String searchQuery;
  final BuildContext? context;

  const ShiftsState({
    required this.shiftsStatus,
    required this.shiftsContainer,
    required this.toJobPositionsItem,
    required this.statesItems,
    required this.branchesItems,
    required this.toJobPositionsId,
    required this.statesId,
    required this.branchId,
    required this.currentPage,
    required this.totalPage,
    required this.perPage,
    required this.searchQuery,
    this.context,
  });

  ShiftsState.initial()
      : shiftsStatus = ShiftsStatus.loading,
        shiftsContainer = const ShiftsContainer.initial(),
        toJobPositionsItem = <DropdownMenuItem<int?>>[dropDownItem],
        statesItems = <DropdownMenuItem<int?>>[dropDownItem],
        branchesItems = <DropdownMenuItem<int?>>[dropDownItem],
        toJobPositionsId = null,
        statesId = null,
        branchId = null,
        currentPage = 1,
        totalPage = 1,
        perPage = 1,
        searchQuery = '',
        context = null;

  ShiftsState copyWith({
    ShiftsStatus? shiftsStatus,
    ShiftsContainer? shiftsContainer,
    List<DropdownMenuItem<int?>>? toJobPositionsItem,
    List<DropdownMenuItem<int?>>? statesItems,
    List<DropdownMenuItem<int?>>? branchesItems,
    int? toJobPositionId,
    int? statesId,
    int? branchId,
    int? currentPage,
    int? totalPage,
    int? perPage,
    String? searchQuery,
    bool? isLoadingNextPage,
    BuildContext? context,
  }) {
    return ShiftsState(
      shiftsStatus: shiftsStatus ?? this.shiftsStatus,
      shiftsContainer: shiftsContainer ?? this.shiftsContainer,
      toJobPositionsItem: toJobPositionsItem ?? this.toJobPositionsItem,
      statesItems: statesItems ?? this.statesItems,
      branchesItems: branchesItems ?? this.branchesItems,
      toJobPositionsId: toJobPositionsId,
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
        shiftsStatus,
        shiftsContainer,
        statesItems,
        branchesItems,
        statesId,
        branchId,
        currentPage,
        totalPage,
        perPage,
        searchQuery,
        context,
      ];
}
