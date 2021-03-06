import 'package:flutter/material.dart';
import 'package:hrms/blocs/departments/departments_mvvm.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/ui/widgets/reusable_circular_progress_indicator.dart';
import 'package:hrms/ui/widgets/reusable_data_table.dart';
import 'package:hrms/ui/widgets/side_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepartmentsPage extends StatefulWidget {
  const DepartmentsPage({Key? key}) : super(key: key);

  @override
  _DepartmentsPageState createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => context.read<DepartmentsViewModel>().getDepartments(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отделы'),
      ),
      drawer: const SideBar(),
      body: const _DepartmentsBody(),
    );
  }
}

class _DepartmentsBody extends StatelessWidget {
  const _DepartmentsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((DepartmentsViewModel model) => model.data.isLoading);
    return isLoading
        ? const Center(child: ReusableCircularIndicator())
        : const _DepartmentsTable();
  }
}

class _DepartmentsTable extends StatelessWidget {
  const _DepartmentsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final row = context.watch<DepartmentsViewModel>().data.departmentsDataRow;
    return SingleChildScrollView(
      child: ReusableDataTable(
        height: 60,
        columns: kDepartmentsTableColumns,
        rows: row,
      ),
    );
  }
}
