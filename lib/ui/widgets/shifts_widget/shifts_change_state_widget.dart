import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms/blocs/shifts/change_shifts_status_view_model.dart';
import 'package:hrms/data/models/shifts/shift.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:provider/provider.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ShiftsChangeState extends StatefulWidget {
  final Shift shift;

  const ShiftsChangeState({Key? key, required this.shift}) : super(key: key);

  @override
  _ShiftsChangeStateState createState() => _ShiftsChangeStateState();
}

class _ShiftsChangeStateState extends State<ShiftsChangeState> {
  @override
  Widget build(BuildContext context) {
    final stateId = context.watch<ChangeShiftsStatusViewModel>().shift.state.id;
    return Scaffold(
      appBar: AppBar(
        title: Text('${LocaleKeys.shift_label.tr()} №${widget.shift.id}'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(child: _ShiftStateBody(stateId: stateId)),
      ),
    );
  }
}

class _ShiftStateBody extends StatelessWidget {
  final int stateId;

  const _ShiftStateBody({Key? key, required this.stateId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (stateId) {
      case 23:
        return const _AddDocumentState();
      default:
        return const _NewCandidateChangeState();
    }
  }
}

class _AddDocumentState extends StatelessWidget {
  const _AddDocumentState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChangeShiftsStatusViewModel>();
    final pickedFile = model.data.pickedFile;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        children: [
          const _CommentField(),
          const SizedBox(height: 16),
          Column(
            children: <Widget>[
              pickedFile != null
                  ? Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(6.44),
                          ),
                          child: Image.file(
                            File(pickedFile.path),
                            height: MediaQuery.of(context).size.height / 5,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      "Добавьте фото",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      onPressed: () => model.openCamera(),
                      icon: const Icon(Icons.camera_alt)),
                  IconButton(
                      onPressed: () => model.openGallery(),
                      icon: const Icon(Icons.photo))
                ],
              ),
            ],
          ),
          const _ActionsColumnWidget(),
        ],
      ),
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
    final model = context.watch<ChangeShiftsStatusViewModel>();
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
          text: LocaleKeys.change_status.tr(),
          onPressed: () => isLoading ? null : model.updateFirstState(context),
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
            hintStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w200)),
      ),
    );
  }
}
