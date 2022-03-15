import 'package:flutter/material.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/candidates_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:nb_utils/nb_utils.dart';

class CandidateEditData {
  bool isInitializing = true;
  bool isLoading = false;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController fatherName = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  List<DropdownMenuItem<int>> jobPositionItems = [];
  List<DropdownMenuItem<int>> branchesItems = [];
  int jobPositionId = 1;
  int branchId = 1;
}

class EditCandidateViewModel extends ChangeNotifier {
  final _candidatesService = CandidatesService();
  final _authService = AuthService();

  final int candidateId;

  final data = CandidateEditData();

  EditCandidateViewModel({required this.candidateId});

  Future<void> loadCandidate(BuildContext context) async {
    try {
      await _candidatesService.getCandidate(candidateId).then((value) => {
            data.firstName.text = value.firstName,
            data.lastName.text = value.lastName,
            data.fatherName.text = value.fatherName,
            data.dateOfBirth
                .text = "${value.dateOfBirth!.year.toString().padLeft(2, '0')}"
                    "-${value.dateOfBirth!.month.toString().padLeft(2, '0')}"
                    "-${value.dateOfBirth!.day.toString().padLeft(2, '0')}"
                .split(' ')[0],
            data.jobPositionId = value.jobPosition.id,
            data.branchId = value.branch.id,
          });

      final results = await Future.wait([
        _candidatesService.getBranches(isPaginated: true),
        _candidatesService.getJobPositions(),
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
    final List<JobPosition> jobPositions = results[1];
    final Branches branches = results[0];
    if (jobPositions.isNotEmpty) {
      data.jobPositionItems = jobPositions
          .map((JobPosition jobPosition) => DropdownMenuItem<int>(
                child: Text(jobPosition.name!),
                value: jobPosition.id,
              ))
          .toList();
    }
    if (branches.result.branches.isNotEmpty) {
      data.branchesItems = branches.result.branches
          .map((Branch branch) => DropdownMenuItem<int>(
                child: Text(branch.name!),
                value: branch.id,
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

  void setJobPosition(dynamic value) {
    if (value == data.jobPositionId) {
      return;
    }
    data.jobPositionId = value;
    notifyListeners();
  }

  Future<void> updateCandidate(BuildContext context) async {
    if (data.firstName.text.isNotEmpty &&
        data.lastName.text.isNotEmpty &&
        data.fatherName.text.isNotEmpty &&
        data.dateOfBirth.text.isNotEmpty) {
      data.isLoading = true;
      notifyListeners();
      await _candidatesService
          .updateCandidate(
        candidateId: candidateId,
        firstName: data.firstName.text,
        lastName: data.lastName.text,
        fatherName: data.fatherName.text,
        dateOfBirth: data.dateOfBirth.text,
        jobPositionId: data.jobPositionId,
        branchId: data.branchId,
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
