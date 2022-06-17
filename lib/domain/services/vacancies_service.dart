import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/departments/departments.dart';
import 'package:hrms/data/models/director_rec_kadr_regman/director.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/data/models/states/state.dart';
import 'package:hrms/data/models/vacancy/vacancy.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/network/branches_api_client.dart';
import 'package:hrms/domain/network/departments_api.dart';
import 'package:hrms/domain/network/region_district_api_client.dart';
import 'package:hrms/domain/network/user_management_api/user_api_client.dart';
import 'package:hrms/domain/network/vacancies_api_client.dart';
import 'package:hrms/data/models/old_vacancy/vacancies.dart' as old;


class VacanciesService {
  final _usersApiClient = UsersApiClient();
  final _regDistApiClient = RegDistApiClient();
  final _branchesApiClient = BranchesApiClient();
  final _departmentsApiClient = DepartmentsApiClient();
  final _vacanciesApiClient = VacanciesApiClient();

  Future<old.Vacancies> getVacancies({
    required String searchQuery,
    required int page,
    int? branchId,
    int? regionId,
    int? stateId,
    int? jobPositionId,
    int? recruiterId,
  }) async {
    return _vacanciesApiClient.getVacancies(
      searchQuery: searchQuery,
      page: page,
      branchId: branchId,
      regionId: regionId,
      recruiterId: recruiterId,
      stateId: stateId,
      jobPositionId: jobPositionId,
    );
  }

  Future<Vacancy> getVacancy(int id) async {
    return _vacanciesApiClient.getVacancy(id: id);
  }

  Future<List<Director>> getRoles() async {
    return _usersApiClient.getRoles(RECRUITER_ROLE_ID);
  }

  Future<void> addVacancy({
    required int branchId,
    required int jobPositionsId,
    required int departmentId,
    required int stateId,
    required int importanceId,
    required String expectedAt,
    required String mentor,
    required String requirements,
    required String description,
    required String salary,
    required String bonus,
    required String quantity,
  }) async {
    await _vacanciesApiClient.addVacancy(
      branchId: branchId,
      jobPositionsId: jobPositionsId,
      departmentId: departmentId,
      stateId: stateId,
      importanceId: importanceId,
      expectedAt: expectedAt,
      mentor: mentor,
      requirements: requirements,
      description: description,
      salary: salary,
      bonus: bonus,
      quantity: quantity,
    );
  }

  Future<void> updateVacancy({
    required int vacancyId,
    required int branchId,
    required int jobPositionsId,
    required int stateId,
    required int importanceId,
    required String expectedAt,
    required String mentor,
    required String requirements,
    required String description,
    required String salary,
    required String bonus,
    required String quantity,
  }) async {
    await _vacanciesApiClient.updateVacancy(
      vacancyId: vacancyId,
      branchId: branchId,
      jobPositionsId: jobPositionsId,
      stateId: stateId,
      importanceId: importanceId,
      expectedAt: expectedAt,
      mentor: mentor,
      requirements: requirements,
      description: description,
      salary: salary,
      bonus: bonus,
      quantity: quantity,
    );
  }

  Future<List<State>> getStates() async {
    return _regDistApiClient.getStates(VACANCIES_TABLE_NAME);
  }

  Future<Branches> getBranches() async {
    return _branchesApiClient.getBranches(isPagination: true);
  }

  Future getRegions() async {
    return _regDistApiClient.getRegions();
  }

  Future<List<JobPosition>> getJobPositions(int? departmentId) async {
    return _departmentsApiClient.getJobPositions(departmentId);
  }

  Future<Departments> getDepartments() async {
    return _departmentsApiClient.getDepartments();
  }

// Future<void> updateState({
//   String action = 'next',
//   required int candidateId,
//   required String message,
//   String? interviewDate,
//   String? interviewAddress,
//   int? vacancyId,
//   int? branchId,
// }) async {
//   return _candidatesApiClient.updateState(
//     action: action,
//     candidateId: candidateId,
//     message: message,
//     interviewAddress: interviewAddress,
//     interviewDate: interviewDate,
//     vacancyId: vacancyId,
//     branchId: branchId,
//   );
// }
}
