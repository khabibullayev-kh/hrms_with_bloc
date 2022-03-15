import 'package:flutter/material.dart';
import 'package:hrms/blocs/roles/add_role_mvvm.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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
        title: const Text('Добавить новый роль'),
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
                label: 'Название на узбекском:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.roleNameRuController,
                label: 'Название на русском:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.roleNameController,
                label: 'Слаг:',
                textInputType: TextInputType.name,
              ),
              const Text('Разрешения:', style: HRMSStyles.labelStyle),
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
                text: 'Сохранить',
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
