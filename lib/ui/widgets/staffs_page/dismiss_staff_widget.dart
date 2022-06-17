import 'package:flutter/material.dart';
import 'package:hrms/blocs/staffs/dismiss_staff_mvvm.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/select_date_widget.dart';
import 'package:provider/provider.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class DismissStaffWidget extends StatelessWidget {
  const DismissStaffWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DismissStaffViewModel>();
    final isLoading = model.data.isLoading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          LocaleKeys.confirm_dismissal.tr(),
          style: HRMSStyles.h1Style,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Center(
            child: SelectDateWidget(
              onTap: () => model.selectDate(context: context),
              clearDate: () {},
              dateTimeController: model.data.dateOfDismiss,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 52,
              child: ActionButton(
                text: LocaleKeys.yes_text.tr(),
                onPressed: () => model.deleteBranch(context),
                isLoading: isLoading,
              ),
            ),
            SizedBox(
              height: 52,
              child: ActionButton(
                text: LocaleKeys.no_text.tr(),
                onPressed: () => isLoading ? null : Navigator.pop(context),
                isLoading: false,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
