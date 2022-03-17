import 'package:hrms/data/models/staffs/staff.dart';
import 'package:hrms/data/models/staffs/staffs.dart';
import 'package:hrms/domain/network/network_utils.dart';

class StaffsApiClient {
  Future<Staffs> getStaffs({
    String? searchQuery,
    int? page,
    int? stateId,
    int? departmentId,
    int? branchId,
    bool isPaginated = false,
  }) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'staffs/get?' +
            (isPaginated
                ? ('pagination=0')
                : (('search=$searchQuery&page=$page') +
                (branchId != null ? '&branch_id=$branchId' : '') +
                (departmentId != null ? '&department_id=$departmentId' : ''))) +
            (stateId != null ? '&state_id=$stateId' : ''),
        method: HttpMethod.GET,
      ),
    );
    final response = Staffs.fromJson(decoded);
    return response;
  }

  Future<Staff> getStaff({required int id}) async {
    final decoded = await handleResponse(
      await buildHttpResponse('staffs/get/$id?', method: HttpMethod.GET),
    );
    return Staff.fromJson(decoded['result']['staff']);
  }

  Future<void> addStaff({
    required int? personId,
    required int branchId,
    required int jobPositionId,
    required int departmentId,
    required int stateId,
    required String confirmedDate,
  }) async {
    await handleResponse(
      await buildHttpResponse(
        'staffs/create?person_id=${personId ?? ''}&branch_id=$branchId'
            '&job_position_id=$jobPositionId&department_id=$departmentId'
            '&state_id=$stateId&confirmed_date=$confirmedDate',
        method: HttpMethod.POST,
      ),
    );
  }


  Future<void> updateStaff({
    required int? staffId,
    required int? personId,
    required int branchId,
    required int jobPositionId,
    required int departmentId,
    required int stateId,
    required String confirmedDate,
  }) async {
    await handleResponse(
      await buildHttpResponse(
        'staffs/update/$staffId?person_id=${personId ?? ''}&branch_id=$branchId'
            '&job_position_id=$jobPositionId&department_id=$departmentId'
            '&state_id=$stateId&confirmed_date=$confirmedDate',
        method: HttpMethod.PATCH,
      ),
    );
  }

  Future<void> deleteStaff({required int id}) async {
    await handleResponse(
      await buildHttpResponse('staffs/$id', method: HttpMethod.DELETE),
    );
  }

  Future<void> dismissStaff({required int id, required String dismissDate}) async {
    await handleResponse(
      await buildHttpResponse('staffs/dismiss_person/$id?dismissal_date=$dismissDate', method: HttpMethod.DELETE),
    );
  }

  Future<Staffs> getFreeStaffs({
    int? stateId,
    int? branchId,
  }) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'staffs/get?not_filter=true&vacancies_only=true&pagination=0&branch_id=$branchId',
        method: HttpMethod.GET,
      ),
    );
    final response = Staffs.fromJson(decoded);
    return response;
  }
}
