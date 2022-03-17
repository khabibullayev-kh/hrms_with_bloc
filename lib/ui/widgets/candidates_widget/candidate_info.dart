import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hrms/blocs/candidates/candidate_info_mvvm.dart';
import 'package:hrms/blocs/candidates/candidates_bloc.dart';
import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/models/region_district/district.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/ui/widgets/info_shimmer_widget.dart';
import 'package:hrms/ui/widgets/info_tile.dart';
import 'package:hrms/ui/widgets/reusable_circular_progress_indicator.dart';
import 'package:hrms/ui/widgets/time_line_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class CandidateInfoPage extends StatefulWidget {
  final CandidatesBloc bloc;

  const CandidateInfoPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<CandidateInfoPage> createState() => _CandidateInfoPageState();
}

class _CandidateInfoPageState extends State<CandidateInfoPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
      () => context.read<CandidateInfoViewModel>().loadCandidateInfo(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (
            BuildContext context,
            bool innerBoxIsScrolled,
          ) =>
              [const _CustomAppBar()],
          body: _CandidateBody(widget: widget),
        ));
  }
}

class _CandidateBody extends StatelessWidget {
  const _CandidateBody({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final CandidateInfoPage widget;

  @override
  Widget build(BuildContext context) {
    final isInitializing =
        context.watch<CandidateInfoViewModel>().data.isInitializing;
    return !isInitializing
        ? _CandidateInfoBody(
            bloc: widget.bloc,
          )
        : InfoShimmerWidget(enabled: isInitializing);
  }
}

class _CandidateInfoBody extends StatelessWidget {
  final CandidatesBloc bloc;

  const _CandidateInfoBody({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const CandidateHeader(),
          const SizedBox(height: 16),
          const _CandidateFIOWidget(),
          const SizedBox(height: 16),
          _ActionRowWidget(bloc: bloc),
          const SizedBox(height: 16),
          const _InfoColumnWidget()
        ],
      ),
    );
  }
}

class _ActionRowWidget extends StatelessWidget {
  final CandidatesBloc bloc;

