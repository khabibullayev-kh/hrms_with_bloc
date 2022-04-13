import 'package:flutter/cupertino.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/models/director_rec_kadr_regman/director.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/data/models/region_district/district.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/candidates_service.dart';
import 'package:hrms/navigation/main_navigation.dart';

class CandidateInfoData {
  bool isInitializing = true;
  Candidate candidate = Candidate(
    id: 1,
    firstName: '',
    lastName: '',
    fatherName: '',
    photoUrl: '',
    jobPosition: JobPosition(id: 1, slug: '', nameUz: '', nameRu: ''),
    canChangeState: false,
    branch: Branch(
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
        recruiters: [Director(id: 1, fullName: '')],
        kadrs: [Director(id: 1, fullName: '')],
        regionalManager: Director(id: 1, fullName: '')),
    region: District(id: 1, name: '', nameUz: '', nameRu: ''),
    createdAt: DateTime.now(),
  );
}

class CandidateInfoViewModel extends ChangeNotifier {
  final _candidatesService = CandidatesService();
  final _authService = AuthService();

  final data = CandidateInfoData();

  final int candidateId;

  CandidateInfoViewModel({required this.candidateId});

  Future<void> loadCandidateInfo(BuildContext context) async {
    try {
      final branch = await _candidatesService.getCandidate(candidateId);
      updateData(branch);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(Candidate? candidate) {
    data.isInitializing = candidate == null;
    if (candidate == null) {
      notifyListeners();
      return;
    }
    data.candidate = candidate;
    data.isInitializing = false;
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
