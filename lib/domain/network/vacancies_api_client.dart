import 'package:hrms/data/models/vacancy/vacancies.dart';
import 'package:hrms/data/models/vacancy/vacancy.dart';
import 'package:hrms/domain/network/network_utils.dart';

class VacanciesApiClient {
  Future<List<Vacancy>> getVacancyPagination({required int branchId}) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'vacancies/get?lang=ru&pagination=0&branch_id=$branchId',
        method: HttpMethod.GET,
      ),
    );
    final response = List<Vacancy>.from(decoded["vacancies"]["data"].map((x) => Vacancy.fromJson(x)));
    return response;
  }

  Future<Vacancies> getVacancies({
    required String searchQuery,
    required int page,
    int? branchId,
    int? regionId,
    int? stateId,
    int? jobPositionId,
    int? recruiterId,
  }) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'vacancies/get?' +
            ('search=$searchQuery&page=$page') +
            (branchId != null ? '&branch_id=$branchId' : '') +
            (regionId != null ? '&region_id=$regionId' : '') +
            (stateId != null ? '&state_id=$stateId' : '') +
            (jobPositionId != null ? '&job_position_id=$jobPositionId' : '') +
            (recruiterId != null ? '&recruiter_id=$recruiterId' : ''),
        method: HttpMethod.GET,
      ),
    );
    final response = Vacancies.fromJson(decoded);
    return response;
  }

  Future<Vacancy> getVacancy({required int id}) async {
    final decoded = await handleResponse(
      await buildHttpResponse('vacancies/get/$id', method: HttpMethod.GET),
    );
    return Vacancy.fromJson(decoded['vacancy']);
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
    await handleResponse(
      await buildHttpResponse(
        'vacancies/create?branch_id=$branchId&position_id=1&department_id=$departmentId'
            '&job_position_id=$jobPositionsId&state_id=$stateId&importance=$importanceId'
            '&expected_at=$expectedAt&mentor=$mentor&requirements=$requirements'
            '&description=$description&salary=$salary&bonus=$bonus&quantity=$quantity',
        method: HttpMethod.POST,
      ),
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
    await handleResponse(
      await buildHttpResponse(
        'vacancies/update/$vacancyId?id=$vacancyId&salary=$salary'
            '&importance=$importanceId&expected_at=$expectedAt'
            '&bonus=$bonus&requirements=$requirements&description=$description'
            '&mentor=$mentor&quantity=$quantity&branch_id=$branchId'
            '&job_position_id=$jobPositionsId&state_id=$stateId',
        method: HttpMethod.PATCH,
      ),
    );
  }
}