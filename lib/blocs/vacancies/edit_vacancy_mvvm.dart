import 'package:flutter/material.dart';
import 'package:hrms/data/models/states/state.dart' as status;
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/vacancies_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:nb_utils/nb_utils.dart';

class VacancyEditData {
  bool isInitializing = true;
  bool isLoading = false;
  TextEditingController mentor = TextEditingController(text: 'Mentor');
  TextEditingController requirements = TextEditingController(text: 'Talablar');
  TextEditingController description = TextEditingController(text: 'Tavsif');
  TextEditingController salary = TextEditingController(text: 'Oylik');
  TextEditingController bonus = TextEditingController(text: 'Bonus');
  TextEditingController date = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController jobPosition = TextEditingController();
  TextEditingController branch = TextEditingController();
  DateTime selectedDate = DateTime.now().add(const Duration(days: 3));
  TextEditingController quantity = TextEditingController(text: '0');
  List<DropdownMenuItem<int>> importance =
  importanceEnums.values.map((importanceEnums classType) {
    return DropdownMenuItem<int>(
      value: classType.convertToInt,
      child: Text(classType.convertToString),
    );
  }).toList();
  List<DropdownMenuItem<int>> stateItems = [];
  int stateId = 1;
  int branchId = 1;
  int jobPositionId = 1;
  int importanceId = 1;
}

class EditVacancyViewModel extends ChangeNotifier {
  final _vacanciesService = VacanciesService();
  final _authService = AuthService();

  final data = VacancyEditData();

  final int id;

  EditVacancyViewModel({required this.id});

  Future<void> load(BuildContext context) async {
    try {
      final results = await Future.wait([
        _vacanciesService.getVacancy(id).then((value) {
        data.stateId = value.state!.id;
        data.branchId = value.branch!.id;
        data.jobPositionId = value.jobPosition!.id;
        data.importanceId = int.parse(value.importance!);
        data.requirements.text = value.requirements!;
        data.description.text = value.description!;
        data.jobPosition.text = getStringAsync(LANG) == 'ru' ? '${value.jobPosition!.nameRu}' : '${value.jobPosition!.nameUz}';
        data.department.text = getStringAsync(LANG) == 'ru' ? '${value.department!.nameRu}' : '${value.department!.nameUz}';
        data.branch.text = getStringAsync(LANG) == 'ru' ? '${value.branch!.nameRu}' : '${value.branch!.nameUz}';
        data.bonus.text = value.bonus!;
        data.date.text = value.expectedAt!;
        data.quantity.text = value.quantity.toString();
      }),
        _vacanciesService.getStates(),

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
    final List<status.State> states = results[1];
    if (states.isNotEmpty) {
      data.stateItems =states
          .map((status.State status) => DropdownMenuItem<int>(
        child: Text(status.name!),
        value: status.id,
      ))
          .toList();}
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

  void setStatus(dynamic value) {
    if (value == data.stateId) {
      return;
    }
    data.stateId = value;
    notifyListeners();
  }

  Future<void> updateVacancy(BuildContext context) async {
    if (data.mentor.text.isNotEmpty &&
        data.bonus.text.isNotEmpty &&
        data.description.text.isNotEmpty &&
        data.requirements.text.isNotEmpty &&
        data.date.text.isNotEmpty &&
        data.quantity.text.isNotEmpty &&
        data.salary.text.isNotEmpty) {
      data.isLoading = true;
      notifyListeners();
      await _vacanciesService.updateVacancy(
        vacancyId: id,
        branchId: data.branchId,
        jobPositionsId: data.jobPositionId,
        stateId: data.stateId,
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
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
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
