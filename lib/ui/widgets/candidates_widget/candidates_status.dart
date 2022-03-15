import 'package:flutter/material.dart';
import 'package:hrms/blocs/candidates/change_candidate_status_mvvm.dart';
import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/text_field_tile_widget.dart';
import 'package:provider/provider.dart';

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
        title:
            Text(widget.candidate.lastName + ' ' + widget.candidate.firstName),
      ),
      body: SafeArea(
        child: CandidateStateBody(stateId: stateId),
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
        children: [
          const _CommentField(),
          const SizedBox(height: 24),
          const Text('Филиал:', style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: model.setBranch,
            value: model.data.branchId,
            items: model.data.branchesItems,
          ),
          const SizedBox(height: 16),
          const Text('Должность:', style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: model.setVacancy,
            value: model.data.vacancyId,
            items: model.data.vacancyItems ??
                [
                  const DropdownMenuItem(
                    child: Text('Нет вакансии'),
                    value: null,
                  )
                ],
          ),
          const _ActionsColumnWidget(),
        ],
      ),
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
            label: 'Дата интервью',
          ),
          TextFieldTile(
            controller: data.addressController,
            label: 'Адрес интервью',
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
          text: 'Отменить',
          onPressed: () => isLoading ? null : model.cancelState(context),
          isLoading: model.data.isCancelLoading,
          color: Colors.redAccent,
          width: actionButtonWidth,
          height: actionButtonHeight,
        ),
        const SizedBox(height: 16),
        ActionButton(
          text: 'Снять с резерва',
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
          text: 'Отменить',
          onPressed: () => isLoading ? null : model.cancelState(context),
          isLoading: model.data.isCancelLoading,
          color: Colors.redAccent,
          width: actionButtonWidth,
          height: actionButtonHeight,
        ),
        const SizedBox(height: 16),
        ActionButton(
          text: 'Блокировать',
          onPressed: () => isLoading ? null : model.blocState(context),
          isLoading: model.data.isBlockLoading,
          color: Colors.black,
          width: actionButtonWidth,
          height: actionButtonHeight,
        ),
        const SizedBox(height: 16),
        ActionButton(
          text: 'Резерв',
          onPressed: () => isLoading ? null : model.reserveState(context),
          isLoading: model.data.isArchiveLoading,
          color: Colors.blueAccent,
          width: actionButtonWidth,
          height: actionButtonHeight,
        ),
        const SizedBox(height: 16),
        ActionButton(
          text: 'Следущий статус',
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
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(16),
            fillColor: Colors.white,
            border: InputBorder.none,
            hintText: 'Комментарии',
            hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w200)),
      ),
    );
  }
}
