import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hrms/data/resources/common.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(NavbarItem.candidates, isCan('get-stats-candidates') ? 0 : isCan('get-stats-shifts') ? 1 : 2));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.candidates:
        emit(NavigationState(NavbarItem.candidates, 0));
        break;
      case NavbarItem.shifts:
        emit(NavigationState(NavbarItem.shifts, 1));
        break;
      case NavbarItem.vacancies:
        emit(NavigationState(NavbarItem.vacancies, 2));
        break;
    }
  }
}