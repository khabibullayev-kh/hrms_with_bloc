part of 'persons_bloc.dart';

abstract class PersonsEvent extends Equatable {
  const PersonsEvent();
}

class PersonsFetchEvent extends PersonsEvent {
  final String query;
  final int page;
  final BuildContext context;

  const PersonsFetchEvent(this.query, this.page, this.context);

  PersonsFetchEvent copyWith({
    String? query,
    int? page,
    BuildContext? context,
  }) {
    return PersonsFetchEvent(query ?? this.query, page ?? this.page, context ?? this.context);
  }

  @override
  List<Object?> get props => [query, page];
}


class PersonsResetLoadEvent extends PersonsEvent {

  const PersonsResetLoadEvent();

  @override
  List<Object?> get props => [];
}

class PersonsReloadEvent extends PersonsEvent {
  const PersonsReloadEvent();

  @override
  List<Object?> get props => [];
}

class PersonsDeleteEvent extends PersonsEvent {
  final int id;
  final BuildContext context;

  const PersonsDeleteEvent(this.id, this.context);

  PersonsDeleteEvent copyWith({
    int? id,
    BuildContext? context,
  }) {
    return PersonsDeleteEvent(id ?? this.id, context ?? this.context);
  }

  @override
  List<Object?> get props => [id, context];
}
