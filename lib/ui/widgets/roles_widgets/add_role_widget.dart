import 'package:flutter/material.dart';
import 'package:hrms/blocs/roles/add_role_mvvm.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';

class AddRoleWidget extends StatefulWidget {
  const AddRoleWidget({Key? key}) : super(key: key);

  @override
  State<AddRoleWidget> createState() => _AddRolePageState();
}

class _AddRolePageState extends State<AddRoleWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
      () => context.read<AddRoleViewModel>().loadUser(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.add_role.tr()),
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
        context.watch<AddRoleViewModel>().data.isInitializing;
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
    final model = context.watch<AddRoleViewModel>();
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
                controller: data.roleNameUzController,
                label: LocaleKeys.name_in_uzb_label.tr(),
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.roleNameRuController,
                label: LocaleKeys.name_in_ru_label.tr(),
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.roleNameController,
                label: LocaleKeys.slug.tr() + ":",
                textInputType: TextInputType.name,
              ),
              Text(LocaleKeys.permissions.tr() + ":", style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              MultiSelectDialogField(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                title: const Text('Выберите разрешения'),
                buttonText: const Text('Выберите разрешения'),
                selectedColor: HRMSColors.green.withOpacity(0.4),
                itemsTextStyle:
                    const TextStyle(fontSize: 12, color: Colors.black),
                listType: MultiSelectListType.CHIP,
                chipDisplay: MultiSelectChipDisplay(
                  scroll: true,
                  scrollBar: HorizontalScrollBar(isAlwaysShown: true),
                ),
                buttonIcon: const Icon(Icons.arrow_drop_down_sharp),
                initialValue: data.role.permissions,
                items: data.items,
                onConfirm: (values) => model.setPermissions(values),
              ),
              const SizedBox(height: 16),
              ActionButton(
                text: LocaleKeys.save_text.tr(),
                isLoading: data.isLoading,
                onPressed: () => data.isLoading ? null : model.addRole(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
