import 'package:flutter/material.dart';
import 'package:hrms/blocs/permissions/edit_permission_mvvm.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';

import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';

class EditPermissionWidget extends StatefulWidget {
  final int permissionId;

  const EditPermissionWidget({Key? key, required this.permissionId}) : super(key: key);

  @override
  State<EditPermissionWidget> createState() => _EditPermissionPageState();
}

class _EditPermissionPageState extends State<EditPermissionWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
          () => context.read<EditPermissionViewModel>().loadPermission(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Изменить разрешение №${widget.permissionId}'),
      ),
      body: const EditPermissionReturnBody(),
    );
  }
}

class EditPermissionReturnBody extends StatelessWidget {
  const EditPermissionReturnBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInitializing =
        context.watch<EditPermissionViewModel>().data.isInitializing;
    return isInitializing
        ? ShimmerWidget(enabled: isInitializing)
        : const AddPermissionBody();
  }
}

class AddPermissionBody extends StatelessWidget {
  const AddPermissionBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<EditPermissionViewModel>();
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
                onPressed: () => data.isLoading ? null : model.editPermission(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
