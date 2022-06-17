import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/blocs/pagination_bloc.dart';
import 'package:hrms/blocs/staffs/staffs_bloc.dart';
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
import 'package:hrms/ui/widgets/staffs_page/filter_staffs_page.dart';
import 'package:hrms/ui/widgets/staffs_page/staff_item.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class StaffsPage extends StatefulWidget {
  const StaffsPage({Key? key}) : super(key: key);

  @override
  State<StaffsPage> createState() => _StaffsPageState();
}

class _StaffsPageState extends State<StaffsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StaffsBloc>(context).add(
      StaffsPageInitializeEvent(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StaffsBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.staff_label.tr()),
        actions: [
          if (isCan('create-staff'))
            IconButton(
            tooltip: 'Добавить сотрудника',
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
                    children: FilterStaffsWidget(bloc: bloc),
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

  Future<void> pushToAddScreen(StaffsBloc bloc) async {
    final result = await Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addStaffScreen,
    );
    if (result == true) {
      bloc.add(const StaffsReloadEvent());
    }
  }
}

class MainPageBody extends StatelessWidget {
  const MainPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<StaffsBloc, StaffsState>(
          builder: (context, state) {
            switch (state.staffsStatus) {
              case StaffsStatus.loading:
                return const Center(child: ReusableCircularIndicator());
              case StaffsStatus.success:
                return const _StaffsListView();
              case StaffsStatus.nothingFound:
                return const Center(
                  child: NothingFoundWidget(
                    text: 'Сотрудников не найдено',
                  ),
                );
              case StaffsStatus.failure:
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

class _StaffsListView extends StatelessWidget {
  const _StaffsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<StaffsBloc>();
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 80, bottom: 16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: bloc.state.staffsContainer.staffs.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, item) {
              return StaffItem(
                staff: bloc.state.staffsContainer.staffs[item],
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
    final bloc = context.read<StaffsBloc>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: PaginationBloc.paginationWidget(
        bloc.state.staffsContainer.currentPage,
        bloc.state.staffsContainer.totalPage,
      )
          .map((pages) => PaginationButtons(
        onTap: () {
          if (PaginationBloc.isNumeric(pages)) {
            bloc.add(StaffsFetchEvent(
              query: bloc.state.searchQuery,
              departmentId: bloc.state.departmentsId,
              branchId: bloc.state.branchId,
              stateId: bloc.state.statesId,
              page: int.parse(pages),
              context: context,
            ));
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
    final bloc = context.read<StaffsBloc>();
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
            StaffsFetchEvent(
              query: onChanged,
              page: 1,
              departmentId: bloc.state.departmentsId,
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
      textInputAction: TextInputAction.done,
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
            bloc.add(const StaffsResetLoadEvent());
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
