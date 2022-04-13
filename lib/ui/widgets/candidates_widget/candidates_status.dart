import 'package:flutter/material.dart';
import 'package:hrms/blocs/candidates/change_candidate_status_mvvm.dart';
import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class CandidatesChangeState extends StatefulWidget {
  final Candidate candidate;

  const CandidatesChangeState({Key? key, required this.candidate})
      : super(key: key);

  @override
  _CandidatesChangeStateState createState() => _CandidatesChangeStateState();
}

class _CandidatesChangeStateState extends State<CandidatesChangeState> {
  @override
  Widget build(BuildContext context) {
    final stateId =
        context.watch<ChangeCandidateStatusViewModel>().candidate.state!.id;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.candidate.lastName! + ' ' + widget.candidate.firstName!),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: CandidateStateBody(stateId: stateId),
        ),
      ),
    );
  }
}

class CandidateStateBody extends StatelessWidget {
  final int stateId;

  const CandidateStateBody({Key? key, required this.stateId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (stateId) {
      case 13:
        return const _NewCandidateChangeState();
      case 14:
        return const _FirstStateCandidate();
      case 15:
        return const _InvitedStateCandidate();
      case 20:
        return const _ArchivedCandidateChangeState();
      default:
        return const _NewCandidateChangeState();
    }
  }
}

class _InvitedStateCandidate extends StatelessWidget {
  const _InvitedStateCandidate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChangeCandidateStatusViewModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _CommentField(),
          const SizedBox(height: 24),
          Text(LocaleKeys.branch_text.tr(), style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: model.setBranch,
            value: model.data.branchId,
            items: model.data.branchesItems,
          ),
          const SizedBox(height: 16),
          Text(LocaleKeys.position_text.tr(), style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: model.setVacancy,
            value: model.data.vacancyId,
            items: model.data.vacancyItems ??
                [
                  DropdownMenuItem(
                    child: Text(LocaleKeys.no_job_position.tr()),
                    value: null,
                  )
                ],
          ),
          const SizedBox(height: 16),
          const _ChooseFileWidget(),
          const SizedBox(height: 16),
          const _ActionsColumnWidget(),
        ],
      ),
    );
  }
}

class _ChooseFileWidget extends StatelessWidget {
  const _ChooseFileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChangeCandidateStatusViewModel>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Job Offer', style: HRMSStyles.loginText),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => model.chooseFile(context),
                behavior: HitTestBehavior.opaque,
                child: IgnorePointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: model.data.chooseFileController,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.upload_file,
                        color: Colors.grey,
                      ),
                      hintStyle: TextStyle(color: Colors.blueGrey.shade400),
                      hintText: 'Выберите файл',
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: HRMSColors.green,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FirstStateCandidate extends StatelessWidget {
  const _FirstStateCandidate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = context.read<ChangeCandidateStatusViewModel>().data;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        children: <Widget>[
          const _CommentField(),
          const SizedBox(height: 16),
          TextFieldTile(
            controller: data.dateOfMeetingController,
            label: LocaleKeys.date_of_interview_label.tr(),
          ),
          TextFieldTile(
            controller: data.addressController,
            label: LocaleKeys.address_of_interview_label.tr(),
          ),
          const _ActionsColumnWidget(),
        ],
      ),
    );
  }
}

class _ArchivedCandidateChangeState extends StatelessWidget {
  const _ArchivedCandidateChangeState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        children: const [
          _CommentField(),
          _ArchivedColumnWidget(),
        ],
      ),
    );
  }
}

class _ArchivedColumnWidget extends StatelessWidget {
  const _ArchivedColumnWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double actionButtonWidth = MediaQuery.of(context).size.width * 0.7;
    final double actionButtonHeight = MediaQuery.of(context).size.height / 20;
    final model = context.watch<ChangeCandidateStatusViewModel>();
    bool isLoading = model.isLoading();
    return Column(
      children: <Widget>[
        const SizedBox(height: 32),
        ActionButton(
          text: LocaleKeys.cancel_text.tr(),
          onPressed: () => isLoading ? null : model.cancelState(context),
          isLoading: model.data.isCancelLoading,
          color: Colors.redAccent,
          width: actionButtonWidth,
          height: actionButtonHeight,
        ),
        const SizedBox(height: 16),
        ActionButton(
          text: LocaleKeys.unpack_text.tr(),
          onPressed: () => isLoading ? null : model.unPackState(context),
          isLoading: model.data.isUnpackLoading,
          color: HRMSColors.green,
          width: actionButtonWidth,
          height: actionButtonHeight,
        ),
      ],
    );
  }
}

class _NewCandidateChangeState extends StatelessWidget {
  const _NewCandidateChangeState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        children: const [
          _CommentField(),
          _ActionsColumnWidget(),
        ],
      ),
    );
  }
}

class _ActionsColumnWidget extends StatelessWidget {
  const _ActionsColumnWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double actionButtonWidth = MediaQuery.of(context).size.width * 0.7;
    final double actionButtonHeight = MediaQuery.of(context).size.height / 20;
    final model = context.watch<ChangeCandidateStatusViewModel>();
    bool isLoading = model.isLoading();
    bool isNextStateLoading = model.data.isNextStateLoading;
    return Column(
      children: <Widget>[
        const SizedBox(height: 32),
        ActionButton(
          text: LocaleKeys.cancel_text.tr(),
          onPressed: () => isLoading ? null : model.cancelState(context),
          isLoading: model.data.isCancelLoading,
          color: Colors.redAccent,
          width: actionButtonWidth,
          height: actionButtonHeight,
        ),
        const SizedBox(height: 16),
        ActionButton(
          text: LocaleKeys.block_text.tr(),
          onPressed: () => isLoading ? null : model.blocState(context),
          isLoading: model.data.isBlockLoading,
          color: Colors.black,
          width: actionButtonWidth,
          height: actionButtonHeight,
        ),
        const SizedBox(height: 16),
        ActionButton(
          text: LocaleKeys.archieve_text.tr(),
          onPressed: () => isLoading ? null : model.reserveState(context),
          isLoading: model.data.isArchiveLoading,
          color: Colors.blueAccent,
          width: actionButtonWidth,
          height: actionButtonHeight,
        ),
        const SizedBox(height: 16),
        ActionButton(
          text: LocaleKeys.change_status.tr(),
          onPressed: () => isLoading ? null : model.updateState(context),
          isLoading: isNextStateLoading,
          color: HRMSColors.green,
          width: actionButtonWidth,
          height: actionButtonHeight,
        ),
      ],
    );
  }
}

class _CommentField extends StatelessWidget {
  const _CommentField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 2,
          color: HRMSColors.green,
        ),
      ),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: HRMSColors.green,
        controller: TextEditingController(),
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            fillColor: Colors.white,
            border: InputBorder.none,
            hintText: LocaleKeys.comments_label.tr().replaceAll(':', ''),
            hintStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w200)),
      ),
    );
  }
}
