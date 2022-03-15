part of 'shifts_bloc.dart';


abstract class ShiftsEvent extends Equatable {
  const ShiftsEvent();
}

class ShiftsPageInitializeEvent extends ShiftsEvent {
  final BuildContext context;

  const ShiftsPageInitializeEvent(this.context);

  ShiftsPageInitializeEvent copyWith({
    BuildContext? context,
  }) {
    return ShiftsPageInitializeEvent(context ?? this.context);
  }

  @override
  List<Object?> get props => [context];
}

class ShiftsFetchEvent extends ShiftsEvent {
  final String query;
  final int page;
  final int? toJobPositionId;
  final int? stateId;
  final int? branchId;
  final BuildContext context;

  const ShiftsFetchEvent({
    required this.query,
    required this.page,
    this.toJobPositionId,
    this.stateId,
    this.branchId,
    required this.context,
  });

  ShiftsFetchEvent copyWith({
    String? query,
    int? page,
    int? toJobPositionId,
    int? stateId,
    int? branchId,
    BuildContext? context,
  }) {
    return ShiftsFetchEvent(
      query: query ?? this.query,
      page: page ?? this.page,
      toJobPositionId: toJobPositionId,
      stateId: stateId,
      branchId: branchId,
      context: context ?? this.context,
    );
  }

  @override
  List<Object?> get props => [
    query,
    page,
    context,
    toJobPositionId,
    stateId,
    branchId,
  ];
}

class ShiftsResetLoadEvent extends ShiftsEvent {
  final String query;
  final int page;

  const ShiftsResetLoadEvent(this.query, this.page);

  ShiftsResetLoadEvent copyWith({
    String? query,
    int? page,
  }) {
    return ShiftsResetLoadEvent(query ?? this.query, page ?? this.page);
  }

  @override
  List<Object?> get props => [query, page];
}

class ShiftsReloadEvent extends ShiftsEvent {
  final BuildContext context;

  const  ShiftsReloadEvent(
      this.context,
      );

  ShiftsReloadEvent copyWith({
    BuildContext? context,
  }) {
    return ShiftsReloadEvent(
      context ?? this.context,
    );
  }

  @override
  List<Object?> get props => [context];
}
