import 'package:flutter/material.dart';
import 'package:hrms/data/models/departments/department.dart';
import 'package:hrms/data/models/departments/departments.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/departments_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:nb_utils/nb_utils.dart';

class JobPositionEditData {
  bool isInitializing = true;
  bool isLoading = false;
  TextEditingController jobPositionNameUz = TextEditingController();
  TextEditingController jobPositionNameRu = TextEditingController();
  int departmentId = 1;
  List<DropdownMenuItem<int>> dropdownMenuItems = [];
}

class EditJobPositionViewModel extends ChangeNotifier {
  final _departmentsService = DepartmentsService();
  final _authService = AuthService();

  final int jobPositionsId;
  final int departmentId;

  final data = JobPositionEditData();

  EditJobPositionViewModel(this.jobPositionsId, this.departmentId);

  Future<void> load(BuildContext context) async {
    try {
      final user = await _departmentsService.getJobPosition(jobPositionsId);
      final roles = await _departmentsService.getDepartments();
      updateData(user, roles);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(JobPosition? jobPosition, Departments? departments) {
    data.isInitializing = (jobPosition == null && departments == null);
    if (jobPosition == null || departments == null) {
      notifyListeners();
      return;
    }
    data.jobPositionNameRu.text = jobPosition.nameRu!;
    data.jobPositionNameUz.text = jobPosition.nameUz!;
    data.departmentId = departmentId;


    if (departments.result.departments.isNotEmpty) {
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

  Future<void> updateJobPosition(BuildContext context) async {
    if (data.jobPositionNameUz.text != '' &&
        data.jobPositionNameRu.text != '') {
      data.isLoading = true;
      notifyListeners();
      await _departmentsService
          .updateJobPosition(
        id: jobPositionsId,
        slug: data.jobPositionNameUz.text,
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
