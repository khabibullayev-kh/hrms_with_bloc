import 'package:hrms/data/models/departments/departments.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/domain/network/departments_api.dart';

class DepartmentsService {
  final _departmentsApiClient = DepartmentsApiClient();

  Future<Departments> getDepartments() async {
    return _departmentsApiClient.getDepartments();
  }

  Future<List<JobPosition>> getJobPositions(int departmentId) async {
    return _departmentsApiClient.getJobPositions(departmentId);
  }

  Future<JobPosition> getJobPosition(int jobPositionId) async {
    return _departmentsApiClient.getJobPosition(jobPositionId);
  }

  Future<void> updateJobPosition({
    required int id,
    required String slug,
    required String nameUz,
    required String nameRu,
    required int departmentId,
  }) async {
    await _departmentsApiClient.updateJobPosition(
      id: id,
      slug: slug,
      nameUz: nameUz,
      nameRu: nameRu,
      departmentId: departmentId,
    );
  }

  Future<void> addJobPosition({
    required int departmentId,
    required String nameUz,
    required String nameRu,
  }) async {
    await _departmentsApiClient.addJobPosition(
      departmentId: departmentId,
      nameUz: nameUz,
      nameRu: nameRu,
    );
  }

  Future<void> deleteJobPosition(int jobPositionId) async {
    await _departmentsApiClient.deleteJobPosition(jobPositionId);
  }
}