  const _ActionRowWidget({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CandidateInfoViewModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1, color: Colors.grey),
        ),
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              if ((model.data.candidate.state!.id == 13 ||
                      model.data.candidate.state!.id == 14 ||
                      model.data.candidate.state!.id == 15) &&
                  isCan('update-candidate'))
                ActionItem(
                    iconData: Icons.edit,
                    onTap: () async {
                      final result = await Navigator.pushNamed(context,
                          MainNavigationRouteNames.editCandidatesScreen,
                          arguments: model.data.candidate.id);
                      if (result == true) {
                        bloc.add(CandidatesReloadEvent(context));
                        model.loadCandidateInfo(context);
                      }
                    }),
              ActionItem(
                iconData: Icons.message,
                onTap: () async {
                  if (Platform.isAndroid) {
                    final uri =
                        'sms:${model.data.candidate.phone}?body=Ассалому%20алайкум';
                    await launch(uri);
                  } else if (Platform.isIOS) {
                    // iOS
                    final uri =
                        'sms:${model.data.candidate.phone}&body=Ассалому%20алайкум';
                    await launch(uri);
                  }
                },
              ),
              ActionItem(
                  iconData: Icons.call,
                  onTap: () {
                    launch("tel://${model.data.candidate.phone}");
                  }),
              if (model.data.candidate.canChangeState)
                ActionItem(
                    iconData: Icons.navigate_next_rounded,
                    onTap: () async {
                      final result = await Navigator.pushNamed(context,
                          MainNavigationRouteNames.changeStatusCandidatesScreen,
                          arguments: model.data.candidate);
                      if (result == true) {
                        bloc.add(CandidatesReloadEvent(context));
                        model.loadCandidateInfo(context);
                      }
                    }),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoColumnWidget extends StatelessWidget {
  const _InfoColumnWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final candidate = context.watch<CandidateInfoViewModel>().data.candidate;
    initializeDateFormatting('ru_RU', null);
    late DateFormat _dateFormat = DateFormat.yMMMMd('ru_RU');
    final dateOfBirth = _dateFormat.format(candidate.dateOfBirth!);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          InfoTile(
            label: LocaleKeys.full_name_label.tr(),
            labelInfo:
                '${candidate.firstName} ${candidate.lastName} ${candidate.fatherName}',
          ),
          if (candidate.sex != null)
            InfoTile(
                label: LocaleKeys.sex.tr(),
                labelInfo: candidate.sex == 'female'
                    ? LocaleKeys.woman.tr()
                    : LocaleKeys.man.tr()),
          InfoTile(
            label: LocaleKeys.branch_text.tr(),
            labelInfo: getStringAsync(LANG) == 'ru' ? '${candidate.branch.nameRu}' : '${candidate.branch.nameUz}',
          ),
          InfoTile(
            label: LocaleKeys.date_of_birth_label.tr(),
            labelInfo: dateOfBirth,
          ),
          if (candidate.maritalStatus != null && candidate.sex != null)
            InfoTile(
              label: LocaleKeys.family_status.tr(),
              labelInfo: ifMarried(candidate.maritalStatus!, candidate.sex!),
            ),
          InfoTile(
            label: LocaleKeys.is_student.tr(),
            labelInfo: candidate.isStudent == 'correspondence'
                ? LocaleKeys.zaochniy_text.tr()
                : candidate.isStudent == '0'
                ? LocaleKeys.yes_text.tr() : LocaleKeys.no_text.tr(),
          ),
          InfoTile(
            label: LocaleKeys.phone_number_labal.tr(),
            labelInfo: '${candidate.phone}',
          ),
          InfoTile(
            label: LocaleKeys.additional_phone_label.tr(),
            labelInfo: '${candidate.additionalPhone}',
          ),
          InfoTile(
            label: LocaleKeys.education_level_label.tr(),
            labelInfo: '${candidate.education?.nameRu}',
          ),
          InfoTile(
            label: LocaleKeys.preiod_of_study.tr(),
            labelInfo: '${candidate.periodOfStudy}',
          ),
          InfoTile(
            label: LocaleKeys.speciality_label.tr(),
            labelInfo: '${candidate.specialty}',
          ),
          InfoTile(
            label: LocaleKeys.experience_label.tr(),
            labelInfo: '${candidate.currentWork}',
          ),
          InfoTile(
            label: LocaleKeys.computer_skills_label.tr(),
            labelInfo: getActivities(candidate.shortSkills!),
          ),
          InfoTile(
            label: LocaleKeys.language_knowledge_label.tr(),
            labelInfo: getActivities(candidate.shortLanguages!),
          ),
          InfoTile(
            label: LocaleKeys.address_text.tr(),
            labelInfo: '${candidate.address}',
          ),
          InfoTile(
            label: LocaleKeys.region_text.tr(),
            labelInfo: getStringAsync(LANG) == 'ru' ? '${candidate.region.nameRu}' : '${candidate.region.nameUz}',
          ),
          InfoTile(
            label: LocaleKeys.district_text.tr(),
            labelInfo: getStringAsync(LANG) == 'ru' ? '${candidate.district!.nameRu}' : '${candidate.district!.nameUz}',
          ),
          InfoTile(
            label: LocaleKeys.ad_source_label.tr(),
            labelInfo: getStringAsync(LANG) == 'ru' ? candidate.adSource!.nameRu : candidate.adSource!.nameUz,
          ),
          InfoTile(
            label: LocaleKeys.position_text.tr(),
            labelInfo: candidate.vacancy?.jobPositionNameRu ?? candidate.vacancy?.jobPositionNameUz ?? '-',
          ),
          InfoTile(
            label: LocaleKeys.height_and_weight.tr(),
            labelInfo: candidate.heightWeight ?? '-',
          ),
          InfoTile(
            label: LocaleKeys.is_uzb_citizen.tr(),
            labelInfo: candidate.citizenship == '1' ? LocaleKeys.yes_text.tr() : LocaleKeys.no_text.tr(),
          ),
          InfoTile(
            label: LocaleKeys.is_worked_before.tr(),
            labelInfo: candidate.isWorkedBefore == '1' ? LocaleKeys.yes_text.tr() : LocaleKeys.no_text.tr(),
          ),
          InfoTile(
            label: LocaleKeys.salary_lable.tr(),
            labelInfo: candidate.desiredSalary ?? '',
          ),
          InfoTile(
            label: LocaleKeys.close_relatives.tr(),
            labelInfo: candidate.relatives ?? '',
          ),
          InfoTile(
            label: LocaleKeys.comments_label.tr(),
            labelInfo: candidate.candidateNote ?? '',
          ),
          if (isCan('show-comment-message'))
            TimeLineComments(activities: candidate.activities!)
        ],
      ),
    );
  }

  ifMarried(String maritalStatus, String sex) {
    if (maritalStatus == 'not_married') {
      return sex == 'female' ? 'Не замужем' : 'Не женат';
    } else {
      return sex == 'male' ? 'Женат' : 'Замужем';
    }
  }

  getActivities(Short activities) {
    String lang = '';
    for (District i in activities.data!) {
      if (i == activities.data!.last) {
        lang += '${i.name}';
      } else {
        lang += '${i.name} \n';
      }
    }
    return lang;
  }
}

