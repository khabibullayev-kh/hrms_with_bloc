import 'package:flutter/material.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/data/models/director_rec_kadr_regman/director.dart';
import 'package:hrms/data/models/statistice/statistics.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/statistics_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandidatesStatsData {
  bool isInitializing = true;
  bool isLoading = false;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  List<Statistics> statistics = [];
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  List<DropdownMenuItem<int?>> recruiterItems = [];
  List<DropdownMenuItem<int?>> branchesItems = [];
  int? recruiterId;
  int? branchId;
}

class CandidatesStatsViewModel extends ChangeNotifier {
  final _statisticsService = StatisticsService();
  final _authService = AuthService();

  final data = CandidatesStatsData();

  CandidatesStatsViewModel();

  Future<void> load(BuildContext context) async {
    try {
      final results = await Future.wait([
        _statisticsService.getStatistics(tableName: CANDIDATES_TABLE_NAME),
        _statisticsService.getBranches(),
        _statisticsService.getRecruiters(),
      ]);
      updateData(results);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  FunnelSeries<Statistics, String> getFunnelSeries() {
    final reversedData = data.statistics.reversed.toList();
    return FunnelSeries<Statistics, String>(
      neckHeight: '50%',
      neckWidth: '35%',
      explode: false,
      dataSource: reversedData,
      textFieldMapper: (Statistics data, _) => '${data.label}:\n${data.value}',
      xValueMapper: (Statistics data, _) => '${data.label} - ${data.value}',
      yValueMapper: (Statistics data, _) => 1,
      dataLabelSettings: const DataLabelSettings(
        isVisible: true,
        labelPosition: ChartDataLabelPosition.inside,
        textStyle: TextStyle(color: Colors.black, fontSize: 10),
        angle: 0,
        useSeriesColor: false,
      ),
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
    data.recruiterItems.add(nullItem);
    data.branchesItems.add(nullItem);
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
      data.recruiterItems.addAll(recruiters
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
      tableName: CANDIDATES_TABLE_NAME,
      branchId: data.branchId,
      recruiterId: data.recruiterId,
      fromDate: data.fromDate.text,
      toDate: data.toDate.text,
    );
    data.isLoading = false;
    notifyListeners();
  }

  void setBranch(dynamic value) {
    if (data.branchId == value) {
      return;
    }
    data.branchId = value;
    notifyListeners();
  }

  void setRecruiter(dynamic value) {
    if (data.recruiterId == value) {
      return;
    }
    data.recruiterId = value;
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

  selectFromDate({required BuildContext? context}) async {
    final DateTime? picked = await showDatePicker(
        context: context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
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
    if (picked != null && picked != data.selectedFromDate) {
      data.selectedFromDate = picked;
      data.fromDate.text =
          "${data.selectedFromDate.day.toString().padLeft(2, '0')}"
                  ".${data.selectedFromDate.month.toString().padLeft(2, '0')}"
                  ".${data.selectedFromDate.year.toString().padLeft(2, '0')}"
              .split(' ')[0];
      notifyListeners();
    }
  }

  clearFromDate() {
    data.fromDate.clear();
    notifyListeners();
  }

  selectToDate({required BuildContext? context}) async {
    final DateTime? picked = await showDatePicker(
        context: context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
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
    if (picked != null && picked != data.selectedFromDate) {
      data.selectedToDate = picked;
      data.toDate.text = "${data.selectedToDate.day.toString().padLeft(2, '0')}"
              ".${data.selectedToDate.month.toString().padLeft(2, '0')}"
              ".${data.selectedToDate.year.toString().padLeft(2, '0')}"
          .split(' ')[0];
      notifyListeners();
    }
  }

  clearToDate() {
    data.toDate.clear();
    notifyListeners();
  }
}
