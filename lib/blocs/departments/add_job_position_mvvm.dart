import 'package:flutter/material.dart';
import 'package:hrms/data/models/departments/department.dart';
import 'package:hrms/data/models/departments/departments.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/departments_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:nb_utils/nb_utils.dart';

class JobPositionAddData {
  bool isInitializing = true;
  bool isLoading = false;
  TextEditingController jobPositionNameUz = TextEditingController();
  TextEditingController jobPositionNameRu = TextEditingController();
  int departmentId = 1;
  List<DropdownMenuItem<int>> dropdownMenuItems = [];
}

class AddJobPositionViewModel extends ChangeNotifier {
  final _departmentsService = DepartmentsService();
  final _authService = AuthService();

  final data = JobPositionAddData();

  AddJobPositionViewModel();

  Future<void> load(BuildContext context) async {
    try {
      final departments = await _departmentsService.getDepartments();
      updateData(departments);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(Departments? departments) {
    data.isInitializing = (departments == null);
    if (departments == null) {
      notifyListeners();
      return;
    }


    if (departments.result.departments.isNotEmpty) {
      data.departmentId = departments.result.departments[0].id;
      data.dropdownMenuItems = departments.result.departments
          .map((Department department) => DropdownMenuItem<int>(
        child: Text(department.name),
        value: department.id,
      ))
          .toList();
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
        throw UnimplementedError(exception.type.toString());
    }
  }

  void setDepartment(dynamic value) {
    if (value == data.departmentId) {
      return;
    }
    data.departmentId = value;
    notifyListeners();
  }

  Future<void> addJobPosition(BuildContext context) async {
    if (data.jobPositionNameUz.text != '' &&
        data.jobPositionNameRu.text != '') {
      data.isLoading = true;
      notifyListeners();
      await _departmentsService
          .addJobPosition(
        nameUz: data.jobPositionNameUz.text,
        nameRu: data.jobPositionNameRu.text,
        departmentId: data.departmentId,
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
