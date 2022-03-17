import 'package:flutter/material.dart';
import 'package:hrms/blocs/staffs/add_staff_mvvm.dart';
import 'package:hrms/data/models/persons/person.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/select_date_widget.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class AddStaffPage extends StatefulWidget {
  const AddStaffPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
      () => context.read<AddStaffViewModel>().load(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.add_staff.tr()),
      ),
      body: const _AddStaffReturnBody(),
    );
  }
}

class _AddStaffReturnBody extends StatelessWidget {
  const _AddStaffReturnBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInitializing =
        context.watch<AddStaffViewModel>().data.isInitializing;
    return isInitializing
        ? ShimmerWidget(enabled: isInitializing)
        : const _AddStaffBody();
  }
}

class _AddStaffBody extends StatelessWidget {
  const _AddStaffBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddStaffViewModel>();
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
              Text(LocaleKeys.full_name_label.tr(), style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              const AutoCompleteWidget(),
              const SizedBox(height: 16),
              Text(LocaleKeys.branch_text.tr(), style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setBranch(value),
                value: data.branchId,
                items: data.branchItems,
              ),
              const SizedBox(height: 16.0),
              Text(LocaleKeys.departments_label.tr() + ':', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setDepartment(value),
                value: data.departmentId,
                items: data.departmentsItems,
              ),
              const SizedBox(height: 16.0),
              Text(LocaleKeys.position_text.tr(), style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setJobPosition(value),
                value: data.jobPositionId,
                items: data.jobPositionsItems,
              ),
              const SizedBox(height: 16.0),
              Text(LocaleKeys.status_text.tr(), style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setStatus(value),
                value: data.stateId,
                items: data.stateItems,
              ),
              const SizedBox(height: 16),
              Text(LocaleKeys.accpeted_date_text.tr(),
                  style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              SelectDateWidget(
                onTap: () => model.selectDate(context: context),
                clearDate: () => model.clearDate,
                dateTimeController: data.confirmedDateController,
              ),
              ActionButton(
                text: LocaleKeys.save_text.tr(),
                isLoading: data.isLoading,
                onPressed: () =>
                    data.isLoading ? null : model.addStaff(context),
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
    final model = context.read<AddStaffViewModel>();
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
      initialValue: TextEditingValue(text: model.data.persons[0].fullName!),
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
