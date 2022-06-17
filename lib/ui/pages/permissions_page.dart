import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/blocs/pagination_bloc.dart';
import 'package:hrms/blocs/permissions/delete_permission_mvvm.dart';
import 'package:hrms/blocs/permissions/permissions_bloc.dart';
import 'package:hrms/data/models/permissions/permission.dart';
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

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({Key? key}) : super(key: key);

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PermissionsBloc>(context)
        .add(PermissionsFetchEvent('', 1, context));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PermissionsBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.permissions.tr(),
          style: HRMSStyles.appBarTextStyle,
        ),
        actions: [
          if (isCan('create-permission'))
            IconButton(
              onPressed: () async => pushToAddPermissionScreen(bloc),
              icon: const Icon(Icons.add),
            )
        ],
      ),
      drawer: const SideBar(),
      body: const MainPageBody(),
    );
  }

  Future<void> pushToAddPermissionScreen(PermissionsBloc bloc) async {
    final result = await Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addPermissionsScreen,
    );
    if (result == true) {
      bloc.add(
        PermissionsReloadEvent(
          '',
          bloc.state.currentPage == bloc.state.totalPage
              ? bloc.state.perPage ==
                      bloc.state.permissionsContainer.permissions.length
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
          BlocBuilder<PermissionsBloc, PermissionsState>(
            builder: (context, state) {
              switch (state.permissionsStatus) {
                case PermissionsStatus.loading:
                  return const ReusableCircularIndicator();
                case PermissionsStatus.success:
                  return PermissionsWidget(
                    permissionsContainer: state.permissionsContainer,
                  );
                case PermissionsStatus.nothingFound:
                  return const NothingFoundWidget(text: 'Разрешений не найдено');
                case PermissionsStatus.failure:
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

class PermissionsWidget extends StatelessWidget {
  final PermissionsContainer permissionsContainer;

  const PermissionsWidget({
    required this.permissionsContainer,
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
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      DataColumn(
          label: Text(
            LocaleKeys.action_label.tr(),
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          ReusableDataTable(
            columns: kRolesTableColumns,
            rows: dataRow(permissionsContainer),
          ),
          const SizedBox(height: 16),
          PaginationBody(permissionsContainer: permissionsContainer),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class PaginationBody extends StatelessWidget {
  const PaginationBody({
    Key? key,
    required this.permissionsContainer,
  }) : super(key: key);

  final PermissionsContainer permissionsContainer;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PermissionsBloc>();
    List<String> pages = PaginationBloc.paginationWidget(
      permissionsContainer.currentPage,
      permissionsContainer.totalPage,
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
                    PermissionsFetchEvent(
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

List<DataRow> dataRow(final PermissionsContainer permissions) {
  List<DataRow> positionRow = [];
  for (Permission permission in permissions.permissions) {
    positionRow.add(
      DataRow(
        cells: <DataCell>[
          DataCell(Text('${permission.id}')),
          DataCell(Text(permission.nameRu)),
          DataCell(
            ActionsWidget(
              id: permission.id,
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
    final bloc = context.watch<PermissionsBloc>();
    return Row(
      children: <Widget>[
        if (isCan('update-permission'))
          IconButton(
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed(
                  MainNavigationRouteNames.editPermissionsScreen,
                  arguments: id);
              if (result == true) {
                bloc.add(
                  PermissionsReloadEvent(
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
        if (isCan('delete-permission'))
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
                    create: (_) => DeletePermissionViewModel(
                      permissionId: id,
                      bloc: bloc,
                    ),
                    child: DeletePermissionWidget(id: id),
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

class DeletePermissionWidget extends StatelessWidget {
  const DeletePermissionWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DeletePermissionViewModel>();
    return ReusableBottomSheet(
      children: DeleteWidget(
        deleteText: '${LocaleKeys.delete_permission.tr()} №$id?',
        isLoading: model.data.isLoading,
        onTapDelete: () =>
            model.data.isLoading ? null : model.deletePermission(id, context),
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
    final bloc = context.read<PermissionsBloc>();
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
          bloc.add(PermissionsFetchEvent(
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
            bloc.add(const PermissionsResetLoadEvent('', 1));
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
