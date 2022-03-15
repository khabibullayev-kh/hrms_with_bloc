import 'package:flutter/material.dart';
import 'package:hrms/blocs/branches/add_branch_mvvm.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';

class AddBranchPage extends StatefulWidget {

  const AddBranchPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddBranchPage> createState() => _AddBranchPageState();
}

class _AddBranchPageState extends State<AddBranchPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
          () => context.read<AddBranchViewModel>().loadBranch(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить филиал'),
      ),
      body: const _EditBranchReturnBody(),
    );
  }
}

class _EditBranchReturnBody extends StatelessWidget {
  const _EditBranchReturnBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInitializing =
        context.watch<AddBranchViewModel>().data.isInitializing;
    return isInitializing
        ? ShimmerWidget(enabled: isInitializing)
        : const _EditBranchBody();
  }
}

class _EditBranchBody extends StatelessWidget {
  const _EditBranchBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddBranchViewModel>();
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
                controller: data.branchNameUzController,
                label: 'Название на узбекском:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.branchNameRuController,
                label: 'Название на русском:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.addressController,
                label: 'Адрес:',
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.landmarkController,
                label: 'Ориентир:',
                textInputType: TextInputType.name,
              ),
              const Text('Категория:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setShopCategory(value),
                value: data.shopCategory,
                items: data.shopCategoriesItems,
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
              const SizedBox(height: 16.0),
              const Text('Кадровик:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setKadr(value),
                value: data.kadrId,
                items: data.kadrItems,
              ),
              const SizedBox(height: 16.0),
              const Text('Управляющий:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setDirector(value),
                value: data.directorId,
                items: data.directorsItems,
              ),
              const SizedBox(height: 16.0),
              const Text('Рекрутер:', style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setRecruiter(value),
                value: data.recruitersId,
                items: data.recruitersItems,
              ),
              const SizedBox(height: 16.0),
              const Text('Региональный менеджер:',
                  style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setRegManager(value),
                value: data.regManagersId,
                items: data.regManagersItems,
              ),
              const SizedBox(height: 16),
              ActionButton(
                text: 'Сохранить',
                isLoading: data.isLoading,
                onPressed: () =>
                data.isLoading ? null : model.addBranch(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
