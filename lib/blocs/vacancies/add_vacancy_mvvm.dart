import 'package:flutter/material.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/departments/department.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/vacancies_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:nb_utils/nb_utils.dart';

class VacancyAddData {
  bool isInitializing = true;
  bool isLoading = false;
  TextEditingController mentor = TextEditingController(text: 'Mentor');
  TextEditingController requirements = TextEditingController(text: 'Talablar');
  TextEditingController description = TextEditingController(text: 'Tavsif');
  TextEditingController salary = TextEditingController(text: 'Oylik');
  TextEditingController bonus = TextEditingController(text: 'Bonus');
  TextEditingController date = TextEditingController();
  DateTime selectedDate = DateTime.now().add(const Duration(days: 3));
  TextEditingController quantity = TextEditingController(text: '0');
  List<DropdownMenuItem<int>> importance =
      importanceEnums.values.map((importanceEnums classType) {
    return DropdownMenuItem<int>(
      value: classType.convertToInt,
      child: Text(classType.convertToString),
    );
  }).toList();
  List<DropdownMenuItem<int>> departmentItems = [];
  List<DropdownMenuItem<int>> jobPositionItems = [];
  List<DropdownMenuItem<int>> branchesItems = [];
  int importanceId = 1;
  int departmentId = 1;
  int jobPositionId = 1;
  int branchesId = 1;
}

class AddVacancyViewModel extends ChangeNotifier {
  final _vacanciesService = VacanciesService();
  final _authService = AuthService();

  final data = VacancyAddData();

  AddVacancyViewModel();

  Future<void> load(BuildContext context) async {
    try {
      final results = await Future.wait([
        _vacanciesService.getBranches(),
        _vacanciesService.getDepartments().then((value) async {
          data.departmentId = value.result.departments[0].id;
          data.departmentItems = value.result.departments
              .map((Department department) => DropdownMenuItem<int>(
            child: Text(department.name),
            value: department.id,
          ))
              .toList();
          await _vacanciesService
              .getJobPositions(data.departmentId)
              .then((value) {
            data.jobPositionItems = value
                .map((JobPosition jobPosition) => DropdownMenuItem<int>(
                      child: Text(getStringAsync(LANG) == 'ru' ? jobPosition.nameRu! : jobPosition.nameUz!),
                      value: jobPosition.id,
                    ))
                .toList();
            data.jobPositionId = value[0].id;
          });
        }),
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
    final Branches branches = results[0];
    if (branches.result.branches.isNotEmpty) {
      data.branchesItems = branches.result.branches
          .map((Branch branch) => DropdownMenuItem<int>(
                child: Text(branch.name!),
                value: branch.id,
              ))
          .toList();
      data.branchesId = branches.result.branches[0].id;
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

  void setImportance(dynamic value) {
    if (value == data.importanceId) {
      return;
    }
    data.importanceId = value;
    notifyListeners();
  }

  void setBranch(dynamic value) {
    if (value == data.branchesId) {
      return;
    }
    data.branchesId = value;
    notifyListeners();
  }

  void setDepartment(dynamic value) async {
    if (value == data.departmentId) {
      return;
    }
    data.departmentId = value;
    notifyListeners();
    final results = await Future.wait([
      _vacanciesService.getJobPositions(data.departmentId),
    ]);
    updateJobPositions(results);
  }

  updateJobPositions(final results) async {
    final List<JobPosition> jobPosition = results[0];
    if (jobPosition.isNotEmpty) {
      data.jobPositionId = jobPosition[0].id;
      data.jobPositionItems = jobPosition
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

  Future<void> addVacancy(BuildContext context) async {
    if (data.mentor.text.isNotEmpty &&
        data.bonus.text.isNotEmpty &&
        data.description.text.isNotEmpty &&
        data.requirements.text.isNotEmpty &&
        data.date.text.isNotEmpty &&
        data.quantity.text.isNotEmpty &&
        data.salary.text.isNotEmpty) {
      data.isLoading = true;
      notifyListeners();
      await _vacanciesService
          .addVacancy(
        branchId: data.branchesId,
        jobPositionsId: data.jobPositionId,
        departmentId: data.departmentId,
        stateId: 6,
        importanceId: data.importanceId,
        expectedAt: data.date.text,
        mentor: data.mentor.text,
        requirements: data.requirements.text,
        description: data.description.text,
        salary: data.salary.text,
        bonus: data.bonus.text,
        quantity: data.quantity.text,
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
        initialDate: DateTime.now().add(const Duration(days: 14)),
        firstDate: DateTime.now().add(const Duration(days: 14)),
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
    if (picked != null && picked != data.selectedDate) {
      data.selectedDate = picked;
      data.date.text = "${data.selectedDate.day.toString().padLeft(2, '0')}"
              ".${data.selectedDate.month.toString().padLeft(2, '0')}"
              ".${data.selectedDate.year.toString().padLeft(2, '0')}"
          .split(' ')[0];
      notifyListeners();
    }
  }

  clearDate() {
    data.date.clear();
    notifyListeners();
  }
}
