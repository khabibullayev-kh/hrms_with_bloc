part of 'vacancies_bloc.dart';

enum VacanciesStatus {
  loading,
  success,
  failure,
  nothingFound,
}

class VacanciesState extends Equatable {
  final VacanciesStatus vacanciesStatus;
  final VacanciesContainer vacanciesContainer;
  final List<DropdownMenuItem<int?>> jobPositionsItem;
  final List<DropdownMenuItem<int?>> regionsItems;
  final List<DropdownMenuItem<int?>> recruitersItems;
  final List<DropdownMenuItem<int?>> statesItems;
  final List<DropdownMenuItem<int?>> branchesItems;
  final int? jobPositionId;
  final int? regionId;
  final int? recruiterId;
  final int? statesId;
  final int? branchId;
  final int currentPage;
  final int totalPage;
  final int perPage;
  final String searchQuery;
  final BuildContext? context;

  const VacanciesState({
    required this.vacanciesStatus,
    required this.vacanciesContainer,
    required this.jobPositionsItem,
    required this.regionsItems,
    required this.recruitersItems,
    required this.statesItems,
    required this.branchesItems,
    required this.jobPositionId,
    required this.regionId,
    required this.recruiterId,
    required this.statesId,
    required this.branchId,
    required this.currentPage,
    required this.totalPage,
    required this.perPage,
    required this.searchQuery,
    this.context,
  });

  VacanciesState.initial()
      : vacanciesStatus = VacanciesStatus.loading,
        vacanciesContainer = const VacanciesContainer.initial(),
        jobPositionsItem = <DropdownMenuItem<int?>>[
          const DropdownMenuItem(
            child: Text('Все'),
            value: null,
          ),
        ],
        regionsItems = <DropdownMenuItem<int?>>[
          const DropdownMenuItem(
            child: Text('Все'),
            value: null,
          ),
        ],
        recruitersItems = <DropdownMenuItem<int?>>[
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
        jobPositionId = null,
        regionId = null,
        recruiterId = null,
        statesId = null,
        branchId = null,
        currentPage = 1,
        totalPage = 1,
        perPage = 1,
        searchQuery = '',
        context = null;

  VacanciesState copyWith({
    VacanciesStatus? vacanciesStatus,
    VacanciesContainer? vacanciesContainer,
    List<DropdownMenuItem<int?>>? jobPositionsItem,
    List<DropdownMenuItem<int?>>? regionsItems,
    List<DropdownMenuItem<int?>>? recruitersItems,
    List<DropdownMenuItem<int?>>? statesItems,
    List<DropdownMenuItem<int?>>? branchesItems,
    int? jobPositionId,
    int? regionId,
    int? recruiterId,
    int? statesId,
    int? branchId,
    int? currentPage,
    int? totalPage,
    int? perPage,
    String? searchQuery,
    bool? isLoadingNextPage,
    BuildContext? context,
  }) {
    return VacanciesState(
      vacanciesStatus: vacanciesStatus ?? this.vacanciesStatus,
      vacanciesContainer: vacanciesContainer ?? this.vacanciesContainer,
      jobPositionsItem: jobPositionsItem ?? this.jobPositionsItem,
      regionsItems: regionsItems ?? this.regionsItems,
      recruitersItems: recruitersItems ?? this.recruitersItems,
      statesItems: statesItems ?? this.statesItems,
      branchesItems: branchesItems ?? this.branchesItems,
      jobPositionId: jobPositionId,
      regionId: regionId,
      recruiterId: recruiterId,
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
    vacanciesStatus,
    vacanciesContainer,
    jobPositionsItem,
    regionsItems,
    recruitersItems,
    statesItems,
    branchesItems,
    statesId,
    regionId,
    recruiterId,
    branchId,
    currentPage,
    totalPage,
    perPage,
    searchQuery,
    context,
  ];
}
