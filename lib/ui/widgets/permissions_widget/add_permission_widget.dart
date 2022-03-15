import 'package:flutter/material.dart';
import 'package:hrms/blocs/permissions/add_permission_mvvm.dart';
import 'package:hrms/ui/widgets/action_button.dart';

import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';

class AddPermissionWidget extends StatefulWidget {
  const AddPermissionWidget({Key? key}) : super(key: key);

  @override
  State<AddPermissionWidget> createState() => _AddPermissionState();
}

class _AddPermissionState extends State<AddPermissionWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить новое разрешение'),
      ),
      body: const _AddUserBody(),
    );
  }
}

class _AddUserBody extends StatelessWidget {
  const _AddUserBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddPermissionViewModel>();
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
              const SizedBox(height: 16),
              ActionButton(
                text: 'Сохранить',
                isLoading: data.isLoading,
                onPressed: () => data.isLoading ? null : model.addPermission(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
