import 'dart:io';

import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/candidates/candidate.dart' as candidate;
import 'package:hrms/data/models/candidates/candidates.dart';
import 'package:hrms/data/models/vacancy/vacancy.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/network/branches_api_client.dart';
import 'package:hrms/domain/network/candidates_api_client.dart';
import 'package:hrms/domain/network/departments_api.dart';
import 'package:hrms/domain/network/region_district_api_client.dart';
import 'package:hrms/domain/network/vacancies_api_client.dart';

class CandidatesService {
  final _candidatesApiClient = CandidatesApiClient();
  final _regDistApiClient = RegDistApiClient();
  final _branchesApiClient = BranchesApiClient();
  final _departmentsApiClient = DepartmentsApiClient();
  final _vacanciesApiClient = VacanciesApiClient();

  Future<Candidates> getCandidates({
    required String searchQuery,
    required int page,
    int? branchId,
    int? regionId,
    int? stateId,
    int? jobPositionId,
    String? sex,
    bool showOnlyHotCandidates = false,
  }) async {
    return _candidatesApiClient.getCandidates(
      searchQuery: searchQuery,
      page: page,
      branchId: branchId,
      regionId: regionId,
      sex: sex,
      stateId: stateId,
      jobPositionId: jobPositionId,
      onlyHotCandidates: showOnlyHotCandidates,
    );
  }

  Future<candidate.Candidate> getCandidate(int id) async {
    return _candidatesApiClient.getCandidate(id: id);
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
    return _candidatesApiClient.updateCandidate(
      candidateId: candidateId,
      firstName: firstName,
      lastName: lastName,
      fatherName: fatherName,
      dateOfBirth: dateOfBirth,
      jobPositionId: jobPositionId,
      branchId: branchId,
    );
  }

  Future getStates() async {
    return _regDistApiClient.getStates(CANDIDATES_TABLE_NAME);
  }

  Future<Branches> getBranches({
    String? searchQuery,
    int? page,
    String? shopCategory,
    int? regionId,
    bool? isPaginated,
  }) async {
    return _branchesApiClient.getBranches(
      searchQuery: searchQuery,
      page: page,
      shopCategory: shopCategory,
      regionId: regionId,
      isPagination: isPaginated,
    );
  }

  Future getRegions() async {
    return _regDistApiClient.getRegions();
  }

  Future getJobPositions() async {
    return _departmentsApiClient.getJobPositions(null);
  }

  Future<List<Vacancy>> getVacancyPagination(int branchId) async {
    return _vacanciesApiClient.getVacancyPagination(branchId: branchId);
  }

  Future<void> updateState(
      {String action = 'next',
      required int candidateId,
      required String message,
      String? interviewDate,
      String? interviewAddress,
      int? staffId}) async {
    return _candidatesApiClient.updateState(
        action: action,
        candidateId: candidateId,
        message: message,
        interviewAddress: interviewAddress,
        interviewDate: interviewDate,
        staffId: staffId);
  }

  Future<void> changeStateWithJobOffer({
    required int candidateId,
    required String message,
    required File fileImage,
    required int staffId,
  }) async {
    return _candidatesApiClient.changeStateWithJobOffer(
      candidateId: candidateId,
      message: message,
      fileImage: fileImage,
      staffId: staffId,
    );
  }
}
