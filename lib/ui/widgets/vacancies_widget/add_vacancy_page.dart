import 'package:flutter/material.dart';
import 'package:hrms/blocs/vacancies/add_vacancy_mvvm.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/select_date_widget.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';

class AddVacancyPage extends StatefulWidget {
  const AddVacancyPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddVacancyPage> createState() => _AddVacancyPageState();
}

class _AddVacancyPageState extends State<AddVacancyPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
      () => context.read<AddVacancyViewModel>().load(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить вакансию'),
      ),
      body: const _AddVacancyReturnBody(),
    );
  }
}

class _AddVacancyReturnBody extends StatelessWidget {
  const _AddVacancyReturnBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInitializing =
        context.watch<AddVacancyViewModel>().data.isInitializing;
    return isInitializing
        ? ShimmerWidget(enabled: isInitializing)
        : const _AddVacancyBody();
  }
}

class _AddVacancyBody extends StatelessWidget {
  const _AddVacancyBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddVacancyViewModel>();
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
                controller: data.mentor,
                label: 'Ментор:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.requirements,
                label: 'Требования:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.description,
                label: 'Описание:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.salary,
                label: 'Зарплата:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.bonus,
                label: 'Бонус:',
                textInputType: TextInputType.name,
              ),
              const Text('Дата:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              SelectDateWidget(
                onTap: () => model.selectDate(context: context),
                clearDate: () => model.clearDate(),
                dateTimeController: data.date,
              ),
              const SizedBox(height: 16.0),
              TextFieldTile(
                controller: data.quantity,
                label: 'Количество:',
                textInputType: TextInputType.number,
              ),
              const Text('Важность:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setImportance(value),
                value: data.importanceId,
                items: data.importance,
              ),
              const SizedBox(height: 16.0),
              const Text('Отделы:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setDepartment(value),
                value: data.departmentId,
                items: data.departmentItems,
              ),
              const SizedBox(height: 16.0),
              const Text('Должность:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setJobPosition(value),
                value: data.jobPositionId,
                items: data.jobPositionItems,
              ),
              const SizedBox(height: 16.0),
              const Text('Филиал:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setBranch(value),
                value: data.branchesId,
                items: data.branchesItems,
              ),
              const SizedBox(height: 16.0),
              ActionButton(
                text: 'Сохранить',
                isLoading: data.isLoading,
                onPressed: () =>
                    data.isLoading ? null : model.addVacancy(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
