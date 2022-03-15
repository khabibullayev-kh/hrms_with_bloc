part of 'candidates_bloc.dart';

enum CandidatesStatus {
  loading,
  success,
  failure,
  nothingFound,
}

class CandidatesState extends Equatable {
  final CandidatesStatus candidatesStatus;
  final CandidatesContainer candidatesContainer;
  final List<DropdownMenuItem<String?>> sexItems;
  final List<DropdownMenuItem<int?>> jobPositionItems;
  final List<DropdownMenuItem<int?>> statesItems;
  final List<DropdownMenuItem<int?>> regionItems;
  final List<DropdownMenuItem<int?>> branchesItems;
  final String? sex;
  final int? jobPositionId;
  final int? statesId;
  final int? regionId;
  final int? branchId;
  final int currentPage;
  final int totalPage;
  final int perPage;
  final String searchQuery;
  final bool isShowingHotCandidates;
  final BuildContext? context;

  const CandidatesState({
    required this.candidatesStatus,
    required this.candidatesContainer,
    required this.sexItems,
    required this.jobPositionItems,
    required this.statesItems,
    required this.regionItems,
    required this.branchesItems,
    required this.sex,
    required this.jobPositionId,
    required this.statesId,
    required this.regionId,
    required this.branchId,
    required this.currentPage,
    required this.totalPage,
    required this.perPage,
    required this.searchQuery,
    required this.isShowingHotCandidates,
    this.context,
  });

  CandidatesState.initial()
      : candidatesStatus = CandidatesStatus.loading,
        candidatesContainer = const CandidatesContainer.initial(),
        sexItems = <DropdownMenuItem<String?>>[
          const DropdownMenuItem(
            child: Text('Все'),
            value: null,
          ),
        ],
        regionItems = <DropdownMenuItem<int?>>[
          const DropdownMenuItem(
            child: Text('Все'),
            value: null,
          ),
        ],
        jobPositionItems = <DropdownMenuItem<int?>>[
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
        sex = null,
        jobPositionId = null,
        statesId = null,
        regionId = null,
        branchId = null,
        currentPage = 1,
        totalPage = 1,
        perPage = 1,
        searchQuery = '',
        isShowingHotCandidates = false,
        context = null;

  CandidatesState copyWith({
    CandidatesStatus? candidatesStatus,
    CandidatesContainer? candidatesContainer,
    List<DropdownMenuItem<String?>>? sexItems,
    List<DropdownMenuItem<int?>>? jobPositionItems,
    List<DropdownMenuItem<int?>>? statesItems,
    List<DropdownMenuItem<int?>>? regionItems,
    List<DropdownMenuItem<int?>>? branchesItems,
    String? sex,
    int? jobPositionId,
    int? statesId,
    int? regionId,
    int? branchId,
    int? currentPage,
    int? totalPage,
    int? perPage,
    String? searchQuery,
    bool? isShowingHotCandidates,
    BuildContext? context,
  }) {
    return CandidatesState(
      candidatesStatus: candidatesStatus ?? this.candidatesStatus,
      candidatesContainer: candidatesContainer ?? this.candidatesContainer,
      sexItems: sexItems ?? this.sexItems,
      jobPositionItems: jobPositionItems ?? this.jobPositionItems,
      statesItems: statesItems ?? this.statesItems,
      regionItems: regionItems ?? this.regionItems,
      branchesItems: branchesItems ?? this.branchesItems,
      sex: sex,
      jobPositionId: jobPositionId,
      statesId: statesId,
      regionId: regionId,
      branchId: branchId,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      perPage: perPage ?? this.perPage,
      searchQuery: searchQuery ?? this.searchQuery,
      isShowingHotCandidates: isShowingHotCandidates ?? this.isShowingHotCandidates,
      context: context ?? this.context,
    );
  }

  @override
  List<Object?> get props =>
      [
        candidatesStatus,
        candidatesContainer,
        sexItems,
        jobPositionItems,
        statesItems,
        regionItems,
        branchesItems,
        sex,
        jobPositionId,
        statesId,
        regionId,
        branchId,
        currentPage,
        totalPage,
        perPage,
        searchQuery,
        isShowingHotCandidates,
        context,
      ];
}
