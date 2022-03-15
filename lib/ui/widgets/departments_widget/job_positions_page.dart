import 'package:flutter/material.dart';
import 'package:hrms/blocs/departments/job_positions_mvvm.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/icons.dart';
import 'package:hrms/ui/widgets/reusable_circular_progress_indicator.dart';
import 'package:hrms/ui/widgets/reusable_data_table.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobPositionsPage extends StatefulWidget {
  final int id;

  const JobPositionsPage({Key? key, required this.id}) : super(key: key);

  @override
  _JobPositionsPageState createState() => _JobPositionsPageState();
}

class _JobPositionsPageState extends State<JobPositionsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<JobPositionsViewModel>().getJobPositions(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<JobPositionsViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Должности'),
        actions: [
          if (isCan('create-job-position'))
            IconButton(
              tooltip: 'Добавить должность',
              onPressed: () async => model.pushToAddPositionScreen(context),
              icon: Image.asset(HRMSIcons.add),
            ),
        ],
      ),
      body: const _JobPositionsBody(),
    );
  }
}

class _JobPositionsBody extends StatelessWidget {
  const _JobPositionsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((JobPositionsViewModel model) => model.data.isLoading);
    return isLoading
        ? const Center(child: ReusableCircularIndicator())
        : const _JobPositionsTable();
  }
}

class _JobPositionsTable extends StatelessWidget {
  const _JobPositionsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final row = context.read<JobPositionsViewModel>().data.jobPositionsDataRow;
    return SingleChildScrollView(
      child: ReusableDataTable(
        columns: kRolesTableColumns,
        rows: row,
      ),
    );
  }
}
