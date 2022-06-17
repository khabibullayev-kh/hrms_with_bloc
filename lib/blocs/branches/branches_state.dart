part of 'branches_bloc.dart';

enum BranchesStatus {
  loading,
  success,
  failure,
  nothingFound,
}

class BranchesState extends Equatable {
  final BranchesStatus branchesStatus;
  final BranchesContainer branchesContainer;
  final List<DropdownMenuItem<int?>> regionItems;
  final List<DropdownMenuItem<String?>> shopCategoryItems;
  final int? regionId;
  final String? shopCategory;
  final int currentPage;
  final int totalPage;
  final int perPage;
  final String searchQuery;
  final BuildContext? context;

  const BranchesState({
    required this.branchesStatus,
    required this.branchesContainer,
    required this.regionItems,
    required this.shopCategoryItems,
    required this.regionId,
    required this.shopCategory,
    required this.currentPage,
    required this.totalPage,
    required this.perPage,
    required this.searchQuery,
    this.context,
  });

  BranchesState.initial()
      : branchesStatus = BranchesStatus.loading,
        branchesContainer = const BranchesContainer.initial(),
        regionItems = <DropdownMenuItem<int?>>[dropDownItem],
        shopCategoryItems = [dropDownItem],
        regionId = null,
        shopCategory = null,
        currentPage = 1,
        totalPage = 1,
        perPage = 1,
        searchQuery = '',
        context = null;

  BranchesState copyWith({
    BranchesStatus? branchesStatus,
    BranchesContainer? branchesContainer,
    List<DropdownMenuItem<int?>>? regionItems,
    List<DropdownMenuItem<String?>>? shopCategoryItems,
    int? regionId,
    String? shopCategory,
    int? currentPage,
    int? totalPage,
    int? perPage,
    String? searchQuery,
    BuildContext? context,
  }) {
    return BranchesState(
      branchesStatus: branchesStatus ?? this.branchesStatus,
      branchesContainer: branchesContainer ?? this.branchesContainer,
      regionItems: regionItems ?? this.regionItems,
      shopCategoryItems: shopCategoryItems ?? this.shopCategoryItems,
      regionId: regionId,
      shopCategory: shopCategory,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      perPage: perPage ?? this.perPage,
      searchQuery: searchQuery ?? this.searchQuery,
      context: context ?? this.context,
    );
  }

  @override
  List<Object?> get props => [
        branchesStatus,
        branchesContainer,
        regionItems,
        shopCategoryItems,
        regionId,
        shopCategory,
        currentPage,
        totalPage,
        searchQuery
      ];
}
