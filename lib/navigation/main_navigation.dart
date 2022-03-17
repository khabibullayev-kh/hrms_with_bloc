import 'package:flutter/material.dart';
import 'package:hrms/blocs/departments/job_positions_mvvm.dart';
import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/models/shifts/shift.dart';
import 'package:hrms/navigation/screen_factory.dart';
import 'package:hrms/ui/widgets/candidates_widget/candidate_info.dart';

abstract class MainNavigationRouteNames {
  static const loaderWidget = '/';
  static const auth = '/auth';
  static const settings = '/settings';
  static const usersScreen = '/users_screen';
  static const editUsersScreen = '/users_screen/edit_users_page';
  static const addUsersScreen = '/users_screen/add_users_page';
  static const rolesScreen = '/roles';
  static const editRolesScreen = '/roles/edit_role_page';
  static const addRolesScreen = '/roles/add_role_page';
  static const permissionsScreen = '/permissions';
  static const editPermissionsScreen = '/permissions/edit_permissions_page';
  static const addPermissionsScreen = '/permissions/add_permissions_page';
  static const branchesScreen = '/branches';
  static const editBranchScreen = '/branches/edit_branch_page';
  static const addBranchScreen = '/branches/add_branch_page';
  static const branchInfoScreen = '/branches/branch_info';
  static const departmentsScreen = '/departments';
  static const jobPositionsScreen = '/departments/job_positions';
  static const editJobPositionScreen =
      '/departments/job_positions/edit_job_position';
  static const addJobPositionScreen =
      '/departments/job_positions/add_job_position';
  static const candidatesScreen = '/candidates';
  static const candidateInfoScreen = '/candidates/candidate_info';
  static const editCandidatesScreen = '/candidates/edit_candidate';
  static const changeStatusCandidatesScreen =
      '/candidates/change_status_candidates_page';
  static const shiftsScreen = '/shifts';
  static const shiftsInfoScreen = '/shifts/info';
  static const editShiftsScreen = '/shifts/edit_shifts_page';
  static const addShiftsScreen = '/shifts/add_shifts_page';
  static const changeShiftsStateScreen = '/shifts/change_shifts_status_page';
  static const personsScreen = '/persons';
  static const addPersonsScreen = '/persons/add_person_page';
  static const editPersonScreen = '/persons/update_person_page';
  static const personsInfoScreen = '/persons/person_info_page';
  static const staffsScreen = '/staffs';
  static const addStaffScreen = '/staffs/add_staff';
  static const editStaffScreen = '/staffs/edit_staff';
  static const vacancyScreen = '/vacancy';
  static const addVacancyScreen = '/vacancy/add_vacancy';
  static const editVacancyScreen = '/vacancy/edit_vacancy';
  static const statisticsScreen = '/statistics';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.loaderWidget: (_) => _screenFactory.makeLoader(),
    MainNavigationRouteNames.auth: (_) => _screenFactory.makeAuth(),
    MainNavigationRouteNames.settings: (_) => _screenFactory.makeSettings(),
    MainNavigationRouteNames.usersScreen: (_) =>
        _screenFactory.makeUsersScreen(),
    MainNavigationRouteNames.addUsersScreen: (_) =>
        _screenFactory.makeAddUserScreen(),
    MainNavigationRouteNames.rolesScreen: (_) =>
        _screenFactory.makeRolesScreen(),
    MainNavigationRouteNames.addRolesScreen: (_) =>
        _screenFactory.makeAddRolesScreen(),
    MainNavigationRouteNames.permissionsScreen: (_) =>
        _screenFactory.makePermissionsScreen(),
    MainNavigationRouteNames.addPermissionsScreen: (_) =>
        _screenFactory.makeAddPermissionScreen(),
    MainNavigationRouteNames.branchesScreen: (_) =>
        _screenFactory.makeBranchesScreen(),
    MainNavigationRouteNames.addBranchScreen: (_) =>
        _screenFactory.makeAddBranchScreen(),
    MainNavigationRouteNames.departmentsScreen: (_) =>
        _screenFactory.makeDepartmentsScreen(),
    MainNavigationRouteNames.addJobPositionScreen: (_) =>
        _screenFactory.makeAddJobPositionScreen(),
    MainNavigationRouteNames.candidatesScreen: (_) =>
        _screenFactory.makeCandidatesScreen(),
    MainNavigationRouteNames.shiftsScreen: (_) =>
        _screenFactory.makeShiftsScreen(),
    MainNavigationRouteNames.addShiftsScreen: (_) =>
        _screenFactory.makeAddShiftScreen(),
    MainNavigationRouteNames.personsScreen: (_) =>
        _screenFactory.makePersonsScreen(),
    MainNavigationRouteNames.addPersonsScreen: (_) =>
        _screenFactory.makeAddPersonsScreen(),
    MainNavigationRouteNames.staffsScreen: (_) =>
        _screenFactory.makeStaffsScreen(),
    MainNavigationRouteNames.addStaffScreen: (_) =>
        _screenFactory.makeAddStaffScreen(),
    MainNavigationRouteNames.vacancyScreen: (_) =>
        _screenFactory.makeVacancyScreen(),
    MainNavigationRouteNames.addVacancyScreen: (_) =>
        _screenFactory.makeAddVacancyScreen(),
    MainNavigationRouteNames.statisticsScreen: (_) =>
        _screenFactory.makeStatisticsScreen(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.editUsersScreen:
        final arguments = settings.arguments;
        final userId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeEditUserScreen(userId),
        );
      case MainNavigationRouteNames.editRolesScreen:
        final arguments = settings.arguments;
        final roleId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeEditRolesScreen(roleId),
        );
      case MainNavigationRouteNames.editPermissionsScreen:
        final arguments = settings.arguments;
        final permissionId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeEditPermissionScreen(permissionId),
        );
      case MainNavigationRouteNames.branchInfoScreen:
        final arguments = settings.arguments;
        final branchId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeBranchInfoPage(branchId),
        );
      case MainNavigationRouteNames.editBranchScreen:
        final arguments = settings.arguments;
        final branchId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeEditBranchPage(branchId),
        );
      case MainNavigationRouteNames.jobPositionsScreen:
        final arguments = settings.arguments;
        final id = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeJobPositionsPage(id),
        );
      case MainNavigationRouteNames.editJobPositionScreen:
        final args = settings.arguments as JobPositionsArguments;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeEditJobPositionsPage(
            args.jobPositionId,
            args.departmentId,
          ),
        );
      case MainNavigationRouteNames.editCandidatesScreen:
        final arguments = settings.arguments;
        final id = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeEditCandidatesPage(id),
        );
      case MainNavigationRouteNames.changeStatusCandidatesScreen:
        final candidate = settings.arguments as Candidate;
        return MaterialPageRoute(
          builder: (_) =>
              _screenFactory.makeChangeStatusCandidatesPage(candidate),
        );
      case MainNavigationRouteNames.candidateInfoScreen:
        final args = settings.arguments as CandidateInfoArguments;

        return MaterialPageRoute(
          builder: (_) =>
              _screenFactory.makeCandidateInfoPage(args.id, args.bloc),
        );
      case MainNavigationRouteNames.changeShiftsStateScreen:
        final shift = settings.arguments as Shift;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeChangeShiftsStatusPage(shift),
        );
      case MainNavigationRouteNames.shiftsInfoScreen:
        final arguments = settings.arguments;
        final id = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeShiftInfoPage(id),
        );
      case MainNavigationRouteNames.editPersonScreen:
        final arguments = settings.arguments;
        final id = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeEditPersonPage(id),
        );
      case MainNavigationRouteNames.editStaffScreen:
        final arguments = settings.arguments;
        final id = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeEditStaffScreen(id),
        );
      case MainNavigationRouteNames.editVacancyScreen:
        final arguments = settings.arguments;
        final id = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeEditVacancyScreen(id),
        );
      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (_) => widget);
    }
  }

  static void resetNavigation(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainNavigationRouteNames.loaderWidget,
      (route) => false,
    );
  }
}
