import 'dart:io';

import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/shifts/shift.dart';
import 'package:hrms/data/models/shifts/shifts.dart';
import 'package:hrms/data/models/staffs/staffs.dart';
import 'package:hrms/data/models/states/state.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/network/branches_api_client.dart';
import 'package:hrms/domain/network/departments_api.dart';
import 'package:hrms/domain/network/region_district_api_client.dart';
import 'package:hrms/domain/network/shifts_api_client.dart';
import 'package:hrms/domain/network/staff_api_client.dart';

class ShiftsService {
  final _shiftsApiClient = ShiftsApiClient();
  final _branchesApiClient = BranchesApiClient();
  final _regDistApiClient = RegDistApiClient();
  final _departmentsApiClient = DepartmentsApiClient();
  final _staffsApiClient = StaffsApiClient();

  Future<Shifts> getShifts({
    String? searchQuery,
    int? page,
    int? toJobPositionId,
    int? branchId,
    int? stateId,
  }) async {
    return _shiftsApiClient.getShifts(
      searchQuery: searchQuery,
      page: page,
      toJobPositionId: toJobPositionId,
      branchId: branchId,
      stateId: stateId,
    );
  }

  Future<Shift> getShift({required int id}) async {
    return _shiftsApiClient.getShift(id: id);
  }

  Future<void> updateState({
    String action = 'next',
    required int shiftId,
    required String message,
    File? fileImage,
  }) async {
    return fileImage == null
        ? _shiftsApiClient.updateState(
            action: action,
            shiftId: shiftId,
            message: message,
          )
        : _shiftsApiClient.updateImageState(
            shiftId: shiftId,
            message: message,
            fileImage: fileImage,
          );
  }

  Future<List<State>> getStates() async {
    return _regDistApiClient.getStates(SHIFTS_TABLE_NAME);
  }

  Future getJobPositions() async {
    return _departmentsApiClient.getJobPositions(null);
  }

  Future<Branches> getBranches() async {
    return _branchesApiClient.getBranches(
      isPagination: true,
      isContentFull: true,
    );
  }

  Future<Staffs> getStaffs({
    String? searchQuery,
    int? page,
    int? stateId,
    bool isPaginated = false,
  }) async {
    return _staffsApiClient.getStaffs(
      searchQuery: searchQuery,
      page: page,
      stateId: stateId,
      isPaginated: isPaginated,
    );
  }

  Future<Staffs> getFreeStaffs({
    int? stateId,
    int? branchId,
  }) async {
    return _staffsApiClient.getFreeStaffs(branchId: branchId);
  }

  Future<void> addShift({
    required int fromStaffId,
    required int toStaffId,
    required int toBranchId,
    required String experience,
    required String achievements,
    required String mistakes,
    required String goal,
  }) async {
    return _shiftsApiClient.addShift(
      fromStaffId: fromStaffId,
      toStaffId:  toStaffId,
      toBranchId: toBranchId,
      experience: experience,
      achievements: achievements,
      mistakes: mistakes,
      goal: goal,
    );
  }
}
