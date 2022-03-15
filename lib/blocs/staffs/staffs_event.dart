part of 'staffs_bloc.dart';

abstract class StaffsEvent extends Equatable {
  const StaffsEvent();
}

class StaffsPageInitializeEvent extends StaffsEvent {
  final BuildContext context;

  const StaffsPageInitializeEvent(this.context);

  StaffsPageInitializeEvent copyWith({
    BuildContext? context,
  }) {
    return StaffsPageInitializeEvent(context ?? this.context);
  }

  @override
  List<Object?> get props => [context];
}

class StaffsFetchEvent extends StaffsEvent {
  final String query;
  final int page;
  final int? departmentId;
  final int? stateId;
  final int? branchId;
  final BuildContext context;

  const StaffsFetchEvent({
    required this.query,
    required this.page,
    this.departmentId,
    this.stateId,
    this.branchId,
    required this.context,
  });

  StaffsFetchEvent copyWith({
    String? query,
    int? page,
    int? departmentId,
    int? stateId,
    int? branchId,
    BuildContext? context,
  }) {
    return StaffsFetchEvent(
      query: query ?? this.query,
      page: page ?? this.page,
      departmentId: departmentId,
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
        departmentId,
        stateId,
        branchId,
      ];
}

class StaffsResetLoadEvent extends StaffsEvent {
  const StaffsResetLoadEvent();

  @override
  List<Object?> get props => [];
}

class StaffsReloadEvent extends StaffsEvent {
  const StaffsReloadEvent();

  @override
  List<Object?> get props => [];
}

class StaffsDeleteEvent extends StaffsEvent {
  final int id;
  final BuildContext context;

  const StaffsDeleteEvent(this.id, this.context);

  StaffsDeleteEvent copyWith({
    int? id,
    BuildContext? context,
  }) {
    return StaffsDeleteEvent(id ?? this.id, context ?? this.context);
  }

  @override
  List<Object?> get props => [id, context];
}
