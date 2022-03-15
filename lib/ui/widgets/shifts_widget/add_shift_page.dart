import 'package:flutter/material.dart';
import 'package:hrms/blocs/shifts/add_shift_mvvm.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';

class AddShiftPage extends StatefulWidget {
  const AddShiftPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddShiftPage> createState() => _AddShiftPageState();
}

class _AddShiftPageState extends State<AddShiftPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
      () => context.read<AddShiftViewModel>().loadShift(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить перевод'),
      ),
      body: const _AddShiftReturnBody(),
    );
  }
}

class _AddShiftReturnBody extends StatelessWidget {
  const _AddShiftReturnBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInitializing =
        context.watch<AddShiftViewModel>().data.isInitializing;
    return isInitializing
        ? ShimmerWidget(enabled: isInitializing)
        : const _AddShiftBody();
  }
}

class _AddShiftBody extends StatelessWidget {
  const _AddShiftBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddShiftViewModel>();
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
              const Text('ФИО:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              //const AutocompleteBasicExample(),
              ReusableDropDownButton(
                onChanged: (value) => model.setPerson(value),
                value: data.personId,
                items: data.personsItems,
              ),
              const SizedBox(height: 16.0),
              TextFieldTile(
                controller: data.experienceController,
                label: 'Опыт работы:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.achievementsController,
                label: 'Достижения:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.mistakesController,
                label: 'Ошибки во время работы:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.reasonsToChangeController,
                label: 'Причина перевода:',
                textInputType: TextInputType.name,
              ),
              const Text('На какой филиал:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setBranch(value),
                value: data.branchId,
                items: data.branchItems,
              ),
              const SizedBox(height: 16.0),
              const Text('На какую должность:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setFreeStaff(value),
                value: data.staffId,
                items: data.toJobPositionItems,
              ),
              const SizedBox(height: 16),
              ActionButton(
                text: 'Сохранить',
                isLoading: data.isLoading,
                onPressed: () =>
                    data.isLoading ? null : model.addBranch(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
