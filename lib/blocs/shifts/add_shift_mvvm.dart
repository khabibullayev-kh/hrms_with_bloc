import 'package:flutter/material.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/data/models/staffs/staff.dart';
import 'package:hrms/data/models/staffs/staffs.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/shifts_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:nb_utils/nb_utils.dart';

class ShiftAddData {
  bool isInitializing = true;
  bool isLoading = false;
  TextEditingController fioController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController achievementsController = TextEditingController();
  TextEditingController mistakesController = TextEditingController();
  TextEditingController reasonsToChangeController = TextEditingController();
  List<DropdownMenuItem<int>> personsItems = [];
  List<DropdownMenuItem<int>> branchItems = [];
  List<DropdownMenuItem<int>> toJobPositionItems = [];
  List<Staff> freeStaffs = [];
  int fromStaffId = 1;
  int toStaffId = 1;
  int personId = 1;
  int staffId = 1;
  int branchId = 1;
  int toJobPositionId = 1;
}

class AddShiftViewModel extends ChangeNotifier {
  final _shiftsService = ShiftsService();
  final _authService = AuthService();

  final data = ShiftAddData();

  AddShiftViewModel();

  Future<void> loadShift(BuildContext context) async {
    try {
      final branches = await _shiftsService.getBranches();
      data.branchId = branches.result.branches[0].id;
      data.branchItems = branches.result.branches
          .map((Branch branch) =>
          DropdownMenuItem<int>(
            child: Text(branch.name!),
            value: branch.id,
          ))
          .toList();
      final results = await Future.wait([
        _shiftsService.getStaffs(isPaginated: true, stateId: 31),
        _shiftsService.getFreeStaffs(branchId: data.branchId),
      ]);
      updateData(results);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(final results) {
    data.isInitializing = results == null;
    if (results == null) {
      notifyListeners();
      return;
    }
    final Staffs staffs = results[0];
    data.personId = staffs.result.staffs[0].id;
    data.fromStaffId = staffs.result.staffs[0].id;
    data.personsItems = staffs.result.staffs
        .map((Staff staff) =>
        DropdownMenuItem<int>(
          child: Text(staff.fullName!),
          value: staff.id,
        ))
        .toList();
    final Staffs freeStaffs = results[1];
    data.freeStaffs = freeStaffs.result.staffs;
    data.staffId = freeStaffs.result.staffs[0].id;
    data.toStaffId = freeStaffs.result.staffs[0].id;
    // data.toJobPositionId = JobPosition
    //     .fromJson(
    //     freeStaffs.result.staffs[0].jobPosition! as Map<String, dynamic>)
    //     .id;
    data.toJobPositionItems = freeStaffs.result.staffs
        .map((Staff staff) =>
        DropdownMenuItem<int>(
          child: Text(getStringAsync(LANG) == 'ru'
              ? JobPosition
              .fromJson(
              staff.jobPosition! as Map<String, dynamic>)
              .nameRu!
              : JobPosition
              .fromJson(
              staff.jobPosition! as Map<String, dynamic>)
              .nameUz!),
          value: staff.id,
        ))
        .toList();
    notifyListeners();
  }

  void _handleApiClientException(ApiClientException exception,
      BuildContext context,) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        throw UnimplementedError(exception.type.name);
    }
  }

  void setPerson(dynamic value) async {
    if (value == data.personId) {
      return;
    }
    data.personId = value;
    data.fromStaffId = value;
    notifyListeners();
  }

  void setBranch(dynamic value) async {
    if (value == data.branchId) {
      return;
    }
    data.branchId = value;
    notifyListeners();
    final results = await Future.wait([
      _shiftsService.getFreeStaffs(branchId: data.branchId),
    ]);
    updateFreeStaffs(results);
    //notifyListeners();
  }

  updateFreeStaffs(final results) async {
    final Staffs staffs = results[0];
    if (staffs.result.staffs.isNotEmpty) {
      // data.toJobPositionId = (JobPosition.fromJson(
      //     staffs.result.staffs[0].jobPosition as Map<String, dynamic>))
      //     .id;
      data.toStaffId = staffs.result.staffs[0].id;
      data.toJobPositionItems = staffs.result.staffs
          .map((Staff staff) =>
          DropdownMenuItem<int>(
            child: Text(JobPosition
                .fromJson(
                staff.jobPosition as Map<String, dynamic>)
                .nameRu!),
            value: staff.id,
          ))
          .toList();
      notifyListeners();
    }
  }

  void setFreeStaff(dynamic value) {
    if (value == data.toJobPositionId) {
      return;
    }
    print(value);
    data.toStaffId = value;
    notifyListeners();
  }

  Future<void> addShift(BuildContext context) async {
    if (data.achievementsController.text.isNotEmpty &&
        data.experienceController.text.isNotEmpty &&
        data.mistakesController.text.isNotEmpty &&
        data.reasonsToChangeController.text.isNotEmpty) {
      data.isLoading = true;
      notifyListeners();
      await _shiftsService
          .addShift(
        fromStaffId: data.fromStaffId,
        toStaffId: data.toStaffId,
        toBranchId: data.branchId,
        experience: data.experienceController.text,
        achievements: data.achievementsController.text,
        mistakes: data.mistakesController.text,
        goal: data.reasonsToChangeController.text,
      )
          .whenComplete(() {
        Navigator.pop(context, true);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Заполните все поля",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
