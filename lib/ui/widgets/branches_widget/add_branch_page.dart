import 'package:flutter/material.dart';
import 'package:hrms/blocs/branches/add_branch_mvvm.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

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
        title: Text(LocaleKeys.add_branch.tr()),
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
              const _ChooseKadrsWidget(),
              Text(LocaleKeys.director_label.tr(), style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setDirector(value),
                value: data.directorId,
                items: data.directorsItems,
              ),
              const SizedBox(height: 16.0),
              const _ChooseRecruitersWidget(),
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
                data.isLoading ? null : model.addBranch(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChooseKadrsWidget extends StatelessWidget {
  const _ChooseKadrsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddBranchViewModel>();
    final data = model.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(LocaleKeys.kadr_label.tr(), style: HRMSStyles.labelStyle),
        const SizedBox(height: 8),
        MultiSelectDialogField(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text('Выберите кадровиков'),
          buttonText: const Text('Выберать кадровиков'),
          selectedColor: HRMSColors.green.withOpacity(0.4),
          itemsTextStyle: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
          listType: MultiSelectListType.CHIP,
          chipDisplay: MultiSelectChipDisplay(
            scroll: true,
            scrollBar: HorizontalScrollBar(isAlwaysShown: true),
          ),
          buttonIcon: const Icon(Icons.arrow_drop_down_sharp),
          initialValue: data.chosenKadrs,
          items: data.kadrsItems,
          onConfirm: (values) => model.setKadr(values),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

class _ChooseRecruitersWidget extends StatelessWidget {
  const _ChooseRecruitersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AddBranchViewModel>();
    final data = model.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(LocaleKeys.recruiter_text.tr(), style: HRMSStyles.labelStyle),
        const SizedBox(height: 8),
        MultiSelectDialogField(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text('Выберите рекрутеров'),
          buttonText: const Text('Выберать рекрутеров'),
          selectedColor: HRMSColors.green.withOpacity(0.4),
          itemsTextStyle: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
          listType: MultiSelectListType.CHIP,
          chipDisplay: MultiSelectChipDisplay(
            scroll: true,
            scrollBar: HorizontalScrollBar(isAlwaysShown: true),
          ),
          buttonIcon: const Icon(Icons.arrow_drop_down_sharp),
          initialValue: data.chosenRecruiters,
          items: data.recruiterItems,
          onConfirm: (values) => model.setRecruiter(values),
        ),
      ],
    );
  }
}
