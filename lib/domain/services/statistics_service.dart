import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/director_rec_kadr_regman/director.dart';
import 'package:hrms/data/models/statistice/statistics.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/network/branches_api_client.dart';
import 'package:hrms/domain/network/statistics_api_client.dart';
import 'package:hrms/domain/network/user_management_api/user_api_client.dart';

class StatisticsService {
  final _statisticsApiClient = StatisticsApiClient();
  final _branchesApiClient = BranchesApiClient();
  final _usersApiClient = UsersApiClient();

  Future<List<Statistics>> getStatistics({
    required String tableName,
    int? branchId,
    int? recruiterId,
    String? fromDate,
    String? toDate,
  }) async {
    return _statisticsApiClient.getStatistics(
      tableName: tableName,
      branchId: branchId,
      recruiterId: recruiterId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<Branches> getBranches() async {
    return _branchesApiClient.getBranches(isPagination: true);
  }

  Future<List<Director>> getRecruiters() async {
    return _usersApiClient.getRoles(RECRUITER_ROLE_ID);
  }
}
