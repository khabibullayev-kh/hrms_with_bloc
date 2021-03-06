import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hrms/blocs/shifts/shifts_bloc.dart';
import 'package:hrms/blocs/vacancies/vacancies_bloc.dart';
import 'package:hrms/data/models/vacancy/vacancy.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/navigation/main_navigation.dart';

class VacancyItem extends StatelessWidget {
  final Vacancy vacancy;
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
  final Vacancy vacancy;
  final VacanciesBloc bloc;

  const _VacancyItem({Key? key, required this.vacancy, required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCan('update-vacancy')
        ? _SlideItem(
            vacancy: vacancy,
            bloc: bloc,
          )
        : _VacancyItemBody(
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
  final Vacancy vacancy;

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
                        const Text(
                          '????????????: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(
                            vacancy.branch?.nameRu ??
                                vacancy.branch?.nameUz ??
                                '',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '??????????: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(vacancy.department?.nameRu ??
                              vacancy.department?.nameUz ??
                              ''),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '??????????????????: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(
                            vacancy.jobPosition?.nameRu ??
                                vacancy.jobPosition?.nameUz ??
                                '',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '????????????????????: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Text(
                            vacancy.quantity.toString(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '????????????: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: statusColor(vacancy.state!.id),
                              ),
                              child: Text(
                                  vacancy.state?.nameRu ??
                                      vacancy.state?.nameUz ??
                                      vacancy.state?.name ??
                                      '',
                                  style: TextStyle(
                                      color: vacancy.state!.id == 22
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
  final Vacancy vacancy;
  final VacanciesBloc bloc;

  const _SlideItem({
    Key? key,
    required this.vacancy,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var commentItem = SlidableAction(
      label: '????????????????',
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
