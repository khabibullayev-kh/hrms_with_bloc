import 'package:flutter/material.dart';
import 'package:hrms/blocs/branches/branch_info_mvvm.dart';
import 'package:hrms/blocs/shifts/shift_info_mvvm.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/info_shimmer_widget.dart';
import 'package:hrms/ui/widgets/info_tile.dart';
import 'package:hrms/ui/widgets/shimmer_widget.dart';
import 'package:hrms/ui/widgets/time_line_widget.dart';
import 'package:provider/provider.dart';

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
          'Перевод №${widget.shiftId}',
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
            InfoTile(label: 'ФИО', labelInfo: '${shift!.person!.lastName} ${shift.person!.firstName} ${shift.person!.fatherName}'),
            InfoTile(
              label: 'С какого филиала',
              labelInfo: shift.fromBranch.nameRu ?? shift.fromBranch.nameUz ?? '',
            ),
            InfoTile(
              label: 'C какой должности',
              labelInfo: shift.fromJobPosition.nameRu ?? shift.fromJobPosition.nameUz ?? '',
            ),
            InfoTile(
              label: 'На какой филиал',
              labelInfo: shift.toBranch.nameRu ?? shift.fromBranch.nameUz ?? '',
            ),
            InfoTile(
              label: 'На какую должность',
              labelInfo: shift.toJobPosition.nameRu ?? shift.fromJobPosition.nameUz ?? '',
            ),
            InfoTile(label: 'Опыт', labelInfo: shift.experience),
            InfoTile(label: 'Ошибки во время работы', labelInfo: shift.violations),
            InfoTile(label: 'Достижения', labelInfo: shift.accomplishments),
            InfoTile(label: 'Причина перевода', labelInfo: shift.goal),
            InfoTile(label: 'Статус', labelInfo: shift.state.nameRu!),
            InfoTile(label: 'Заказчик', labelInfo: shift.creator.lastName + ' ' + shift.creator.firstName),
            if (isCan('show-comment-message'))
              TimeLineComments(activities: shift.activities)
          ],
        ),
      ),
    );
  }
}
