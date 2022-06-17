part of 'permissions_bloc.dart';

abstract class PermissionsEvent extends Equatable {
  const PermissionsEvent();
}

class PermissionsFetchEvent extends PermissionsEvent {
  final String query;
  final int page;
  final BuildContext context;

  const PermissionsFetchEvent(this.query, this.page, this.context);

  PermissionsFetchEvent copyWith({
    String? query,
    int? page,
    BuildContext? context,
  }) {
    return PermissionsFetchEvent(query ?? this.query, page ?? this.page, context ?? this.context);
  }

  @override
  List<Object?> get props => [query, page];
}


class PermissionsResetLoadEvent extends PermissionsEvent {
  final String query;
  final int page;

  const PermissionsResetLoadEvent(this.query, this.page);

  PermissionsResetLoadEvent copyWith({
    String? query,
    int? page,
  }) {
    return PermissionsResetLoadEvent(query ?? this.query, page ?? this.page);
  }

  @override
  List<Object?> get props => [query, page];
}

class PermissionsReloadEvent extends PermissionsEvent {
  final String query;
  final int page;

  const PermissionsReloadEvent(this.query, this.page);

  PermissionsReloadEvent copyWith({
    String? query,
    int? page,
  }) {
    return PermissionsReloadEvent(query ?? this.query, page ?? this.page);
  }

  @override
  List<Object?> get props => [query, page];
}
