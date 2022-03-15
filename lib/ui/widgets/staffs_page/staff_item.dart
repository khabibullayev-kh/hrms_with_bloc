import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hrms/blocs/staffs/dismiss_staff_mvvm.dart';
import 'package:hrms/blocs/staffs/staffs_bloc.dart';
import 'package:hrms/data/models/staffs/staff.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/ui/widgets/reusable_bottom_sheet.dart';
import 'package:hrms/ui/widgets/staffs_page/dismiss_staff_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class StaffItem extends StatelessWidget {
  final Staff staff;
  final StaffsBloc bloc;

  const StaffItem({
    Key? key,
    required this.staff,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _StaffItem(staff: staff, bloc: bloc);
  }
}

class _StaffItem extends StatelessWidget {
  final Staff staff;
  final StaffsBloc bloc;

  const _StaffItem({Key? key, required this.staff, required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SlideItem(
      staff: staff,
      bloc: bloc,
    );
  }
}

class _StaffItemBody extends StatelessWidget {
  const _StaffItemBody({
    Key? key,
    required this.staff,
    required this.bloc,
  }) : super(key: key);

  final StaffsBloc bloc;
  final Staff staff;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // onTap: () => Navigator.pushNamed(
        //     context, MainNavigationRouteNames.shiftsInfoScreen,
        //     arguments: staff.id),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    staff.person != null
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ФИО: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Flexible(
                                child: Text(
                                  staff.person!.lastName! +
                                      ' ' +
                                      staff.person!.firstName!,
                                ),
                              ),
                            ],
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Text(
                              'Вакант',
                              style: TextStyle(color: Colors.white),
                            )),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Филиал: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(
                            staff.branch.toString(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Должность: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(staff.jobPosition.toString()),
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

class StaffsArguments {
  final int id;
  final StaffsArguments bloc;

  StaffsArguments({required this.id, required this.bloc});
}

class _SlideItem extends StatelessWidget {
  final Staff staff;
  final StaffsBloc bloc;

  const _SlideItem({
    Key? key,
    required this.staff,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deleteItem = SlidableAction(
      label: 'Удалить',
      backgroundColor: Colors.red,
      icon: Icons.delete,
      onPressed: (context) async {
        final result = await showConfirmDialogCustom(
          context,
          title: "Удалить штат №${staff.id}",
          negativeText: 'Отменить',
          positiveText: 'Удалить',
          dialogType: DialogType.DELETE,
          onAccept: (context) {
            Navigator.pop(context, true);
          },
        );
        if (result == true) {
          bloc.add(StaffsDeleteEvent(staff.id, context));
        }
      },
    );
    var editItem = SlidableAction(
      label: 'Редактировать',
      backgroundColor: HRMSColors.green,
      icon: Icons.edit,
      onPressed: (context) async {
        final result = await Navigator.pushNamed(
            context, MainNavigationRouteNames.editStaffScreen,
            arguments: staff.id);
        if (result == true) {
          bloc.add(const StaffsReloadEvent());
        }
      },
    );
    var dismissItem = SlidableAction(
      label: 'Уволить',
      backgroundColor: Colors.red,
      icon: Icons.clear,
      onPressed: (context) async {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          builder: (context) {
            return ChangeNotifierProvider(
              create: (_) => DismissStaffViewModel(
                staffId: staff.id,
                bloc: bloc,
              ),
              child: const ReusableBottomSheet(children: DismissStaffWidget()),
            );
          },
        );
      },
    );
    List<Widget> items = [];
    if (staff.person != null && isCan('dismiss-employee')) {
      items.add(dismissItem);
    }
    if (isCan('update-staff')) {
      items.add(editItem);
    }

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: items,
      ),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (isCan('delete-staff')) deleteItem,
        ],
      ),
      child: _StaffItemBody(staff: staff, bloc: bloc),
    );
  }
}

class DismissItems {
  final int staffId;
  final StaffsBloc bloc;

  DismissItems({
    required this.staffId,
    required this.bloc,
  });
}
