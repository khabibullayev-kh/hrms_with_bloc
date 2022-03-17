import 'package:flutter/material.dart';
import 'package:hrms/blocs/users/add_user_mvvm.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class AddUsersPage extends StatefulWidget {
  const AddUsersPage({Key? key}) : super(key: key);

  @override
  State<AddUsersPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUsersPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
      () => context.read<AddUserViewModel>().loadUser(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(LocaleKeys.add_user.tr()),
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
    final isInitializing =
        context.watch<AddUserViewModel>().data.isInitializing;
    return isInitializing
        ? ShimmerWidget(enabled: isInitializing)
        : const AddUserBody();
  }
}

class AddUserBody extends StatelessWidget {
  const AddUserBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddUserViewModel>();
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
                controller: data.userFirstNameController,
                label: LocaleKeys.first_name_label.tr(),
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.userSurnameController,
                label: LocaleKeys.last_name_label.tr(),
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.userNameController,
                label: LocaleKeys.login_label_text.tr() + ':',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.userEmailController,
                label: 'Email:',
                textInputType: TextInputType.emailAddress,
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
                onPressed: () =>
                    data.isLoading ? null : model.updateUser(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
