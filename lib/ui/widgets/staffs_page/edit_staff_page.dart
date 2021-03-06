import 'package:flutter/material.dart';
import 'package:hrms/blocs/staffs/edit_staff_mvvm.dart';
import 'package:hrms/data/models/persons/person.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/select_date_widget.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';

class EditStaffPage extends StatefulWidget {
  final int id;

  const EditStaffPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EditStaffPage> createState() => _EditStaffPageState();
}

class _EditStaffPageState extends State<EditStaffPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
      () => context.read<EditStaffViewModel>().load(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать штат №${widget.id}'),
      ),
      body: const _EditStaffReturnBody(),
    );
  }
}

class _EditStaffReturnBody extends StatelessWidget {
  const _EditStaffReturnBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInitializing =
        context.watch<EditStaffViewModel>().data.isInitializing;
    return isInitializing
        ? ShimmerWidget(enabled: isInitializing)
        : const _EditStaffBody();
  }
}

class _EditStaffBody extends StatelessWidget {
  const _EditStaffBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<EditStaffViewModel>();
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
              const AutoCompleteWidget(),
              const SizedBox(height: 16),
              const Text('Филиал:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setBranch(value),
                value: data.branchId,
                items: data.branchItems,
              ),
              const SizedBox(height: 16.0),
              const Text('Отделы:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setDepartment(value),
                value: data.departmentId,
                items: data.departmentsItems,
              ),
              const SizedBox(height: 16.0),
              const Text('Должность:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setJobPosition(value),
                value: data.jobPositionId,
                items: data.jobPositionsItems,
              ),
              const SizedBox(height: 16.0),
              const Text('Статус:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setStatus(value),
                value: data.stateId,
                items: data.stateItems,
              ),
              const SizedBox(height: 16),
              const Text('Дата приёма на работу:',
                  style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              SelectDateWidget(
                onTap: () => model.selectDate(context: context),
                clearDate: () => model.clearDate,
                dateTimeController: data.confirmedDateController,
              ),
              ActionButton(
                text: 'Сохранить',
                isLoading: data.isLoading,
                onPressed: () =>
                    data.isLoading ? null : model.editStaff(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AutoCompleteWidget extends StatelessWidget {
  const AutoCompleteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<EditStaffViewModel>();
    return Autocomplete<Person>(
      onSelected: (Person person) {
        model.data.personId = person.id;
        model.data.fioController.text = person.fullName!;
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        return model.data.persons
            .where((Person person) => (person.fullName!)
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()))
            .toList();
      },
      initialValue: TextEditingValue(text: model.data.fioController.text),
      displayStringForOption: (Person person) => person.fullName!,
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.name,
          cursorColor: HRMSColors.green,
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.blueGrey.shade400),
            hintText: 'Вакант',
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: HRMSColors.green, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
        );
      },
    );
  }
}
