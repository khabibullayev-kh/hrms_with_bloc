import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/blocs/auth_bloc/auth_bloc.dart';
import 'package:hrms/blocs/auth_bloc/loader_bloc.dart';
import 'package:hrms/blocs/branches/add_branch_mvvm.dart';
import 'package:hrms/blocs/branches/branch_info_mvvm.dart';
import 'package:hrms/blocs/branches/branches_bloc.dart';
import 'package:hrms/blocs/branches/edit_branch_mvvm.dart';
import 'package:hrms/blocs/candidates/candidate_info_mvvm.dart';
import 'package:hrms/blocs/candidates/candidates_bloc.dart';
import 'package:hrms/blocs/candidates/change_candidate_status_mvvm.dart';
import 'package:hrms/blocs/candidates/edit_candidate_mvvm.dart';
import 'package:hrms/blocs/departments/add_job_position_mvvm.dart';
import 'package:hrms/blocs/departments/departments_mvvm.dart';
import 'package:hrms/blocs/departments/edit_job_position_mvvm.dart';
import 'package:hrms/blocs/departments/job_positions_mvvm.dart';
import 'package:hrms/blocs/navbar/navigation_cubit.dart';
import 'package:hrms/blocs/permissions/add_permission_mvvm.dart';
import 'package:hrms/blocs/permissions/edit_permission_mvvm.dart';
import 'package:hrms/blocs/permissions/permissions_bloc.dart';
import 'package:hrms/blocs/persons/add_person_mvvm.dart';
import 'package:hrms/blocs/persons/edit_person_mvvm.dart';
import 'package:hrms/blocs/persons/persons_bloc.dart';
import 'package:hrms/blocs/roles/add_role_mvvm.dart';
import 'package:hrms/blocs/roles/edit_role_mvvm.dart';
import 'package:hrms/blocs/roles/roles_bloc.dart';
import 'package:hrms/blocs/settings/settings_view_model.dart';
import 'package:hrms/blocs/shifts/add_shift_mvvm.dart';
import 'package:hrms/blocs/shifts/change_shifts_status_view_model.dart';
import 'package:hrms/blocs/shifts/shift_info_mvvm.dart';
import 'package:hrms/blocs/shifts/shifts_bloc.dart';
import 'package:hrms/blocs/staffs/add_staff_mvvm.dart';
import 'package:hrms/blocs/staffs/edit_staff_mvvm.dart';
import 'package:hrms/blocs/staffs/staffs_bloc.dart';
import 'package:hrms/blocs/users/add_user_mvvm.dart';
import 'package:hrms/blocs/users/edit_user_mvvm.dart';
import 'package:hrms/blocs/users/users_bloc.dart';
import 'package:hrms/blocs/vacancies/add_vacancy_mvvm.dart';
import 'package:hrms/blocs/vacancies/edit_vacancy_mvvm.dart';
import 'package:hrms/blocs/vacancies/vacancies_bloc.dart';
import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/models/shifts/shift.dart';
import 'package:hrms/domain/network/user_management_api/user_api_client.dart';
import 'package:hrms/domain/services/permissions_service.dart';
import 'package:hrms/domain/services/roles_service.dart';
import 'package:hrms/ui/pages/branches_page.dart';
import 'package:hrms/ui/pages/candidates_page.dart';
import 'package:hrms/ui/pages/departments_page.dart';
import 'package:hrms/ui/pages/login_page.dart';
import 'package:hrms/ui/pages/permissions_page.dart';
import 'package:hrms/ui/pages/persons_page.dart';
import 'package:hrms/ui/pages/roles_page.dart';
import 'package:hrms/ui/pages/setting_page.dart';
import 'package:hrms/ui/pages/shifts_page.dart';
import 'package:hrms/ui/pages/staffs_page.dart';
import 'package:hrms/ui/pages/statistics_root_screen.dart';
import 'package:hrms/ui/pages/users_page.dart';
import 'package:hrms/ui/pages/vacancies_page.dart';
import 'package:hrms/ui/widgets/branches_widget/add_branch_page.dart';
import 'package:hrms/ui/widgets/branches_widget/branch_info.dart';
import 'package:hrms/ui/widgets/branches_widget/edit_branch_page.dart';
import 'package:hrms/ui/widgets/candidates_widget/candidate_info.dart';
import 'package:hrms/ui/widgets/candidates_widget/candidates_status.dart';
import 'package:hrms/ui/widgets/candidates_widget/edit_candidate_page.dart';
import 'package:hrms/ui/widgets/departments_widget/add_job_position_page.dart';
import 'package:hrms/ui/widgets/departments_widget/edit_job_position_page.dart';
import 'package:hrms/ui/widgets/departments_widget/job_positions_page.dart';
import 'package:hrms/ui/widgets/loader_widget.dart';
import 'package:hrms/ui/widgets/permissions_widget/add_permission_widget.dart';
import 'package:hrms/ui/widgets/permissions_widget/edit_permission_widget.dart';
import 'package:hrms/ui/widgets/persons_widget/add_person_page.dart';
import 'package:hrms/ui/widgets/persons_widget/edit_person_widget.dart';
import 'package:hrms/ui/widgets/roles_widgets/add_role_widget.dart';
import 'package:hrms/ui/widgets/roles_widgets/edit_role_widget.dart';
import 'package:hrms/ui/widgets/shifts_widget/add_shift_page.dart';
import 'package:hrms/ui/widgets/shifts_widget/shift_info_page.dart';
import 'package:hrms/ui/widgets/shifts_widget/shifts_change_state_widget.dart';
import 'package:hrms/ui/widgets/staffs_page/add_staff_page.dart';
import 'package:hrms/ui/widgets/staffs_page/edit_staff_page.dart';
import 'package:hrms/ui/widgets/users_widgets/add_user_widget.dart';
import 'package:hrms/ui/widgets/users_widgets/edit_user_widget.dart';
import 'package:hrms/ui/widgets/vacancies_widget/add_vacancy_page.dart';
import 'package:hrms/ui/widgets/vacancies_widget/edit_vacancy_page.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeLoader() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      child: const LoaderWidget(),
      lazy: false,
    );
  }

  Widget makeSettings() {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(),
      child: const SettingsPage(),
    );
  }

  Widget makeAuth() {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const AuthorizationPage(),
    );
  }

  Widget makeUsersScreen() {
    return BlocProvider(
        create: (_) => UsersBloc(
              usersRepository: UsersApiClient(),
            ),
        child: const UsersPage());
  }

  Widget makeEditUserScreen(final int id) {
    return ChangeNotifierProvider(
      create: (_) => EditUserViewModel(id),
      child: EditUserPage(id: id),
    );
  }

  Widget makeAddUserScreen() {
    return ChangeNotifierProvider(
      create: (_) => AddUserViewModel(),
      child: const AddUsersPage(),
    );
  }

  Widget makeRolesScreen() {
    return BlocProvider(
        create: (_) => RolesBloc(
              rolesService: RolesService(),
            ),
        child: const RolesPage());
  }

  Widget makeAddRolesScreen() {
    return ChangeNotifierProvider(
      create: (_) => AddRoleViewModel(),
      child: const AddRoleWidget(),
    );
  }

  Widget makeEditRolesScreen(final int id) {
    return ChangeNotifierProvider(
      create: (_) => EditRoleViewModel(roleId: id),
      child: EditRoleWidget(roleId: id),
    );
  }

  Widget makePermissionsScreen() {
    return BlocProvider(
        create: (_) => PermissionsBloc(
              permissionsService: PermissionsService(),
            ),
        child: const PermissionsPage());
  }

  Widget makeAddPermissionScreen() {
    return ChangeNotifierProvider(
      create: (_) => AddPermissionViewModel(),
      child: const AddPermissionWidget(),
    );
  }

  Widget makeEditPermissionScreen(final int id) {
    return ChangeNotifierProvider(
      create: (_) => EditPermissionViewModel(permissionId: id),
      child: EditPermissionWidget(permissionId: id),
    );
  }

  Widget makeBranchesScreen() {
    return BlocProvider(
      create: (_) => BranchesBloc(),
      child: const BranchesPage(),
    );
  }

  Widget makeBranchInfoPage(final int id) {
    return ChangeNotifierProvider(
      create: (_) => BranchInfoViewModel(branchId: id),
      child: BranchInfoPage(branchId: id),
    );
  }

  Widget makeEditBranchPage(final int id) {
    return ChangeNotifierProvider(
      create: (_) => EditBranchViewModel(branchId: id),
      child: EditBranchPage(id: id),
    );
  }

  Widget makeAddBranchScreen() {
    return ChangeNotifierProvider(
      create: (_) => AddBranchViewModel(),
      child: const AddBranchPage(),
    );
  }

  Widget makeDepartmentsScreen() {
    return ChangeNotifierProvider(
      create: (_) => DepartmentsViewModel(),
      child: const DepartmentsPage(),
    );
  }

  Widget makeJobPositionsPage(final int id) {
    return ChangeNotifierProvider(
      create: (_) => JobPositionsViewModel(id: id),
      child: JobPositionsPage(id: id),
    );
  }

  Widget makeEditJobPositionsPage(final int id, final departmentId) {
    return ChangeNotifierProvider(
      create: (_) => EditJobPositionViewModel(id, departmentId),
      child: EditJobPositionPage(id: id),
    );
  }

  Widget makeAddJobPositionScreen() {
    return ChangeNotifierProvider(
      create: (_) => AddJobPositionViewModel(),
      child: const AddJobPositionPage(),
    );
  }

  Widget makeCandidatesScreen() {
    return BlocProvider(
      create: (_) => CandidatesBloc(),
      child: const CandidatesPage(),
    );
  }

  Widget makeEditCandidatesPage(final int id) {
    return ChangeNotifierProvider(
      create: (_) => EditCandidateViewModel(candidateId: id),
      child: EditCandidatePage(id: id),
    );
  }

  Widget makeChangeStatusCandidatesPage(final Candidate candidate) {
    return ChangeNotifierProvider(
      create: (_) => ChangeCandidateStatusViewModel(candidate: candidate),
      child: CandidatesChangeState(candidate: candidate),
    );
  }

  Widget makeCandidateInfoPage(final int id, final CandidatesBloc bloc) {
    return ChangeNotifierProvider(
      create: (_) => CandidateInfoViewModel(candidateId: id),
      child: CandidateInfoPage(bloc: bloc),
    );
  }

  Widget makeShiftsScreen() {
    return BlocProvider(
      create: (_) => ShiftsBloc(),
      child: const ShiftsPage(),
    );
  }

  Widget makeShiftInfoPage(final int id) {
    return ChangeNotifierProvider(
      create: (_) => ShiftInfoViewModel(shiftId: id),
      child: ShiftInfoPage(shiftId: id),
    );
  }

  Widget makeAddShiftScreen() {
    return ChangeNotifierProvider(
      create: (_) => AddShiftViewModel(),
      child: const AddShiftPage(),
    );
  }

  Widget makeChangeShiftsStatusPage(final Shift shift) {
    return ChangeNotifierProvider(
      create: (_) => ChangeShiftsStatusViewModel(shift: shift),
      child: ShiftsChangeState(shift: shift),
    );
  }

  Widget makePersonsScreen() {
    return BlocProvider(
      create: (_) => PersonsBloc(),
      child: const PersonsPage(),
    );
  }

  Widget makeAddPersonsScreen() {
    return ChangeNotifierProvider(
      create: (_) => AddPersonsViewModel(),
      child: const AddPersonPage(),
    );
  }

  Widget makeEditPersonPage(final int id) {
    return ChangeNotifierProvider(
      create: (_) => EditPersonViewModel(id: id),
      child: EditPersonPage(id: id),
    );
  }

  Widget makeStaffsScreen() {
    return BlocProvider(
      create: (_) => StaffsBloc(),
      child: const StaffsPage(),
    );
  }

  Widget makeAddStaffScreen() {
    return ChangeNotifierProvider(
      create: (_) => AddStaffViewModel(),
      child: const AddStaffPage(),
    );
  }

  Widget makeEditStaffScreen(final int id) {
    return ChangeNotifierProvider(
      create: (_) => EditStaffViewModel(id),
      child: EditStaffPage(id: id),
    );
  }

  Widget makeVacancyScreen() {
    return BlocProvider(
      create: (_) => VacanciesBloc(),
      child: const VacanciesPage(),
    );
  }

  Widget makeAddVacancyScreen() {
    return ChangeNotifierProvider(
      create: (_) => AddVacancyViewModel(),
      child: const AddVacancyPage(),
    );
  }

  Widget makeEditVacancyScreen(final int id) {
    return ChangeNotifierProvider(
      create: (_) => EditVacancyViewModel(id: id),
      child: EditVacancyPage(id: id),
    );
  }

  Widget makeStatisticsScreen() {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: const StatisticsRootScreen(),
    );
  }
}
