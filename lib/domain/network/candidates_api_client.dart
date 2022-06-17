import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/data/data_provider/session_data_provider.dart';
import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/models/candidates/candidates.dart';
import 'package:hrms/domain/network/network_utils.dart';
import 'package:http/http.dart' as http;

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
        'persons/get/candidates?' +
            ('search=$searchQuery&page=$page') +
            (branchId != null ? '&branch_id=$branchId' : '') +
            (regionId != null ? '&region_id=$regionId' : '') +
            (stateId != null ? '&state_id=$stateId' : '') +
            (jobPositionId != null ? '&job_position_id=$jobPositionId' : '') +
            (sex != null ? '&sex=$sex' : '') +
            (onlyHotCandidates == true ? '&only_hot_candidates=1' : ''),
        method: HttpMethod.GET,
      ),
    );
    print(decoded);
    final response = Candidates.fromJson(decoded);
    return response;
  }

  Future<Candidate> getCandidate({required int id}) async {
    final decoded = await handleResponse(
      await buildHttpResponse('persons/get/candidates/$id?', method: HttpMethod.GET),
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
        'persons/update/candidates/$candidateId?first_name=$firstName'
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
    int? staffId,
    int? adSourceId,
  }) async {
    await handleResponse(
      await buildHttpResponse(
        'persons/update/candidates/$candidateId/state?state=$action&message=$message' +
            (interviewDate != null && interviewAddress != null
                ? '&interview_date=$interviewDate&interview_address=$interviewAddress'
                : '') +
            (staffId != null
                ? '&staff_id=$staffId'
                : '') + (adSourceId != null ? '&ad_source_id=$adSourceId' : ''),
        method: HttpMethod.POST,
      ),
    );
  }

  Future changeStateWithJobOffer({
    required int candidateId,
    required String message,
    required File fileImage,
    required int staffId,
    required int adSourceId,
  }) async {
    final mBaseUrl = dotenv.env['MAIN_URL'];
    print(mBaseUrl);
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$mBaseUrl${'persons/update/candidates/$candidateId/state?state=next&message=$message&staff_id=$staffId&ad_source_id=$adSourceId'}'));

    final file = await http.MultipartFile.fromPath('file', fileImage.path.toString());
    print(file);

    imageUploadRequest.files.add(file);
    imageUploadRequest.headers.addAll(
        {"Authorization": 'Bearer ${await SessionDataProvider().getToken()}'});
    try {
      final streamedResponse = await imageUploadRequest.send();
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } catch (e) {
      throw UnimplementedError(e.toString());
    }
  }

}
