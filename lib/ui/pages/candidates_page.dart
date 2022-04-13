import 'dart:async';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/blocs/candidates/candidates_bloc.dart';
import 'package:hrms/blocs/pagination_bloc.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/icons.dart';
import 'package:hrms/ui/widgets/candidates_widget/candidate_item.dart';
import 'package:hrms/ui/widgets/candidates_widget/filter_candidates_widget.dart';
import 'package:hrms/ui/widgets/error_widget.dart';
import 'package:hrms/ui/widgets/nothing_found_widget.dart';
import 'package:hrms/ui/widgets/pagination_widget.dart';
import 'package:hrms/ui/widgets/reusable_bottom_sheet.dart';
import 'package:hrms/ui/widgets/reusable_circular_progress_indicator.dart';
import 'package:hrms/ui/widgets/side_bar.dart';
import 'package:new_version/new_version.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class CandidatesPage extends StatefulWidget {
  const CandidatesPage({Key? key}) : super(key: key);

  @override
  State<CandidatesPage> createState() => _CandidatesPageState();
}

class _CandidatesPageState extends State<CandidatesPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CandidatesBloc>(context).add(
      CandidatesPageInitializeEvent(context),
    );
    final newVersion = NewVersion();
    newVersion.showAlertIfNecessary(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CandidatesBloc>();
    final sum = bloc.state.candidatesContainer.hotCandidatesCount;
    final isHotCandidates = bloc.state.isShowingHotCandidates;
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.candidates_label.tr()),
        actions: [
          if (sum != 0 && isCan('show-hot-candidates'))
            Badge(
              position: BadgePosition.topEnd(top: -1, end: -2),
              badgeContent: Text(
                bloc.state.candidatesContainer.hotCandidatesCount.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: IconButton(
                splashRadius: 24,
                padding: const EdgeInsets.all(0),
                tooltip: 'Показать горящих кандидатов',
                onPressed: () async {
                  bloc.add(ShowHotCandidatesEvent(
                      bloc.state.isShowingHotCandidates, context));
                },
                icon: Icon(
                  Icons.local_fire_department,
                  size: 28,
                  color: isHotCandidates ? Colors.red : Colors.grey,
                ),
              ),
            ),
          IconButton(
            tooltip: 'Фильтр',
            onPressed: () async {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                builder: (context) {
                  return ReusableBottomSheet(
                    children: FilterCandidatesWidget(bloc: bloc),
                  );
                },
              );
            },
            icon: SvgPicture.asset(HRMSIcons.filter),
          ),
        ],
      ),
      drawer: const SideBar(),
      body: const MainPageBody(),
    );
  }
}

class MainPageBody extends StatelessWidget {
  const MainPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<CandidatesBloc, CandidatesState>(
          builder: (context, state) {
            switch (state.candidatesStatus) {
              case CandidatesStatus.loading:
                return const Center(child: ReusableCircularIndicator());
              case CandidatesStatus.success:
                return const _CandidatesListView();
              case CandidatesStatus.nothingFound:
                return const Center(
                  child: NothingFoundWidget(
                    text: 'Кандидатов не найдено',
                  ),
                );
              case CandidatesStatus.failure:
              default:
                return const Center(child: ErrorWidgetBody());
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
          child: SearchWidget(searchFieldFocusNode: FocusNode()),
        ),
      ],
    );
  }
}

class _CandidatesListView extends StatelessWidget {
  const _CandidatesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CandidatesBloc>();
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 80, bottom: 16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: bloc.state.candidatesContainer.candidates.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, item) {
              return CandidateItem(
                candidate: bloc.state.candidatesContainer.candidates[item],
                bloc: bloc,
              );
            },
            separatorBuilder: (context, item) {
              return const Divider(
                height: 1,
                thickness: 1.5,
                indent: 50,
                endIndent: 50,
              );
            },
          ),
          const PaginationRow(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class PaginationRow extends StatelessWidget {
  const PaginationRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CandidatesBloc>();
    final currentPage = bloc.state.candidatesContainer.currentPage;
    final totalPage = bloc.state.candidatesContainer.totalPage;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: PaginationBloc.paginationWidget(
        currentPage,
        totalPage,
      )
          .map((pages) => PaginationButtons(
                onTap: () {
                  if (PaginationBloc.isNumeric(pages)) {
                    bloc.add(
                      CandidatesFetchEvent(
                        query: bloc.state.searchQuery,
                        page: int.parse(pages),
                        sex: bloc.state.sex,
                        jobPositionId: bloc.state.jobPositionId,
                        stateId: bloc.state.statesId,
                        regionId: bloc.state.regionId,
                        branchId: bloc.state.branchId,
                        context: context,
                      ),
                    );
                  }
                },
                currentPage: bloc.state.currentPage.toString(),
                pages: pages,
              ))
          .toList(),
    );
  }
}

class SearchWidget extends StatefulWidget {
  final FocusNode searchFieldFocusNode;

  const SearchWidget({
    Key? key,
    required this.searchFieldFocusNode,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();
  bool haveSearchedText = false;
  Timer? searchDebounce;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CandidatesBloc>();
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        focusNode: widget.searchFieldFocusNode,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontSize: 20,
        ),
        onChanged: (onChanged) {
          searchDebounce?.cancel();
          searchDebounce = Timer(const Duration(milliseconds: 500), () async {
            bloc.add(
              CandidatesFetchEvent(
                query: onChanged,
                page: 1,
                sex: bloc.state.sex,
                jobPositionId: bloc.state.jobPositionId,
                stateId: bloc.state.statesId,
                regionId: bloc.state.regionId,
                branchId: bloc.state.branchId,
                context: context,
              ),
            );
          });
          final haveText = controller.text.isNotEmpty;
          if (haveSearchedText != haveText) {
            setState(() {
              haveSearchedText = haveText;
            });
          }
        },
        cursorColor: HRMSColors.green,
        textInputAction: TextInputAction.search,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
            size: 24,
          ),
          suffix: GestureDetector(
            onTap: () {
              controller.clear();
              bloc.add(const CandidatesResetLoadEvent('', 1));
              final haveText = controller.text.isNotEmpty;
              if (haveSearchedText != haveText) {
                setState(() {
                  haveSearchedText = haveText;
                });
              }
            },
            child: const Icon(
              Icons.close,
              color: Colors.grey,
              size: 24,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: HRMSColors.green,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: haveSearchedText
                ? const BorderSide(color: HRMSColors.green, width: 2)
                : const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
