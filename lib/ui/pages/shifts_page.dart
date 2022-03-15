import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/blocs/pagination_bloc.dart';
import 'package:hrms/blocs/shifts/shifts_bloc.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/icons.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/ui/widgets/error_widget.dart';
import 'package:hrms/ui/widgets/nothing_found_widget.dart';
import 'package:hrms/ui/widgets/pagination_widget.dart';
import 'package:hrms/ui/widgets/reusable_bottom_sheet.dart';
import 'package:hrms/ui/widgets/reusable_circular_progress_indicator.dart';
import 'package:hrms/ui/widgets/shifts_widget/filter_shifts_item.dart';
import 'package:hrms/ui/widgets/shifts_widget/shift_item.dart';
import 'package:hrms/ui/widgets/side_bar.dart';
import 'package:new_version/new_version.dart';

class ShiftsPage extends StatefulWidget {
  const ShiftsPage({Key? key}) : super(key: key);

  @override
  State<ShiftsPage> createState() => _ShiftsPageState();
}

class _ShiftsPageState extends State<ShiftsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ShiftsBloc>(context).add(
      ShiftsPageInitializeEvent(context),
    );
    final newVersion = NewVersion();
    newVersion.showAlertIfNecessary(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ShiftsBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Переводы'),
        actions: [
          if (isCan('create-shift'))
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
                    children: FilterShiftsWidget(bloc: bloc),
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

  Future<void> pushToAddScreen(ShiftsBloc bloc) async {
    final result = await Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addShiftsScreen,
    );
    if (result == true) {
      bloc.add(
        ShiftsReloadEvent(context),
      );
    }
  }
}

class MainPageBody extends StatelessWidget {
  const MainPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final bloc = context.watch<ShiftsBloc>();
    return Stack(
      children: [
        BlocBuilder<ShiftsBloc, ShiftsState>(
          builder: (context, state) {
            switch (state.shiftsStatus) {
              case ShiftsStatus.loading:
                return const Center(child: ReusableCircularIndicator());
              case ShiftsStatus.success:
                return const _ShiftsListView();
              case ShiftsStatus.nothingFound:
                return const Center(
                  child: NothingFoundWidget(
                    text: 'Переводов не найдено',
                  ),
                );
              case ShiftsStatus.failure:
              default:
                return const Center(child: ErrorWidgetBody());
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
          child: SearchWidget(searchFieldFocusNode: FocusNode()),
        ),
      ],
    );
  }
}

class _ShiftsListView extends StatelessWidget {
  const _ShiftsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ShiftsBloc>();
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 80, bottom: 16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: bloc.state.shiftsContainer.shifts.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, item) {
              return ShiftItem(
                shift: bloc.state.shiftsContainer.shifts[item],
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
          PaginationBody(
            shiftsContainer: bloc.state.shiftsContainer,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class PaginationBody extends StatelessWidget {
  const PaginationBody({
    Key? key,
    required this.shiftsContainer,
  }) : super(key: key);

  final ShiftsContainer shiftsContainer;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ShiftsBloc>();
    List<String> pages = PaginationBloc.paginationWidget(
      shiftsContainer.currentPage,
      shiftsContainer.totalPage,
    );
    if (bloc.state.shiftsContainer.totalPage <= 1) {
      return const SizedBox();
    }
    return SizedBox(
      height: 40,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 32,
        child: Center(
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: pages.length,
              itemBuilder: (BuildContext context, int index) {
                return PaginationButtons(
                  onTap: () {
                    if (PaginationBloc.isNumeric(pages[index])) {
                      bloc.add(
                        ShiftsFetchEvent(
                          query: bloc.state.searchQuery,
                          page: int.parse(pages[index]),
                          toJobPositionId: bloc.state.toJobPositionsId,
                          stateId: bloc.state.statesId,
                          branchId: bloc.state.branchId,
                          context: context,
                        ),
                      );
                    }
                  },
                  currentPage: bloc.state.currentPage.toString(),
                  pages: pages[index],
                );
              }),
        ),
      ),
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
    final bloc = context.read<ShiftsBloc>();
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
            ShiftsFetchEvent(
              query: onChanged,
              page: 1,
              toJobPositionId: bloc.state.toJobPositionsId,
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
            bloc.add(const ShiftsResetLoadEvent('', 1));
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
