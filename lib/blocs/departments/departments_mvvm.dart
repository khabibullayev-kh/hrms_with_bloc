import 'package:flutter/material.dart';
import 'package:hrms/data/models/departments/department.dart';
import 'package:hrms/data/models/departments/departments.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/departments_service.dart';
import 'package:hrms/navigation/main_navigation.dart';

class DepartmentsData {
  bool isLoading = true;
  List<DataRow> departmentsDataRow = [];
}

class DepartmentsViewModel extends ChangeNotifier {
  final _departmentsService = DepartmentsService();
  final _authService = AuthService();

  final data = DepartmentsData();

  Future<void> getDepartments(BuildContext context) async {
    try {
      final departments = await _departmentsService.getDepartments();
      updatePage(departments, context);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updatePage(Departments? departments, BuildContext context) {
    if (departments == null) {
      return;
    }
    data.departmentsDataRow = makeRow(departments, context);
    notifyListeners();
  }

  makeRow(Departments? departments, BuildContext context) {
    List<DataRow> positionRow = [];
    for (Department department in departments!.result.departments) {
      positionRow.add(
        DataRow(
          selected: false,
          onSelectChanged: (newValue) async {
            if (isCan('get-job-positions')) {
              Navigator.of(context)
                  .pushNamed(
                MainNavigationRouteNames.jobPositionsScreen,
                arguments: department.id,
              )
                  .then((value) {
                data.isLoading = true;
                notifyListeners();
                getDepartments(context);
              });
            }
          },
          cells: <DataCell>[
            DataCell(Text('${department.id}')),
            DataCell(
              Text(department.name),
            ),
            DataCell(
              Center(child: Text('${department.jobPositionsCount}')),
            ),
          ],
        ),
      );
    }
    data.isLoading = false;
    return positionRow;
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
}
