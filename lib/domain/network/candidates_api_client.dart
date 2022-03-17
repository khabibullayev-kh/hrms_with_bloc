import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/models/candidates/candidates.dart';
import 'package:hrms/domain/network/network_utils.dart';

class CandidatesApiClient {
  Future<Candidates> getCandidates({
    required String searchQuery,
    required int page,
    int? branchId,
    int? regionId,
    int? stateId,
    int? jobPositionId,
    String? sex,
    bool onlyHotCandidates = false,
  }) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'candidates/get?' +
            ('search=$searchQuery&page=$page') +
            (branchId != null ? '&branch_id=$branchId' : '') +
            (regionId != null ? '&region_id=$regionId' : '') +
            (stateId != null ? '&state_id=$stateId' : '') +
            (jobPositionId != null ? '&job_position_id=$jobPositionId' : '') +
            (sex != null ? '&sex=$sex' : '')
            +
            (onlyHotCandidates == true ? '&only_hot_candidates=1' : ''),
        method: HttpMethod.GET,
      ),
    );
    final response = Candidates.fromJson(decoded);
    return response;
  }

  Future<Candidate> getCandidate({required int id}) async {
    final decoded = await handleResponse(
      await buildHttpResponse('candidates/get/$id?', method: HttpMethod.GET),
    );
    return Candidate.fromJson(decoded['result']['candidate']);
  }

  Future<void> updateCandidate({
    required int candidateId,
    required String firstName,
    required String lastName,
    required String fatherName,
    required String dateOfBirth,
    required int jobPositionId,
    required int branchId,
  }) async {
    await handleResponse(
      await buildHttpResponse(
        'candidates/update/$candidateId?first_name=$firstName'
        '&last_name=$lastName&father_name=$fatherName&date_of_birth=$dateOfBirth'
        '&job_position_id=$jobPositionId&branch_id=$branchId',
        method: HttpMethod.PATCH,
      ),
    );
  }

  Future<void> updateState({
    String action = 'next',
    required int candidateId,
    required String message,
    String? interviewDate,
    String? interviewAddress,
    int? vacancyId,
    int? branchId,

  }) async {
    await handleResponse(
      await buildHttpResponse(
        'candidates/update/$candidateId/state?state=$action&message=$message' +
            (interviewDate != null && interviewAddress != null
                ? '&interview_date=$interviewDate&interview_address=$interviewAddress'
                : '') +
            (vacancyId != null && branchId != null
                ? '&branch_id=$branchId&vacancy_id=$vacancyId'
                : ''),
        method: HttpMethod.PATCH,
      ),
    );
  }
}
