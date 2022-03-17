import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hrms/blocs/shifts/shifts_bloc.dart';
import 'package:hrms/data/models/shifts/shift.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nb_utils/nb_utils.dart';

class ShiftItem extends StatelessWidget {
  final Shift shift;
  final ShiftsBloc bloc;

  const ShiftItem({
    Key? key,
    required this.shift,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ShiftItem(shift: shift, bloc: bloc);
  }
}

class _ShiftItem extends StatelessWidget {
  final Shift shift;
  final ShiftsBloc bloc;

  const _ShiftItem({Key? key, required this.shift, required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SlideItem(
      shift: shift,
      bloc: bloc,
    );
  }
}

class _ShiftItemBody extends StatelessWidget {
  const _ShiftItemBody({
    Key? key,
    required this.shift,
    required this.bloc,
  }) : super(key: key);

  final ShiftsBloc bloc;
  final Shift shift;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.pushNamed(
            context, MainNavigationRouteNames.shiftsInfoScreen,
            arguments: shift.id),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${LocaleKeys.full_name_label.tr()} ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(
                            shift.person == null
                                ? shift.fullName!
                                : shift.person!.lastName! +
                                    ' ' +
                                    shift.person!.firstName!,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${LocaleKeys.from_position_text.tr()} ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(
                            getStringAsync(LANG) == 'ru' ? '${shift.fromJobPosition.nameRu}' :
                                '${shift.fromJobPosition.nameUz}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${LocaleKeys.to_position.tr()} ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(
                            getStringAsync(LANG) == 'ru' ? '${shift.toJobPosition.nameRu}' :
                            '${shift.toJobPosition.nameUz}'
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${LocaleKeys.status_text.tr()} ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: statusColor(shift.state.id),
                              ),
                              child: Text(
                                  getStringAsync(LANG) == 'ru' ? shift.state.nameRu! : shift.state.nameUz!,
                                  style: TextStyle(
                                      color: shift.state.id == 22
                                          ? Colors.black
                                          : Colors.white))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   SlideTopRoute(
                      //     page: ShiftInfoScreen(
                      //       shiftId: widget.shiftId,
                      //     ),
                      //   ),
                      // );
                    },
                    child: Container(
                      width: 29,
                      height: 29,
                      decoration: const BoxDecoration(
                        color: HRMSColors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}

class ShiftsInfoArguments {
  final int id;
  final ShiftsBloc bloc;

  ShiftsInfoArguments({required this.id, required this.bloc});
}

class _SlideItem extends StatelessWidget {
  final Shift shift;
  final ShiftsBloc bloc;

  const _SlideItem({
    Key? key,
    required this.shift,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var commentItem = SlidableAction(
      label: 'Изменить статус',
      backgroundColor: Colors.blueAccent,
      icon: Icons.comment,
      onPressed: (context) async {
        final result = await Navigator.pushNamed(
            context, MainNavigationRouteNames.changeShiftsStateScreen,
            arguments: shift);
        if (result == true) {
          bloc.add(ShiftsReloadEvent(context));
        }
      },
    );
    List<Widget> items = [];
    if (shift.canChangeState) {
      items.add(commentItem);
    }
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: items,
      ),
      child: _ShiftItemBody(shift: shift, bloc: bloc),
    );
  }
}