class CandidateInfoArguments {
  final int id;
  final CandidatesBloc bloc;

  CandidateInfoArguments({required this.id, required this.bloc});
}

class ActionItem extends StatelessWidget {
  final IconData iconData;
  final Function() onTap;

  const ActionItem({
    Key? key,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          color: HRMSColors.green,
          shape: BoxShape.circle,
        ),
        child: Icon(iconData, color: Colors.white),
      ),
    );
  }
}

class _CandidateFIOWidget extends StatelessWidget {
  const _CandidateFIOWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final candidate = context.watch<CandidateInfoViewModel>().data.candidate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.yellow,
          child: Text(
            (getStringAsync(LANG) == 'ru' ? candidate.vacancy?.jobPositionNameRu : candidate.vacancy?.jobPositionNameUz) ??
                (getStringAsync(LANG) == 'ru' ? candidate.jobPosition.nameRu! : candidate.jobPosition.nameUz!),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${candidate.lastName} ${candidate.firstName}\n${candidate.fatherName}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            height: 1.3,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class CandidateHeader extends StatelessWidget {
  const CandidateHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: const [
        _CandidateImageWidget(),
        Positioned(
          bottom: 0,
          child: _StateBoxWidget(),
        )
      ],
    );
  }
}

class _StateBoxWidget extends StatelessWidget {
  const _StateBoxWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CandidateInfoViewModel>().data.candidate.state;
    return state == null
        ? const SizedBox()
        : Container(
            width: MediaQuery.of(context).size.width / 2.5,
            decoration: BoxDecoration(
              color: statusColor(state.id),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: Text(
                  getStringAsync(LANG) == 'ru' ? state.nameRu : state.nameUz,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
  }
}

class _CandidateImageWidget extends StatelessWidget {
  const _CandidateImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = context.watch<CandidateInfoViewModel>().data.candidate.photoUrl;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: CachedNetworkImage(
          height: MediaQuery.of(context).size.height / 2.5,
          imageUrl: url!,
          fit: BoxFit.fill,
          placeholder: (context, url) {
            return const ColoredBox(color: Colors.white);
          },
          errorWidget: (error, context, url) {
            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: const ReusableCircularIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = context.watch<CandidateInfoViewModel>().data;
    return SliverAppBar(
      floating: true,
      snap: true,
      centerTitle: true,
      title: data.isInitializing
          ? const Text('Загрузка...')
          : Text(
              '${LocaleKeys.candidate_label.tr()} №${data.candidate.id}',
              style: const TextStyle(color: Colors.black),
            ),
    );
  }
}
