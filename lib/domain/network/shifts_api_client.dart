import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/data/data_provider/session_data_provider.dart';
import 'package:hrms/data/models/shifts/shift.dart';
import 'package:hrms/data/models/shifts/shifts.dart';
import 'package:hrms/domain/network/network_utils.dart';
import 'package:http/http.dart' as http;

class ShiftsApiClient {
  Future<Shifts> getShifts(
      {String? searchQuery,
      int? page,
      int? toJobPositionId,
      int? branchId,
      int? stateId}) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'shifts/get?' +
            ('search=$searchQuery&page=$page') +
            (toJobPositionId != null
                ? '&to_job_position_id=$toJobPositionId'
                : '') +
            (branchId != null ? '&branch_id=$branchId' : '') +
            (stateId != null ? '&state_id=$stateId' : ''),
        method: HttpMethod.GET,
      ),
    );
    final response = Shifts.fromJson(decoded);
    return response;
  }

  Future<Shift> getShift({required int id}) async {
    final decoded = await handleResponse(
      await buildHttpResponse('shifts/get/$id', method: HttpMethod.GET),
    );
    return Shift.fromJson(decoded['result']['shift']);
  }

  Future updateState({
    String action = 'next',
    required int shiftId,
    required String message,
  }) async {
    await handleResponse(
      await buildHttpResponse(
        'shifts/update/$shiftId/state?state=$action&message=$message',
        method: HttpMethod.POST,
      ),
    );
  }

  Future updateImageState({
    String action = 'next',
    required int shiftId,
    required String message,
    required File fileImage,
  }) async {
    final mBaseUrl = dotenv.env['MAIN_URL'];
    print(mBaseUrl);
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$mBaseUrl${'shifts/update/$shiftId/state?message=$message&state=$action'}'));

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

  Future<void> addShift({
    required int personId,
    required int toBranchId,
    required int staffId,
    required String experience,
    required String achievements,
    required String mistakes,
    required String goal,
    required int toJobPositionId,
  }) async {
    await handleResponse(
      await buildHttpResponse(
        'shifts/create?person_id=$personId&to_branch_id=$toBranchId&staff_id=$staffId'
            '&experience=$experience&accomplishments=$achievements&violations=$mistakes&goal=$goal'
            '&to_job_position_id=$toJobPositionId',
        method: HttpMethod.POST,
      ),
    );
  }
}
