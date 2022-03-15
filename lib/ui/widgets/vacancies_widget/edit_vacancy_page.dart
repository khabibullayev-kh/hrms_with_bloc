import 'package:flutter/material.dart';
import 'package:hrms/blocs/vacancies/add_vacancy_mvvm.dart';
import 'package:hrms/blocs/vacancies/edit_vacancy_mvvm.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/select_date_widget.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';

class EditVacancyPage extends StatefulWidget {
  final int id;

  const EditVacancyPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EditVacancyPage> createState() => _EditVacancyPageState();
}

class _EditVacancyPageState extends State<EditVacancyPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
      () => context.read<EditVacancyViewModel>().load(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Изменить вакансию №${widget.id}'),
      ),
      body: const _EditVacancyReturnBody(),
    );
  }
}

class _EditVacancyReturnBody extends StatelessWidget {
  const _EditVacancyReturnBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInitializing =
        context.watch<EditVacancyViewModel>().data.isInitializing;
    return isInitializing
        ? ShimmerWidget(enabled: isInitializing)
        : const _EditVacancyBody();
  }
}

class _EditVacancyBody extends StatelessWidget {
  const _EditVacancyBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<EditVacancyViewModel>();
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
              const Text('Статус:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setStatus(value),
                value: data.stateId,
                items: data.stateItems,
              ),
              const SizedBox(height: 16.0),
              TextFieldTile(
                controller: data.department,
                label: 'Отдел:',
                textInputType: TextInputType.number,
                readOnly: true,
              ),
              TextFieldTile(
                controller: data.jobPosition,
                label: 'Должность:',
                textInputType: TextInputType.number,
                readOnly: true,
              ),
              TextFieldTile(
                controller: data.branch,
                label: 'Филиал:',
                textInputType: TextInputType.number,
                readOnly: true,
              ),
              ActionButton(
                text: 'Сохранить',
                isLoading: data.isLoading,
                onPressed: () =>
                    data.isLoading ? null : model.updateVacancy(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
