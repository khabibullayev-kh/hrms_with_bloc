import 'package:flutter/material.dart';
import 'package:hrms/blocs/persons/add_person_mvvm.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/select_date_widget.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddPersonPage> createState() => _AddPersonsPageState();
}

class _AddPersonsPageState extends State<AddPersonPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
      () => context.read<AddPersonsViewModel>().loadData(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить сотрудника'),
      ),
      body: const _EditPersonReturnBody(),
    );
  }
}

class _EditPersonReturnBody extends StatelessWidget {
  const _EditPersonReturnBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInitializing =
        context.watch<AddPersonsViewModel>().data.isInitializing;
    return isInitializing
        ? ShimmerWidget(enabled: isInitializing)
        : const _EditBody();
  }
}

class _EditBody extends StatelessWidget {
  const _EditBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddPersonsViewModel>();
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
                controller: data.lastName,
                label: 'Фамилия:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.firstName,
                label: 'Имя:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.fathersName,
                label: 'Отчество:',
                textInputType: TextInputType.name,
              ),
              const Text('Дата рождения:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              SelectDateWidget(
                onTap: () => model.selectDate(
                  context: context,
                  selectedDateTime: data.selectedDateOfBirth,
                  dateTimeController: data.dateOfBirth,
                ),
                clearDate: () => model.clearDate(data.dateOfBirth),
                dateTimeController: data.dateOfBirth,
              ),
              const SizedBox(height: 16.0),
              TextFieldTile(
                controller: data.specialization,
                label: 'Специальность:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.phoneNumber,
                label: 'Телефон:',
                textInputType: TextInputType.phone,
              ),
              TextFieldTile(
                controller: data.additionalPhoneNumber,
                label: 'Доп. телефон:',
                textInputType: TextInputType.phone,
              ),
              TextFieldTile(
                controller: data.dateOfEndUniversity,
                label: 'Дата окончания ВУЗа:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.passportSeries,
                label: 'Серия паспорта:',
                textInputType: TextInputType.name,
                maxLength: 2,
              ),
              TextFieldTile(
                controller: data.passportNumber,
                label: 'Номер паспорта:',
                textInputType: TextInputType.number,
                maxLength: 7,
              ),
              const Text('Пол:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setSex(value),
                value: data.sex,
                items: data.sexItem,
              ),
              const SizedBox(height: 16.0),
              const Text('Образование:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setEducation(value),
                value: data.educationId,
                items: data.educationItems,
              ),
              const SizedBox(height: 16.0),
              const Text('Область:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setRegion(value),
                value: data.regionId,
                items: data.regionsItems,
              ),
              const SizedBox(height: 16.0),
              const Text('Район(город):', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setDistrict(value),
                value: data.districtId,
                items: data.districtItems,
              ),
              const SizedBox(height: 16),
              TextFieldTile(
                controller: data.address,
                label: 'Адрес:',
                textInputType: TextInputType.text,
              ),
              TextFieldTile(
                controller: data.voucherId,
                label: 'Номер направления:',
                textInputType: TextInputType.number,
              ),
              const Text('Дата приёма на работу:',
                  style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              SelectDateWidget(
                onTap: () => model.selectDate(
                  context: context,
                  selectedDateTime: data.selectedDateOfAccept,
                  dateTimeController: data.acceptedDate,
                ),
                clearDate: () => model.clearDate(data.acceptedDate),
                dateTimeController: data.acceptedDate,
              ),
              const SizedBox(height: 16.0),
              TextFieldTile(
                controller: data.salary,
                label: 'Зарплата:',
                textInputType: TextInputType.text,
              ),
              ActionButton(
                text: 'Сохранить',
                isLoading: data.isLoading,
                onPressed: () =>
                    data.isLoading ? null : model.addPerson(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

