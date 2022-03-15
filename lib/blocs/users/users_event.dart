part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();
}

class UsersFetchEvent extends UsersEvent {
  final String query;
  final int page;
  final BuildContext context;

  const UsersFetchEvent(this.query, this.page, this.context);

  UsersFetchEvent copyWith({
    String? query,
    int? page,
    BuildContext? context,
  }) {
    return UsersFetchEvent(query ?? this.query, page ?? this.page, context ?? this.context);
  }

  @override
  List<Object?> get props => [query, page];
}


class UsersResetLoadEvent extends UsersEvent {
  final String query;
  final int page;

  const UsersResetLoadEvent(this.query, this.page);

  UsersResetLoadEvent copyWith({
    String? query,
    int? page,
  }) {
    return UsersResetLoadEvent(query ?? this.query, page ?? this.page);
  }

  @override
  List<Object?> get props => [query, page];
}

class UsersReloadEvent extends UsersEvent {
  final String query;
  final int page;

  const UsersReloadEvent(this.query, this.page);

  UsersReloadEvent copyWith({
    String? query,
    int? page,
  }) {
    return UsersReloadEvent(query ?? this.query, page ?? this.page);
  }

  @override
  List<Object?> get props => [query, page];
}
