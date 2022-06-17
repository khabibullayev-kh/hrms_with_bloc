part of 'roles_bloc.dart';

abstract class RolesEvent extends Equatable {
  const RolesEvent();
}

class RolesFetchEvent extends RolesEvent {
  final String query;
  final int page;
  final BuildContext context;

  const RolesFetchEvent(this.query, this.page, this.context);

  RolesFetchEvent copyWith({
    String? query,
    int? page,
    BuildContext? context,
  }) {
    return RolesFetchEvent(query ?? this.query, page ?? this.page, context ?? this.context);
  }

  @override
  List<Object?> get props => [query, page];
}


class RolesResetLoadEvent extends RolesEvent {
  final String query;
  final int page;

  const RolesResetLoadEvent(this.query, this.page);

  RolesResetLoadEvent copyWith({
    String? query,
    int? page,
  }) {
    return RolesResetLoadEvent(query ?? this.query, page ?? this.page);
  }

  @override
  List<Object?> get props => [query, page];
}

class RolesReloadEvent extends RolesEvent {
  final String query;
  final int page;

  const RolesReloadEvent(this.query, this.page);

  RolesReloadEvent copyWith({
    String? query,
    int? page,
  }) {
    return RolesReloadEvent(query ?? this.query, page ?? this.page);
  }

  @override
  List<Object?> get props => [query, page];
}
