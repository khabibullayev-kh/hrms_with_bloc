import 'package:flutter/material.dart';
import 'package:hrms/blocs/branches/edit_branch_mvvm.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';


class EditBranchPage extends StatefulWidget {
  final int id;

  const EditBranchPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<EditBranchPage> createState() => _EditBranchPageState();
}

class _EditBranchPageState extends State<EditBranchPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
      () => context.read<EditBranchViewModel>().loadBranch(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${LocaleKeys.edit_branch.tr()} №${widget.id}'),
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
        context.watch<EditBranchViewModel>().data.isInitializing;
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
    final model = context.watch<EditBranchViewModel>();
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
                label: LocaleKeys.name_in_uzb_label.tr(),
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.branchNameRuController,
                label: LocaleKeys.name_in_ru_label.tr(),
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.addressController,
                label: LocaleKeys.address_text.tr(),
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.landmarkController,
                label: LocaleKeys.landmark_label.tr(),
                textInputType: TextInputType.name,
              ),
              Text(LocaleKeys.category_label.tr(), style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setShopCategory(value),
                value: data.shopCategory,
                items: data.shopCategoriesItems,
              ),
              const SizedBox(height: 16.0),
              Text(LocaleKeys.region_text.tr(), style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setRegion(value),
                value: data.regionId,
                items: data.regionsItems,
              ),
              const SizedBox(height: 16.0),
              Text(LocaleKeys.district_text.tr(), style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setDistrict(value),
                value: data.districtId,
                items: data.districtItems,
              ),
              const SizedBox(height: 16.0),
              Text(LocaleKeys.kadr_label.tr(), style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setKadr(value),
                value: data.kadrId,
                items: data.kadrItems,
              ),
              const SizedBox(height: 16.0),
              Text(LocaleKeys.director_label.tr(), style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setDirector(value),
                value: data.directorId,
                items: data.directorsItems,
              ),
              const SizedBox(height: 16.0),
              Text(LocaleKeys.recruiter_text.tr(), style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setRecruiter(value),
                value: data.recruitersId,
                items: data.recruitersItems,
              ),
              const SizedBox(height: 16.0),
              Text(LocaleKeys.reg_manager.tr(),
                  style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setRegManager(value),
                value: data.regManagersId,
                items: data.regManagersItems,
              ),
              const SizedBox(height: 16),
              ActionButton(
                text: LocaleKeys.save_text.tr(),
                isLoading: data.isLoading,
                onPressed: () =>
                    data.isLoading ? null : model.updateBranch(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
