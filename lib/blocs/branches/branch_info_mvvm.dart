import 'package:flutter/material.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/director_rec_kadr_regman/director.dart';
import 'package:hrms/data/models/region_district/district.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/branches_service.dart';
import 'package:hrms/navigation/main_navigation.dart';

class BranchInfoData {
  bool isInitializing = true;
  Branch branch = Branch(
    id: 1,
    address: '',
    createdAt: DateTime.now(),
    name: '',
    nameUz: '',
    nameRu: '',
    region: District(id: 1, name: '', nameUz: '', nameRu: ''),
    district: District(id: 1, name: '', nameUz: '', nameRu: ''),
    landmark: '',
    shopCategory: '',
    slug: '',
    director: Director(id: 1, fullName: ''),
    recruiter: Director(id: 1, fullName: ''),
    kadr: Director(id: 1, fullName: ''),
    regionalManager: Director(id: 1, fullName: ''),
  );
}

class BranchInfoViewModel extends ChangeNotifier {
  final _branchService = BranchesService();
  final _authService = AuthService();

  final data = BranchInfoData();

  final int branchId;

  BranchInfoViewModel({required this.branchId});

  Future<void> loadBranch(BuildContext context) async {
    try {
      final branch = await _branchService.getBranch(branchId);
      updateData(branch);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(Branch? branch) {
    data.isInitializing = branch == null;
    if (branch == null) {
      notifyListeners();
      return;
    }
    data.branch = branch;
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
        throw UnimplementedError();
    }
  }
}
