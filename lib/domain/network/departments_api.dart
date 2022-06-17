import 'package:hrms/data/models/departments/departments.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/domain/network/network_utils.dart';

class DepartmentsApiClient {
  Future<Departments> getDepartments() async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'departments/get?',
        method: HttpMethod.GET,
      ),
    );
    final response = Departments.fromJson(decoded);
    return response;
  }

  Future<List<JobPosition>> getJobPositions(int? departmentId) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'job-positions/get?' + (departmentId != null ? 'department_id=$departmentId&pagination=0' : 'pagination=0'),
        method: HttpMethod.GET,
      ),
    );
    print(decoded);
    final response = List<JobPosition>.from(
        decoded["result"]["job_positions"].map((x) => JobPosition.fromJson(x)));
    return response;
  }

  Future<JobPosition> getJobPosition(int jobPositionId) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'job-positions/get/$jobPositionId?',
        method: HttpMethod.GET,
      ),
    );
    return JobPosition.fromJson(decoded["result"]['job_position']);
  }

  Future<void> updateJobPosition({
    required int id,
    required String slug,
    required String nameUz,
    required String nameRu,
    required int departmentId,
  }) async {
    await handleResponse(
      await buildHttpResponse(
        'job-positions/update/$id?id=$id&slug=$slug&name_uz=$nameUz&name_ru=$nameRu&department_id=$departmentId',
        method: HttpMethod.PATCH,
      ),
    );
  }

  Future<void> addJobPosition({
    required int departmentId,
    required String nameUz,
    required String nameRu,
  }) async {
    await handleResponse(
      await buildHttpResponse(
        'job-positions/create?department_id=$departmentId&name_uz=$nameUz&name_ru=$nameRu',
        method: HttpMethod.POST,
      ),
    );
  }

  Future<void> deleteJobPosition(int jobPositionId) async {
    await handleResponse(
      await buildHttpResponse(
        'job-positions/$jobPositionId',
        method: HttpMethod.DELETE,
      ),
    );
  }
}
