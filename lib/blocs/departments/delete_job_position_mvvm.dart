import 'package:flutter/material.dart';
import 'package:hrms/domain/services/departments_service.dart';

class JobPositionDeleteData {
  bool isLoading = false;
}

class DeleteJobPositionViewModel extends ChangeNotifier {
  final _departmentsService = DepartmentsService();

  final data = JobPositionDeleteData();

  final int jobPosition;

  DeleteJobPositionViewModel({required this.jobPosition});

  Future<void> deleteJobPosition(int jobPosition, BuildContext context) async {
    data.isLoading = true;
    notifyListeners();
    await _departmentsService.deleteJobPosition(jobPosition).whenComplete(() => {
      Navigator.pop(context, true),
    });
  }
}
