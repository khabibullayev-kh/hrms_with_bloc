import 'package:flutter/material.dart';
import 'package:hrms/blocs/departments/delete_job_position_mvvm.dart';
import 'package:hrms/data/models/job_positions/job_position.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/departments_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/ui/widgets/delete_widget.dart';
import 'package:hrms/ui/widgets/reusable_actions_widget.dart';
import 'package:hrms/ui/widgets/reusable_bottom_sheet.dart';
import 'package:provider/provider.dart';

class JobPositionsData {
  bool isLoading = true;
  List<DataRow> jobPositionsDataRow = [];
}

class JobPositionsViewModel extends ChangeNotifier {
  final _departmentsService = DepartmentsService();
  final _authService = AuthService();

  final data = JobPositionsData();

  final int id;

  JobPositionsViewModel({required this.id});

  Future<void> getJobPositions(BuildContext context) async {
    try {
      data.isLoading = true;
      notifyListeners();
      final jobPositions = await _departmentsService.getJobPositions(id);
      updatePage(jobPositions, context);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  pushToAddPositionScreen(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addJobPositionScreen,
    );
    if (result == true) {
      getJobPositions(context);
    }
  }

  void updatePage(List<JobPosition>? jobPositions, BuildContext context) {
    if (jobPositions == null) {
      return;
    }
    data.jobPositionsDataRow = makeRow(jobPositions, context);
    notifyListeners();
  }

  makeRow(List<JobPosition>? jobPositions, BuildContext context) {
    List<DataRow> positionRow = [];
    for (JobPosition item in jobPositions!) {
      positionRow.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text('${item.id}')),
            DataCell(
              Text(item.nameRu!),
            ),
            DataCell(
              ActionsWidget(
                id: item.id,
                onEditPressed: () async {
                  final result = await Navigator.of(context).pushNamed(
                      MainNavigationRouteNames.editJobPositionScreen,
                      arguments: JobPositionsArguments(item.id, id));
                  if (result == true) {
                    getJobPositions(context);
                    notifyListeners();
                  }
                },
                onDeletePressed: () async {

                    await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useRootNavigator: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (context) {
                      return ChangeNotifierProvider(
                        create: (_) =>
                            DeleteJobPositionViewModel(jobPosition: item.id),
                        child: DeleteUserWidget(id: item.id),
                      );
                    },
                  ).whenComplete(() => getJobPositions(context));
                },
              ),
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

class JobPositionsArguments {
  final int jobPositionId;
  final int departmentId;

  JobPositionsArguments(this.jobPositionId, this.departmentId);
}

class DeleteUserWidget extends StatelessWidget {
  const DeleteUserWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DeleteJobPositionViewModel>();
    return ReusableBottomSheet(
      children: DeleteWidget(
        deleteText: 'Удалить должность №$id?',
        isLoading: model.data.isLoading,
        onTapDelete: () =>
            model.data.isLoading ? null : model.deleteJobPosition(id, context),
      ),
    );
  }
}
