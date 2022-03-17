import 'package:flutter/material.dart';
import 'package:hrms/data/models/educations/education.dart';
import 'package:hrms/data/models/region_district/district.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/persons_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:hrms/translations/locale_keys.g.dart';

class PersonAddData {
  bool isInitializing = true;
  bool isLoading = false;
  DateTime? selectedDateOfBirth;
  DateTime? selectedDateOfAccept;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController fathersName = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController dateOfEndUniversity = TextEditingController();
  List<DropdownMenuItem<String?>> sexItem =
  sexEnums.values.map((sexEnums classType) {
    return DropdownMenuItem<String?>(
      value: classType.convertToString == LocaleKeys.man.tr() ? 'male' : 'female',
      child: Text(classType.convertToString),
    );
  }).toList();
  List<DropdownMenuItem<int>> regionsItems = [];
  List<DropdownMenuItem<int>> districtItems = [];
  List<DropdownMenuItem<int>> educationItems = [];
  TextEditingController passportSeries = TextEditingController();
  TextEditingController passportNumber = TextEditingController();
  TextEditingController specialization = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController additionalPhoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController acceptedDate = TextEditingController();
  TextEditingController voucherId = TextEditingController();
  TextEditingController salary = TextEditingController();
  int regionId = 1;
  int districtId = 1;
  int educationId = 1;
  String sex = 'male';
}

class AddPersonsViewModel extends ChangeNotifier {
  final _personsService = PersonsService();
  final _authService = AuthService();

  final data = PersonAddData();

  AddPersonsViewModel();

  Future<void> loadData(BuildContext context) async {
    try {
      final results = await Future.wait([
        _personsService.getRegions(),
        _personsService.getDistricts(1),
        _personsService.getEducations(),
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
    final List<District> regions = results[0];
    final List<District> districts = results[1];
    final List<Education> educations = results[2];
    if (regions.isNotEmpty) {
      data.regionsItems = regions
          .map((District district) => DropdownMenuItem<int>(
        child: Text(district.name!),
        value: district.id,
      ))
          .toList();
      data.regionId = regions[0].id;
    }
    if (districts.isNotEmpty) {
      data.districtItems = districts
          .map((District district) => DropdownMenuItem<int>(
        child: Text(district.name!),
        value: district.id,
      ))
          .toList();
      data.districtId = districts[0].id;
    }
    if (educations.isNotEmpty) {
      data.educationItems = educations
          .map((Education education) => DropdownMenuItem<int>(
        child: Text(education.name),
        value: education.id,
      ))
          .toList();
      data.educationId = educations[0].id;
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

  void setSex(dynamic value) {
    if (value == data.sex) {
      return;
    }
    data.sex = value;
    notifyListeners();
  }

  void setRegion(dynamic value) async {
    if (value == data.regionId) {
      return;
    }
    data.regionId = value;
    notifyListeners();
    final results = await Future.wait([
      _personsService.getDistricts(data.regionId),
    ]);
    updateDistrict(results);
    //notifyListeners();
  }

  updateDistrict(final results) async {
    final List<District> districts = results[0];
    if (districts.isNotEmpty) {
      data.districtId = districts[0].id;
      data.districtItems = districts
          .map((District district) => DropdownMenuItem<int>(
        child: Text(district.name!),
        value: district.id,
      ))
          .toList();
      notifyListeners();
    }
  }

  void setDistrict(dynamic value) {
    if (value == data.districtId) {
      return;
    }
    data.districtId = value;
    notifyListeners();
  }

  void setEducation(dynamic value) {
    if (value == data.educationId) {
      return;
    }
    data.educationId = value;
    notifyListeners();
  }

  bool validate() {
    return data.firstName.text.isNotEmpty &&
        data.lastName.text.isNotEmpty &&
        data.fathersName.text.isNotEmpty &&
        data.dateOfBirth.text.isNotEmpty &&
        data.phoneNumber.text.isNotEmpty &&
        data.dateOfEndUniversity.text.isNotEmpty &&
        data.address.text.isNotEmpty &&
        data.acceptedDate.text.isNotEmpty;
  }

  Future<void> addPerson(BuildContext context) async {
    if (validate()) {
      data.isLoading = true;
      notifyListeners();
      await _personsService
          .addPerson(
        firstName: data.firstName.text,
        lastName: data.lastName.text,
        fathersName: data.fathersName.text,
        dateOfBirth: data.dateOfBirth.text,
        sex: data.sex,
        speciality: data.specialization.text,
        address: data.address.text,
        phone: data.phoneNumber.text,
        additionalPhone: data.additionalPhoneNumber.text,
        educationId: data.educationId,
        passportSeries: data.passportSeries.text,
        passportNumber: data.passportNumber.text,
        periodOfStudy: data.dateOfEndUniversity.text,
        regionId: data.regionId,
        districtId: data.districtId,
        voucherId: data.voucherId.text,
        confirmedDate: data.acceptedDate.text,
        salary: data.salary.text,
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

  selectDate({
    required BuildContext? context,
    DateTime? selectedDateTime,
    required TextEditingController dateTimeController,
  }) async {
    final DateTime? picked = await showDatePicker(
        context: context!,
        initialDate: DateTime(selectedDateTime?.year ?? 2010,
            selectedDateTime?.month ?? 1, selectedDateTime?.day ?? 1),
        firstDate: DateTime(1960),
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
    if (picked != null && picked != selectedDateTime) {
      selectedDateTime = picked;
      dateTimeController
          .text = "${selectedDateTime.year.toString().padLeft(2, '0')}"
          "-${selectedDateTime.month.toString().padLeft(2, '0')}"
          "-${selectedDateTime.day.toString().padLeft(2, '0')}"
          .split(' ')[0];
      notifyListeners();
    }
  }

  clearDate(TextEditingController dateTimeController) {
    dateTimeController.clear();
    notifyListeners();
  }
}
