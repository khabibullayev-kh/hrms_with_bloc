import 'package:flutter/material.dart';
import 'package:hrms/blocs/departments/add_job_position_mvvm.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';

class AddJobPositionPage extends StatefulWidget {

  const AddJobPositionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddJobPositionPage> createState() => _AddJobPositionPageState();
}

class _AddJobPositionPageState extends State<AddJobPositionPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
          () => context.read<AddJobPositionViewModel>().load(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить должность'),
      ),
      body: const _EditJobPositionReturnBody(),
    );
  }
}

class _EditJobPositionReturnBody extends StatelessWidget {
  const _EditJobPositionReturnBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInitializing =
        context.watch<AddJobPositionViewModel>().data.isInitializing;
    return isInitializing
        ? ShimmerWidget(enabled: isInitializing)
        : const _EditJobPositionBody();
  }
}

class _EditJobPositionBody extends StatelessWidget {
  const _EditJobPositionBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddJobPositionViewModel>();
    final data = model.data;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
            left: 8.0,
            top: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldTile(
                controller: data.jobPositionNameUz,
                label: 'Название на узбекском:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.jobPositionNameRu,
                label: 'Название на русском:',
                textInputType: TextInputType.name,
              ),
              const Text('Отдел:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setDepartment(value),
                value: data.departmentId,
                items: data.dropdownMenuItems,
              ),
              const SizedBox(height: 16),
              ActionButton(
                text: 'Сохранить',
                isLoading: data.isLoading,
                onPressed: () =>
                data.isLoading ? null : model.addJobPosition(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
