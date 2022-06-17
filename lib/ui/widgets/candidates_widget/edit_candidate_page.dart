import 'package:flutter/material.dart';
import 'package:hrms/blocs/candidates/edit_candidate_mvvm.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class EditCandidatePage extends StatefulWidget {
  final int id;

  const EditCandidatePage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<EditCandidatePage> createState() => _EditCandidatePageState();
}

class _EditCandidatePageState extends State<EditCandidatePage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => context.read<EditCandidateViewModel>().loadCandidate(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.change_candidate.tr() + ' №${widget.id}'),
      ),
      body: const _EditCandidateReturnBody(),
    );
  }
}

class _EditCandidateReturnBody extends StatelessWidget {
  const _EditCandidateReturnBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInitializing =
        context.watch<EditCandidateViewModel>().data.isInitializing;
    return isInitializing
        ? ShimmerWidget(enabled: isInitializing)
        : const _EditCandidateBody();
  }
}

class _EditCandidateBody extends StatelessWidget {
  const _EditCandidateBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<EditCandidateViewModel>();
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
                controller: data.firstName,
                label: LocaleKeys.first_name_label.tr(),
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.lastName,
                label: LocaleKeys.last_name_label.tr(),
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.fatherName,
                label: LocaleKeys.father_name_label.tr(),
                textInputType: TextInputType.name,
              ),
              TextFieldTile(
                controller: data.dateOfBirth,
                label: LocaleKeys.date_of_birth_label.tr(),
                textInputType: TextInputType.name,
              ),
              Text(LocaleKeys.position_text.tr(), style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setJobPosition(value),
                value: data.jobPositionId,
                items: data.jobPositionItems,
              ),
              const SizedBox(height: 16.0),
              Text(LocaleKeys.branch_text.tr(), style: HRMSStyles.labelStyle),
              const SizedBox(height: 8),
              ReusableDropDownButton(
                onChanged: (value) => model.setBranch(value),
                value: data.branchId,
                items: data.branchesItems,
              ),
              const SizedBox(height: 16.0),
              ActionButton(
                text: LocaleKeys.save_text.tr(),
                isLoading: data.isLoading,
                onPressed: () =>
                    data.isLoading ? null : model.updateCandidate(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
