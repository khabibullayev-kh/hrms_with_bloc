part of 'branches_bloc.dart';

abstract class BranchesEvent extends Equatable {
  const BranchesEvent();
}

class BranchesPageInitializeEvent extends BranchesEvent {
  final BuildContext context;

  const BranchesPageInitializeEvent(this.context);

  BranchesPageInitializeEvent copyWith({
    BuildContext? context,
  }) {
    return BranchesPageInitializeEvent(context ?? this.context);
  }

  @override
  List<Object?> get props => [context];
}

class BranchesFetchEvent extends BranchesEvent {
  final String query;
  final int page;
  final int? regionId;
  final String? shopCategory;
  final BuildContext context;

  const BranchesFetchEvent(this.query, this.page, this.regionId,
      this.shopCategory, this.context);

  BranchesFetchEvent copyWith({
    String? query,
    int? page,
    int? regionId,
    String? shopCategory,
    BuildContext? context,
  }) {
    return BranchesFetchEvent(
        query ?? this.query, page ?? this.page, regionId, shopCategory,
        context ?? this.context);
  }

  @override
  List<Object?> get props => [query, page, regionId, shopCategory];
}

class BranchesResetLoadEvent extends BranchesEvent {
  final String query;
  final int page;

  const BranchesResetLoadEvent(this.query, this.page);

  BranchesResetLoadEvent copyWith({
    String? query,
    int? page,
  }) {
    return BranchesResetLoadEvent(query ?? this.query, page ?? this.page);
  }

  @override
  List<Object?> get props => [query, page];
}

class BranchesReloadEvent extends BranchesEvent {
  final String query;
  final int page;
  final int? regionId;
  final String? shopCategory;

  const BranchesReloadEvent(this.query, this.page, this.regionId,
      this.shopCategory);

  BranchesReloadEvent copyWith({
    String? query,
    int? page,
    int? regionId,
    String? shopCategory,
  }) {
    return BranchesReloadEvent(
      query ?? this.query, page ?? this.page, regionId, shopCategory,);
  }

  @override
  List<Object?> get props => [query, page, regionId, shopCategory];
}
