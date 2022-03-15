import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/blocs/pagination_bloc.dart';
import 'package:hrms/blocs/users/delete_user_mvvm.dart';
import 'package:hrms/blocs/users/users_bloc.dart';
import 'package:hrms/data/data_provider/session_data_provider.dart';
import 'package:hrms/data/models/user.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/icons.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/ui/widgets/delete_widget.dart';
import 'package:hrms/ui/widgets/pagination_widget.dart';
import 'package:hrms/ui/widgets/reusable_bottom_sheet.dart';
import 'package:hrms/ui/widgets/reusable_data_table.dart';
import 'package:hrms/ui/widgets/side_bar.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UsersBloc>(context).add(UsersFetchEvent('', 1, context));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Пользователи',
          style: HRMSStyles.appBarTextStyle,
        ),
        actions: [
          if (isCan('create-user'))
            IconButton(
              onPressed: () async => pushToAddUsersPage(bloc),
              icon: const Icon(Icons.add),
            )
        ],
      ),
      drawer: const SideBar(),
      body: const MainPageBody(),
    );
  }

  Future<void> pushToAddUsersPage(UsersBloc bloc) async {
    final result = await Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addUsersScreen,
    );
    if (result == true) {
      bloc.add(
        UsersReloadEvent(
          '',
          bloc.state.currentPage == bloc.state.totalPage
              ? bloc.state.perPage == bloc.state.usersListContainer.users.length
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
            padding: const EdgeInsets.only(
              top: 16.0,
              right: 8.0,
              left: 8.0,
            ),
            child: SearchWidget(
              searchFieldFocusNode: FocusNode(),
            ),
          ),
          BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              switch (state.usersStatus) {
                case UsersStatus.loading:
                  return const Padding(
                    padding: EdgeInsets.only(top: 32.0),
                    child: CircularProgressIndicator.adaptive(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(HRMSColors.green),
                    ),
                  );
                case UsersStatus.success:
                  return UsersWidget(
                    usersContainer: state.usersListContainer,
                  );
                case UsersStatus.nothingFound:
                  return const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: Text(
                        'Пользователей не найдено',
                      ),
                    ),
                  );
                case UsersStatus.failure:
                default:
                  return const Center(
                    child: Text('Error happened'),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}

class UsersWidget extends StatelessWidget {
  final UsersContainer usersContainer;

  const UsersWidget({
    required this.usersContainer,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          ReusableDataTable(
            columns: kTableColumns,
            rows: dataRow(usersContainer),
          ),
          const SizedBox(height: 16),
          const PaginationRow(),
          const SizedBox(height: 16),
          TextButton(
              onPressed: () {
                SessionDataProvider().deleteToken();
              },
              child: const Text('Delete')),
        ],
      ),
    );
  }
}

class PaginationRow extends StatelessWidget {
  const PaginationRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: PaginationBloc.paginationWidget(
        bloc.state.usersListContainer.currentPage,
        bloc.state.usersListContainer.totalPage,
      )
          .map((pages) => PaginationButtons(
                onTap: () {
                  if (PaginationBloc.isNumeric(pages)) {
                    bloc.add(UsersFetchEvent(
                      bloc.state.searchQuery,
                      int.parse(pages),
                      context,
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

List<DataRow> dataRow(final UsersContainer users) {
  List<DataRow> positionRow = [];
  for (User user in users.users) {
    positionRow.add(
      DataRow(
        cells: <DataCell>[
          DataCell(Text('${user.id}')),
          DataCell(Text('${user.firstName} ${user.lastName}')),
          DataCell(Text(user.role)),
          DataCell(
            ActionsWidget(
              id: user.id,
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
    final bloc = context.watch<UsersBloc>();
    return Row(
      children: <Widget>[
        if (isCan('update-user'))
        IconButton(
          onPressed: () async {
            final result = await Navigator.of(context).pushNamed(
                MainNavigationRouteNames.editUsersScreen,
                arguments: id);
            if (result == true) {
              bloc.add(
                UsersReloadEvent(
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
        if (isCan('delete-user'))
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
                  create: (_) =>
                      DeleteUserViewModel(userId: id, usersBloc: bloc),
                  child: DeleteUserWidget(id: id),
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

class DeleteUserWidget extends StatelessWidget {
  const DeleteUserWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DeleteUserViewModel>();
    return ReusableBottomSheet(
      children: DeleteWidget(
        deleteText: 'Удалить пользователя №$id?',
        isLoading: model.data.isLoading,
        onTapDelete: () =>
            model.data.isLoading ? null : model.deleteUser(id, context),
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
    final bloc = context.read<UsersBloc>();
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
          bloc.add(UsersFetchEvent(
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
            bloc.add(const UsersResetLoadEvent('', 1));
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
