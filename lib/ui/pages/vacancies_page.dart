import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/blocs/pagination_bloc.dart';
import 'package:hrms/blocs/vacancies/vacancies_bloc.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/icons.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/ui/widgets/error_widget.dart';
import 'package:hrms/ui/widgets/nothing_found_widget.dart';
import 'package:hrms/ui/widgets/pagination_widget.dart';
import 'package:hrms/ui/widgets/reusable_bottom_sheet.dart';
import 'package:hrms/ui/widgets/reusable_circular_progress_indicator.dart';
import 'package:hrms/ui/widgets/side_bar.dart';
import 'package:hrms/ui/widgets/vacancies_widget/filter_vacancies_widget.dart';
import 'package:hrms/ui/widgets/vacancies_widget/vacancy_item.dart';

class VacanciesPage extends StatefulWidget {
  const VacanciesPage({Key? key}) : super(key: key);

  @override
  State<VacanciesPage> createState() => _VacanciesPageState();
}

class _VacanciesPageState extends State<VacanciesPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<VacanciesBloc>(context).add(
      VacanciesPageInitializeEvent(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<VacanciesBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вакансии'),
        actions: [
          if (isCan('create-vacancy'))
            IconButton(
              tooltip: 'Добавить перевод',
              onPressed: () async => pushToAddScreen(bloc),
              icon: Image.asset(HRMSIcons.add),
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
                    children: FilterVacanciesWidget(bloc: bloc),
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

  Future<void> pushToAddScreen(VacanciesBloc bloc) async {
    final result = await Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addVacancyScreen,
    );
    if (result == true) {
      bloc.add(
        VacanciesReloadEvent(context),
      );
    }
  }
}

class MainPageBody extends StatelessWidget {
  const MainPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<VacanciesBloc, VacanciesState>(
          builder: (context, state) {
            switch (state.vacanciesStatus) {
              case VacanciesStatus.loading:
                return const Center(child: ReusableCircularIndicator());
              case VacanciesStatus.success:
                return const _VacanciesListView();
              case VacanciesStatus.nothingFound:
                return const Center(
                  child: NothingFoundWidget(
                    text: 'Вакансии не найдено',
                  ),
                );
              case VacanciesStatus.failure:
              default:
                return const Center(child: ErrorWidgetBody());
            }
          },
        ),
        const SumWidget(),
        // Padding(
        //   padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
        //   child: SearchWidget(searchFieldFocusNode: FocusNode()),
        // ),
      ],
    );
  }
}

class SumWidget extends StatelessWidget {
  const SumWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sum = context
        .select((VacanciesBloc bloc) => bloc.state.vacanciesContainer.sum);
    return (sum == '' || sum == '0' || sum == '1')
        ? const SizedBox()
        : Container(
            color: HRMSColors.green,
            height: 24,
            width: double.infinity,
            child: Center(
              child: Text(
                'Количество вакансии: $sum',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
  }
}

class _VacanciesListView extends StatelessWidget {
  const _VacanciesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<VacanciesBloc>();
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 25, bottom: 16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: bloc.state.vacanciesContainer.vacancies.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, item) {
              return VacancyItem(
                vacancy: bloc.state.vacanciesContainer.vacancies[item],
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
    final bloc = context.read<VacanciesBloc>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: PaginationBloc.paginationWidget(
        bloc.state.vacanciesContainer.currentPage,
        bloc.state.vacanciesContainer.totalPage,
      )
          .map((pages) => PaginationButtons(
                onTap: () {
                  if (PaginationBloc.isNumeric(pages)) {
                    bloc.add(
                      VacanciesFetchEvent(
                        query: bloc.state.searchQuery,
                        page: int.parse(pages),
                        recruiterId: bloc.state.recruiterId,
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
    final bloc = context.read<VacanciesBloc>();
    return TextField(
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
            VacanciesFetchEvent(
              query: onChanged,
              page: 1,
              jobPositionId: bloc.state.jobPositionId,
              regionId: bloc.state.regionId,
              recruiterId: bloc.state.recruiterId,
              stateId: bloc.state.statesId,
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
            bloc.add(const VacanciesResetLoadEvent());
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
    );
  }
}
