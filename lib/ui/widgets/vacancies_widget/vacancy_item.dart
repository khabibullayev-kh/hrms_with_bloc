import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hrms/blocs/shifts/shifts_bloc.dart';
import 'package:hrms/blocs/vacancies/vacancies_bloc.dart';
import 'package:hrms/data/models/old_vacancy/vacancy.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nb_utils/nb_utils.dart';

class VacancyItem extends StatelessWidget {
  final OldVacancy vacancy;
  final VacanciesBloc bloc;

  const VacancyItem({
    Key? key,
    required this.vacancy,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _VacancyItem(vacancy: vacancy, bloc: bloc);
  }
}

class _VacancyItem extends StatelessWidget {
  final OldVacancy vacancy;
  final VacanciesBloc bloc;

  const _VacancyItem({Key? key, required this.vacancy, required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _VacancyItemBody(
      vacancy: vacancy,
      bloc: bloc,
    );
  }
}

class _VacancyItemBody extends StatelessWidget {
  const _VacancyItemBody({
    Key? key,
    required this.vacancy,
    required this.bloc,
  }) : super(key: key);

  final VacanciesBloc bloc;
  final OldVacancy vacancy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // onTap: () => Navigator.pushNamed(
        //     context, MainNavigationRouteNames.shiftsInfoScreen,
        //     arguments: vacancy.id),
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
                      '${LocaleKeys.branch_text.tr()} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        getStringAsync(LANG) == 'ru'
                            ? '${vacancy.branch}'
                            : '${vacancy.branch}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${LocaleKeys.department_label.tr()}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(getStringAsync(LANG) == 'ru'
                          ? '${vacancy.department}'
                          : '${vacancy.department}'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${LocaleKeys.position_text.tr()} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        getStringAsync(LANG) == 'ru'
                            ? '${vacancy.jobPosition}'
                            : '${vacancy.jobPosition}',
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
                          color: statusColor(vacancy.state.id),
                        ),
                        child: Text(
                          vacancy.state.nameUz ?? vacancy.state.nameRu ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (vacancy.candidate != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Рассматривается: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${vacancy.candidate?.fullName}'),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: statusColor(vacancy.candidate!.state!.id),
                            ),
                            child: Text(
                              getStringAsync(LANG) == 'ru'
                                  ? '${vacancy.candidate?.state?.nameRu}'
                                  : '${vacancy.candidate?.state?.nameUz}',
                              style: TextStyle(
                                  color: vacancy.candidate?.state?.id == 17
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          ),
                        ],
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
  final OldVacancy vacancy;
  final VacanciesBloc bloc;

  const _SlideItem({
    Key? key,
    required this.vacancy,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var commentItem = SlidableAction(
      label: 'Изменить',
      backgroundColor: HRMSColors.green,
      icon: Icons.edit,
      onPressed: (context) async {
        final result = await Navigator.pushNamed(
            context, MainNavigationRouteNames.editVacancyScreen,
            arguments: vacancy.id);
        if (result == true) {
          bloc.add(VacanciesReloadEvent(context));
        }
      },
    );
    List<Widget> items = [];
    if (isCan('update-vacancy')) {
      items.add(commentItem);
    }
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [commentItem],
      ),
      child: _VacancyItemBody(vacancy: vacancy, bloc: bloc),
    );
  }
}
