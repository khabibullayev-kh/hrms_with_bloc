import 'package:flutter/material.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/director_rec_kadr_regman/director.dart';
import 'package:hrms/data/models/statistice/statistics.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/statistics_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class VacanciesStatsData {
  bool isInitializing = true;
  bool isLoading = false;
  List<Statistics> statistics = [];
  List<DropdownMenuItem<int?>> branchesItems = [];
  List<DropdownMenuItem<int?>> recruitersItems = [];
  int? branchId;
  int? recruiterId;
}

class VacanciesStatsViewModel extends ChangeNotifier {
  final _statisticsService = StatisticsService();
  final _authService = AuthService();

  final data = VacanciesStatsData();

  VacanciesStatsViewModel();

  Future<void> load(BuildContext context) async {
    try {
      final results = await Future.wait([
        _statisticsService.getStatistics(tableName: VACANCIES_TABLE_NAME),
        _statisticsService.getBranches(),
        _statisticsService.getRecruiters(),
      ]);
      updateData(results);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  CircularSeries getCircularSeries(){
    return DoughnutSeries<Statistics, String>(
      explode: true,
      dataSource: data.statistics,
      xValueMapper: (Statistics data, _) => data.name,
      yValueMapper: (Statistics data, _) => int.parse(data.value.toString()),

      dataLabelSettings:
      const DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside, useSeriesColor: true),
      enableTooltip: true,
    );
  }

  void updateData(final results) {
    data.isInitializing = results == null;
    if (results == null) {
      notifyListeners();
      return;
    }
    final List<Statistics> statistics = results[0];
    data.statistics = statistics;
    final Branches branches = results[1];
    const nullItem = DropdownMenuItem<int?>(
      child: Text('Все'),
      value: null,
    );
    data.branchesItems.add(nullItem);
    data.recruitersItems.add(nullItem);
    if (branches.result.branches.isNotEmpty) {
      data.branchesItems.addAll(branches.result.branches
          .map((Branch branch) => DropdownMenuItem<int>(
        child: Text(branch.name!),
        value: branch.id,
      ))
          .toList());
    }
    final List<Director> recruiters = results[2];
    if (recruiters.isNotEmpty) {
      data.recruitersItems.addAll(recruiters
          .map((Director director) => DropdownMenuItem<int>(
        child: Text(director.fullName),
        value: director.id,
      ))
          .toList());
    }
    notifyListeners();
  }

  void getStatistics() async {
    data.isLoading = true;
    notifyListeners();
    data.statistics = await _statisticsService.getStatistics(
      tableName: VACANCIES_TABLE_NAME,
      branchId: data.branchId,
    );
    data.isLoading = false;
    notifyListeners();
  }

  void setRecruiter(dynamic value) {
    if (data.recruiterId == value) {
      return;
    }
    data.recruiterId = value;
    notifyListeners();
  }

  void setBranch(dynamic value) {
    if (data.branchId == value) {
      return;
    }
    data.branchId = value;
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
}
