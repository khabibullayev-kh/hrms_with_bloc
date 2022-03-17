import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/blocs/pagination_bloc.dart';
import 'package:hrms/blocs/roles/delete_role_mvvm.dart';
import 'package:hrms/blocs/roles/roles_bloc.dart';
import 'package:hrms/data/models/roles/role.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/icons.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/ui/widgets/delete_widget.dart';
import 'package:hrms/ui/widgets/error_widget.dart';
import 'package:hrms/ui/widgets/nothing_found_widget.dart';
import 'package:hrms/ui/widgets/pagination_widget.dart';
import 'package:hrms/ui/widgets/reusable_bottom_sheet.dart';
import 'package:hrms/ui/widgets/reusable_circular_progress_indicator.dart';
import 'package:hrms/ui/widgets/reusable_data_table.dart';
import 'package:hrms/ui/widgets/side_bar.dart';
import 'package:provider/provider.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({Key? key}) : super(key: key);

  @override
  State<RolesPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<RolesPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RolesBloc>(context).add(RolesFetchEvent('', 1, context));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RolesBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.roles.tr(),
          style: HRMSStyles.appBarTextStyle,
        ),
        actions: [
          if (isCan('create-role'))
            IconButton(
              onPressed: () async => pushToAddRoleScreen(bloc),
              icon: const Icon(Icons.add),
            )
        ],
      ),
      drawer: const SideBar(),
      body: const MainPageBody(),
    );
  }

  Future<void> pushToAddRoleScreen(RolesBloc bloc) async {
    final result = await Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addRolesScreen,
    );
    if (result == true) {
      bloc.add(
        RolesReloadEvent(
          '',
          bloc.state.currentPage == bloc.state.totalPage
              ? bloc.state.perPage == bloc.state.rolesContainer.roles.length
                  ? bloc.state.currentPage + 1
                  : bloc.state.currentPage
              : bloc.state.currentPage,
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
          BlocBuilder<RolesBloc, RolesState>(
            builder: (context, state) {
              switch (state.usersStatus) {
                case RolesStatus.loading:
                  return const ReusableCircularIndicator();
                case RolesStatus.success:
                  return RolesWidget(
                    rolesContainer: state.rolesContainer,
                  );
                case RolesStatus.nothingFound:
                  return const NothingFoundWidget(text: 'Ролей не найдено');
                case RolesStatus.failure:
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

class RolesWidget extends StatelessWidget {
  final RolesContainer rolesContainer;

  const RolesWidget({
    required this.rolesContainer,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kRolesTableColumns = <DataColumn>[
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
            columns: kRolesTableColumns,
            rows: dataRow(rolesContainer),
          ),
          const SizedBox(height: 16),
          PaginationBody(rolesContainer: rolesContainer),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class PaginationBody extends StatelessWidget {
  const PaginationBody({
    Key? key,
    required this.rolesContainer,
  }) : super(key: key);

  final RolesContainer rolesContainer;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RolesBloc>();
    List<String> pages = PaginationBloc.paginationWidget(
      rolesContainer.currentPage,
      rolesContainer.totalPage,
    );
    return SizedBox(
      height: 40,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: pages.length,
          itemBuilder: (BuildContext context, int index) {
            return PaginationButtons(
              onTap: () {
                if (PaginationBloc.isNumeric(pages[index])) {
                  bloc.add(
                    RolesFetchEvent(
                      bloc.state.searchQuery,
                      int.parse(pages[index]),
                      context,
                    ),
                  );
                }
              },
              currentPage: bloc.state.currentPage.toString(),
              pages: pages[index],
            );
          }),
    );
  }
}

List<DataRow> dataRow(final RolesContainer roles) {
  List<DataRow> positionRow = [];
  for (Role role in roles.roles) {
    positionRow.add(
      DataRow(
        cells: <DataCell>[
          DataCell(Text('${role.id}')),
          DataCell(Text(role.name)),
          DataCell(
            ActionsWidget(
              id: role.id,
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
    final bloc = context.watch<RolesBloc>();
    return Row(
      children: <Widget>[
        if (isCan('update-role'))
        IconButton(
          onPressed: () async {
            final result = await Navigator.of(context).pushNamed(
                MainNavigationRouteNames.editRolesScreen,
                arguments: id);
            if (result == true) {
              bloc.add(
                RolesReloadEvent(
                  bloc.state.searchQuery,
                  bloc.state.currentPage,
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
        if (isCan('delete-role'))
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
                  create: (_) => DeleteRoleViewModel(
                    roleId: id,
                    rolesBloc: bloc,
                  ),
                  child: DeleteRoleWidget(id: id),
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

class DeleteRoleWidget extends StatelessWidget {
  const DeleteRoleWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DeleteRoleViewModel>();
    return ReusableBottomSheet(
      children: DeleteWidget(
        deleteText: '${LocaleKeys.delete_role.tr()} №$id?',
        isLoading: model.data.isLoading,
        onTapDelete: () =>
            model.data.isLoading ? null : model.deleteRole(id, context),
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
    final bloc = context.read<RolesBloc>();
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
          bloc.add(RolesFetchEvent(
            onChanged,
            1,
            context,
          ));
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
            bloc.add(const RolesResetLoadEvent('', 1));
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
