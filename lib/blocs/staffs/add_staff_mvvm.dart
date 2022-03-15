import 'package:flutter/material.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/departments/department.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/data/models/persons/person.dart';
import 'package:hrms/data/models/persons/persons.dart';
import 'package:hrms/data/models/states/state.dart' as status;
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/staffs_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:nb_utils/nb_utils.dart';

class StaffAddData {
  bool isInitializing = true;
  bool isLoading = false;
  DateTime selectedDateTime = DateTime.now();
  TextEditingController fioController = TextEditingController();
  TextEditingController confirmedDateController = TextEditingController();
  List<Person> persons = [];
  List<DropdownMenuItem<int>> branchItems = [];
  List<DropdownMenuItem<int>> departmentsItems = [];
  List<DropdownMenuItem<int>> jobPositionsItems = [];
  List<DropdownMenuItem<int>> stateItems = [];
  int? personId;
  int branchId = 1;
  int departmentId = 1;
  int jobPositionId = 1;
  int stateId = 1;
}

class AddStaffViewModel extends ChangeNotifier {
  final _staffsService = StaffsService();
  final _authService = AuthService();

  final data = StaffAddData();

  AddStaffViewModel();

  Future<void> load(BuildContext context) async {
    try {
      final results = await Future.wait([
        _staffsService.getPersons(),
        _staffsService.getBranches(),
        _staffsService.getDepartments().then((value) async {
          data.departmentId = value.result.departments[0].id;
          data.departmentsItems = value.result.departments
              .map((Department department) => DropdownMenuItem(
                    child: Text(department.name),
                    value: department.id,
                  ))
              .toList();
          await _staffsService.getJobPositions(data.departmentId).then((value) {
            data.jobPositionId = value[0].id;
            data.jobPositionsItems = value
                .map((JobPosition jobPosition) => DropdownMenuItem(
                      child: Text(jobPosition.nameRu!),
                      value: jobPosition.id,
                    ))
                .toList();
          });
        }),
        _staffsService.getStates(),
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
    final Persons persons = results[0];
    data.persons.add(Person(id: null, fullName: 'Вакант'));
    data.persons.addAll(persons.result.persons);
    final List<status.State> states = results[3];
    if (states.isNotEmpty) {
      data.stateId = states[0].id;
      data.stateItems = states
          .map((status.State status) => DropdownMenuItem<int>(
                child: Text(status.name!),
                value: status.id,
              ))
          .toList();
    }
    //data.staffs.add(Staff(id: 1, person: null,));
    final Branches branches = results[1];
    if (branches.result.branches.isNotEmpty) {
      data.branchItems = branches.result.branches
          .map((Branch branch) => DropdownMenuItem<int>(
                child: Text(branch.name!),
                value: branch.id,
              ))
          .toList();
      data.branchId = branches.result.branches[0].id;
    }
    notifyListeners();
  }

  void _handleApiClientException(
    ApiClientException exception,
    BuildContext context,
  ) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        throw UnimplementedError(exception.type.name);
    }
  }

  void setBranch(dynamic value) {
    if (value == data.branchId) {
      return;
    }
    data.branchId = value;
    notifyListeners();
  }

  void setDepartment(dynamic value) async {
    if (value == data.departmentId) {
      return;
    }
    data.departmentId = value;
    notifyListeners();
    final results = await Future.wait([
      _staffsService.getJobPositions(data.departmentId),
    ]);
    updateDistrict(results);
  }

  updateDistrict(final results) async {
    final List<JobPosition> jobPositions = results[0];
    if (jobPositions.isNotEmpty) {
      data.jobPositionId = jobPositions[0].id;
      data.jobPositionsItems = jobPositions
          .map((JobPosition jobPosition) => DropdownMenuItem<int>(
                child: Text(jobPosition.nameRu!),
                value: jobPosition.id,
              ))
          .toList();
      notifyListeners();
    }
  }

  void setJobPosition(dynamic value) {
    if (value == data.jobPositionId) {
      return;
    }
    data.jobPositionId = value;
    notifyListeners();
  }

  void setStatus(dynamic value) {
    if (value == data.stateId) {
      return;
    }
    data.stateId = value;
    notifyListeners();
  }

  Future<void> addStaff(BuildContext context) async {
    if (data.confirmedDateController.text.isNotEmpty) {
      data.isLoading = true;
      notifyListeners();
      await _staffsService
          .addStaff(
        personId: data.personId,
        branchId: data.branchId,
        jobPositionId: data.jobPositionId,
        departmentId: data.departmentId,
        stateId: data.stateId,
        confirmedDate: data.confirmedDateController.text,
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

  selectDate({required BuildContext? context}) async {
    final DateTime? picked = await showDatePicker(
        context: context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime.now().add(const Duration(days: 1000)),
        initialDatePickerMode: DatePickerMode.day,
        helpText: 'Выберите дату',
        cancelText: 'Отменить',
        confirmText: 'Ок',
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: HRMSColors.green,
              colorScheme: const ColorScheme.light(primary: HRMSColors.green),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        });
    if (picked != null && picked != data.selectedDateTime) {
      data.selectedDateTime = picked;
      data.confirmedDateController.text =
          "${data.selectedDateTime.year.toString().padLeft(2, '0')}"
                  "-${data.selectedDateTime.month.toString().padLeft(2, '0')}"
                  "-${data.selectedDateTime.day.toString().padLeft(2, '0')}"
              .split(' ')[0];
      notifyListeners();
    }
  }

  clearDate() {
    data.confirmedDateController.clear();
    notifyListeners();
  }
}
