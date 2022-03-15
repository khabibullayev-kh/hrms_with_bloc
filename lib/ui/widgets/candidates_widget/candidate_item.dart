import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hrms/blocs/candidates/candidates_bloc.dart';
import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/ui/widgets/candidates_widget/candidate_info.dart';

class CandidateItem extends StatelessWidget {
  final Candidate candidate;
  final CandidatesBloc bloc;

  const CandidateItem({
    Key? key,
    required this.candidate,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CandidateItem(
      candidate: candidate,
      bloc: bloc,
    );
  }
}

class _CandidateItem extends StatelessWidget {
  final Candidate candidate;
  final CandidatesBloc bloc;

  const _CandidateItem({Key? key, required this.candidate, required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SlideItem(
      candidate: candidate,
      bloc: bloc,
    );
  }
}

class _CandidatesItemBody extends StatelessWidget {
  const _CandidatesItemBody({
    Key? key,
    required this.candidate,
    required this.bloc,
  }) : super(key: key);

  final CandidatesBloc bloc;
  final Candidate candidate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
          context, MainNavigationRouteNames.candidateInfoScreen,
          arguments: CandidateInfoArguments(id: candidate.id, bloc: bloc)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(candidate.lastName + ' ' + candidate.firstName),
                  const SizedBox(height: 4),
                  Text(candidate.vacancy?.jobPositionNameRu ??
                      candidate.jobPosition.nameRu!),
                  const SizedBox(height: 4),
                  Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: statusColor(candidate.state!.id),
                      ),
                      child: Text(
                        candidate.state!.nameRu,
                        style: TextStyle(
                            color: candidate.state!.id != 17
                                ? Colors.white
                                : Colors.black),
                      )),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  width: 29,
                  height: 29,
                  decoration: BoxDecoration(
                    color: isCan('show-hot-candidates') &&
                            DateTime.now()
                                    .difference(candidate.createdAt)
                                    .inDays >=
                                14 &&
                            candidate.state!.id == 13
                        ? Colors.red
                        : HRMSColors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.white,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class _SlideItem extends StatelessWidget {
  final Candidate candidate;
  final CandidatesBloc bloc;

  const _SlideItem({
    Key? key,
    required this.candidate,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var editItem = SlidableAction(
      label: 'Редактировать',
      backgroundColor: HRMSColors.green,
      foregroundColor: Colors.white,
      icon: Icons.edit,
      onPressed: (context) async {
        final result = await Navigator.pushNamed(
            context, MainNavigationRouteNames.editCandidatesScreen,
            arguments: candidate.id);
        if (result == true) {
          bloc.add(CandidatesReloadEvent(context));
        }
      },
    );
    var commentItem = SlidableAction(
      label: 'Изменить статус',
      backgroundColor: Colors.blueAccent,
      icon: Icons.comment,
      onPressed: (context) async {
        final result = await Navigator.pushNamed(
            context, MainNavigationRouteNames.changeStatusCandidatesScreen,
            arguments: candidate);
        if (result == true) {
          bloc.add(CandidatesReloadEvent(context));
        }
      },
    );
    List<Widget> items = [];
    if ((candidate.state!.id == 13 ||
            candidate.state!.id == 14 ||
            candidate.state!.id == 15) &&
        isCan('update-candidate')) {
      items.add(editItem);
    }
    if (candidate.canChangeState) {
      items.add(commentItem);
    }
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: items,
      ),
      child: _CandidatesItemBody(candidate: candidate, bloc: bloc),
    );
  }
}
