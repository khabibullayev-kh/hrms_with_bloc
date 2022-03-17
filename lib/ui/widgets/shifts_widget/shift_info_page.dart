import 'package:flutter/material.dart';
import 'package:hrms/blocs/shifts/shift_info_mvvm.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/info_shimmer_widget.dart';
import 'package:hrms/ui/widgets/info_tile.dart';
import 'package:hrms/ui/widgets/time_line_widget.dart';
import 'package:provider/provider.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ShiftInfoPage extends StatefulWidget {
  final int shiftId;

  const ShiftInfoPage({Key? key, required this.shiftId}) : super(key: key);

  @override
  State<ShiftInfoPage> createState() => _ShiftInfoPageState();
}

class _ShiftInfoPageState extends State<ShiftInfoPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
          () => context.read<ShiftInfoViewModel>().loadShift(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${LocaleKeys.shift_label.tr()} №${widget.shiftId}',
          style: HRMSStyles.appBarTextStyle,
        ),
      ),
      body: const ShiftInfoBody(),
    );
  }
}

class ShiftInfoBody extends StatelessWidget {
  const ShiftInfoBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInitializing =
        context.watch<ShiftInfoViewModel>().data.isInitializing;
    return isInitializing
        ? InfoShimmerWidget(enabled: isInitializing)
        : const ShiftInfoColumn();
  }
}

class ShiftInfoColumn extends StatelessWidget {
  const ShiftInfoColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shift = context.select(
          (ShiftInfoViewModel model) => model.data.shift,
    );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Column(
          children: <Widget>[
            InfoTile(label: LocaleKeys.full_name_label.tr(), labelInfo: '${shift!.person!.lastName} ${shift.person!.firstName} ${shift.person!.fatherName}'),
            InfoTile(
              label: LocaleKeys.from_which_branch.tr(),
              labelInfo: shift.fromBranch.nameRu ?? shift.fromBranch.nameUz ?? '',
            ),
            InfoTile(
              label: LocaleKeys.from_position_text.tr(),
              labelInfo: shift.fromJobPosition.nameRu ?? shift.fromJobPosition.nameUz ?? '',
            ),
            InfoTile(
              label: LocaleKeys.to_which_branch.tr(),
              labelInfo: shift.toBranch.nameRu ?? shift.fromBranch.nameUz ?? '',
            ),
            InfoTile(
              label: LocaleKeys.to_which_position.tr(),
              labelInfo: shift.toJobPosition.nameRu ?? shift.fromJobPosition.nameUz ?? '',
            ),
            InfoTile(label: LocaleKeys.experience_label.tr(), labelInfo: shift.experience),
            InfoTile(label: LocaleKeys.mistakes_label.tr() + ':', labelInfo: shift.violations),
            InfoTile(label: LocaleKeys.achievements.tr() + ':', labelInfo: shift.accomplishments),
            InfoTile(label: LocaleKeys.reasons_label.tr() + ':', labelInfo: shift.goal),
            InfoTile(label: LocaleKeys.status_text.tr(), labelInfo: shift.state.nameRu!),
            InfoTile(label: LocaleKeys.director_name_label.tr(), labelInfo: shift.creator.lastName + ' ' + shift.creator.firstName),
            if (isCan('show-comment-message'))
              TimeLineComments(activities: shift.activities)
          ],
        ),
      ),
    );
  }
}
