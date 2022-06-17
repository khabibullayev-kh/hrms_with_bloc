import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/departments/departments.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/data/models/persons/persons.dart';
import 'package:hrms/data/models/staffs/staff.dart';
import 'package:hrms/data/models/staffs/staffs.dart';
import 'package:hrms/data/models/states/state.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/network/branches_api_client.dart';
import 'package:hrms/domain/network/departments_api.dart';
import 'package:hrms/domain/network/persons_api_client.dart';
import 'package:hrms/domain/network/region_district_api_client.dart';
import 'package:hrms/domain/network/staff_api_client.dart';

class StaffsService {
  final _staffApiClient = StaffsApiClient();
  final _branchesApiClient = BranchesApiClient();
  final _regDistApiClient = RegDistApiClient();
  final _personsApiClient = PersonsApiClient();
  final _departmentsApiClient = DepartmentsApiClient();

  Future<Staffs> getStaffs({
    String? searchQuery,
    int? page,
    int? stateId,
    int? departmentId,
    int? branchId,
    bool isPaginated = false,
  }) async {
    return _staffApiClient.getStaffs(
      searchQuery: searchQuery,
      page: page,
      stateId: stateId,
      departmentId: departmentId,
      branchId: branchId,
      isPaginated: isPaginated,
    );
  }

  Future<void> addStaff({
    required int? personId,
    required int branchId,
    required int jobPositionId,
    required int departmentId,
    required int stateId,
    required String confirmedDate,
  }) async {
    await _staffApiClient.addStaff(
      personId: personId,
      branchId: branchId,
      jobPositionId: jobPositionId,
      departmentId: departmentId,
      stateId: stateId,
      confirmedDate: confirmedDate,
    );
  }

  Future<void> updateStaff({
    required int staffId,
    required int? personId,
    required int branchId,
    required int jobPositionId,
    required int departmentId,
    required int stateId,
    required String confirmedDate,
    required String client,
  }) async {
    await _staffApiClient.updateStaff(
      staffId: staffId,
      personId: personId,
      branchId: branchId,
      jobPositionId: jobPositionId,
      departmentId: departmentId,
      stateId: stateId,
      confirmedDate: confirmedDate,
      client: client,
    );
  }

  Future<void> deleteStaff(int id) async {
    await _staffApiClient.deleteStaff(id: id);
  }

  Future<void> dismissStaff(int id, String dismissDate) async {
    await _staffApiClient.dismissStaff(id: id, dismissDate: dismissDate);
  }

  Future<Departments> getDepartments() async {
    return _departmentsApiClient.getDepartments();
  }

  Future<List<JobPosition>> getJobPositions(int departmentId) async {
    return _departmentsApiClient.getJobPositions(departmentId);
  }

  Future<Staff> getStaff(int id) async {
    return _staffApiClient.getStaff(id: id);
  }

  Future<Branches> getBranches() async {
    return _branchesApiClient.getBranches(isPagination: true);
  }

  Future<List<State>> getStates() async {
    return _regDistApiClient.getStates(VACANCIES_TABLE_NAME);
  }

  Future<Persons> getPersons() async {
    return _personsApiClient.getPersons(1, '', isPaginated: true);
  }
}
