import 'package:flutter/material.dart';
import 'package:hrms/blocs/permissions/edit_permission_mvvm.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
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
        title: Text('${LocaleKeys.edit_permission.tr()} №${widget.permissionId}'),
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
                label: LocaleKeys.slug.tr() + ':',
                textInputType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              ActionButton(
                text: LocaleKeys.save_text.tr(),
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
