import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/blocs/branches/branches_bloc.dart';
import 'package:hrms/blocs/branches/delet_branch_mvvm.dart';
import 'package:hrms/blocs/pagination_bloc.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/icons.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/ui/widgets/branches_widget/filter_widget.dart';
import 'package:hrms/ui/widgets/delete_widget.dart';
import 'package:hrms/ui/widgets/error_widget.dart';
import 'package:hrms/ui/widgets/nothing_found_widget.dart';
import 'package:hrms/ui/widgets/pagination_widget.dart';
import 'package:hrms/ui/widgets/reusable_bottom_sheet.dart';
import 'package:hrms/ui/widgets/reusable_circular_progress_indicator.dart';
import 'package:hrms/ui/widgets/reusable_data_table.dart';
import 'package:hrms/ui/widgets/side_bar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class BranchesPage extends StatefulWidget {
  const BranchesPage({Key? key}) : super(key: key);

  @override
  State<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BranchesBloc>(context).add(
      BranchesPageInitializeEvent(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BranchesBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.branches_label.tr(),
          style: HRMSStyles.appBarTextStyle,
        ),
        actions: [
          if (isCan('create-branch'))
            IconButton(
              tooltip: 'Добавить филиал',
              onPressed: () async => pushToAddScreen(bloc),
              icon: Image.asset(HRMSIcons.add),
            ),
          IconButton(
            tooltip: 'Фильтр',
            onPressed: () {
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
                    children: FilterBranchesWidget(bloc: bloc),
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

  Future<void> pushToAddScreen(BranchesBloc bloc) async {
    final result = await Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addBranchScreen,
    );
    if (result == true) {
      bloc.add(
        BranchesReloadEvent(
          '',
          bloc.state.currentPage == bloc.state.totalPage
              ? bloc.state.perPage ==
                      bloc.state.branchesContainer.branches.length
                  ? bloc.state.currentPage + 1
                  : bloc.state.currentPage
              : bloc.state.currentPage,
          null,
          null,
        ),
      );
    }
  }
}

class MainPageBody extends StatelessWidget {
  const MainPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: SearchWidget(searchFieldFocusNode: FocusNode()),
          ),
          BlocBuilder<BranchesBloc, BranchesState>(
            builder: (context, state) {
              switch (state.branchesStatus) {
                case BranchesStatus.loading:
                  return const ReusableCircularIndicator();
                case BranchesStatus.success:
                  return BranchesWidget(
                    branchesContainer: state.branchesContainer,
                  );
                case BranchesStatus.nothingFound:
                  return const NothingFoundWidget(text: 'Филиалов не найдено');
                case BranchesStatus.failure:
                default:
                  return const ErrorWidgetBody();
              }
            },
          ),
        ],
      ),
    );
  }
}

class BranchesWidget extends StatelessWidget {
  final BranchesContainer branchesContainer;

  const BranchesWidget({
    required this.branchesContainer,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kBranchesTableColumns = <DataColumn>[
      const DataColumn(
          label: Text(
        '№',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      DataColumn(
          label: Text(
        LocaleKeys.name_label.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),
      DataColumn(
          label: Text(
        LocaleKeys.category_label.tr().replaceAll(':', ''),
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),
      DataColumn(
          label: Text(
        LocaleKeys.action_label.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          ReusableDataTable(
            columns: kBranchesTableColumns,
            rows: dataRow(branchesContainer, context),
          ),
          const SizedBox(height: 16),
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
    final bloc = context.read<BranchesBloc>();
    final currentPage = bloc.state.branchesContainer.currentPage;
    final totalPage = bloc.state.branchesContainer.totalPage;
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
                      BranchesFetchEvent(
                        bloc.state.searchQuery,
                        int.parse(pages),
                        bloc.state.regionId,
                        bloc.state.shopCategory,
                        context,
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

List<DataRow> dataRow(final BranchesContainer branches, BuildContext context) {
  List<DataRow> positionRow = [];
  for (Branch branch in branches.branches) {
    positionRow.add(
      DataRow(
        selected: false,
        onSelectChanged: (newValue) {
          Navigator.of(context).pushNamed(
            MainNavigationRouteNames.branchInfoScreen,
            arguments: branch.id,
          );
        },
        cells: <DataCell>[
          DataCell(Text('${branch.id}')),
          DataCell(
            Text(
                getStringAsync(LANG) == 'ru' ? branch.nameRu! : branch.nameUz!),
          ),
          DataCell(
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: getColor(branch.shopCategory!),
                    shape: BoxShape.circle),
                child: Text(
                  branch.shopCategory!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          DataCell(
            ActionsWidget(
              id: branch.id,
            ),
          ),
        ],
      ),
    );
  }
  return positionRow;
}

class ActionsWidget extends StatelessWidget {
  final int id;

  const ActionsWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<BranchesBloc>();
    return Row(
      children: <Widget>[
        if (isCan('update-branch'))
          IconButton(
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed(
                  MainNavigationRouteNames.editBranchScreen,
                  arguments: id);
              if (result == true) {
                bloc.add(
                  BranchesReloadEvent(
                    bloc.state.searchQuery,
                    bloc.state.currentPage,
                    bloc.state.regionId,
                    bloc.state.shopCategory,
                  ),
                );
              }
            },
            icon: SvgPicture.asset(
              HRMSIcons.editLogo,
              width: 18,
              height: 18,
            ),
          ),
        if (isCan('delete-branch'))
          IconButton(
            onPressed: () {
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
                    create: (_) => DeleteBranchViewModel(
                      branchId: id,
                      bloc: bloc,
                    ),
                    child: DeleteBranchWidget(id: id),
                  );
                },
              );
            },
            icon: SvgPicture.asset(
              HRMSIcons.deleteLogo,
              width: 18,
              height: 18,
            ),
          ),
      ],
    );
  }
}

class DeleteBranchWidget extends StatelessWidget {
  const DeleteBranchWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DeleteBranchViewModel>();
    return ReusableBottomSheet(
      children: DeleteWidget(
        deleteText: 'Удалить филиал №$id?',
        isLoading: model.data.isLoading,
        onTapDelete: () =>
            model.data.isLoading ? null : model.deleteBranch(id, context),
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
    final bloc = context.read<BranchesBloc>();
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
          bloc.add(BranchesFetchEvent(onChanged, 1, null, null, context));
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
            bloc.add(const BranchesResetLoadEvent('', 1));
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
