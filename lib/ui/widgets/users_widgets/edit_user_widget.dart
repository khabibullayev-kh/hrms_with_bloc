import 'package:flutter/material.dart';
import 'package:hrms/blocs/users/edit_user_mvvm.dart';
import 'package:hrms/data/models/persons/person.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class EditUserPage extends StatefulWidget {
  final int id;

  const EditUserPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
          () => context.read<EditUserViewModel>().loadUser(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${LocaleKeys.edit_user.tr()} №${widget.id}'),
      ),
      body: const EditUserReturnBody(),
    );
  }
}

class EditUserReturnBody extends StatelessWidget {
  const EditUserReturnBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInitializing = context.watch<EditUserViewModel>().data.isInitializing;
    return isInitializing ? ShimmerWidget(enabled: isInitializing) : const EditUserBody();

  }
}

class EditUserBody extends StatelessWidget {
  const EditUserBody({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.watch<EditUserViewModel>();
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
              const _AutoCompleteWidget(),
              const SizedBox(height: 16),
              TextFieldTile(
                controller: data.usernameController,
                label: LocaleKeys.login_label_text.tr() + ':',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.userPasswordController,
                label: LocaleKeys.password_label_text.tr() + ":",
                textInputType: TextInputType.name,
              ),
              Text(LocaleKeys.role.tr() + ":", style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setRole(value),
                value: data.roleId,
                items: data.dropdownMenuItems,
              ),
              const SizedBox(height: 16),
              ActionButton(
                text: LocaleKeys.save_text.tr(),
                isLoading: data.isLoading,
                onPressed: () => data.isLoading ? null : model.updateUser(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AutoCompleteWidget extends StatelessWidget {
  const _AutoCompleteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<EditUserViewModel>();
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

