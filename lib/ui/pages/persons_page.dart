import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/blocs/pagination_bloc.dart';
import 'package:hrms/blocs/persons/persons_bloc.dart';
import 'package:hrms/data/models/persons/person.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/icons.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/ui/widgets/pagination_widget.dart';
import 'package:hrms/ui/widgets/reusable_circular_progress_indicator.dart';
import 'package:hrms/ui/widgets/reusable_data_table.dart';
import 'package:hrms/ui/widgets/side_bar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class PersonsPage extends StatefulWidget {
  const PersonsPage({Key? key}) : super(key: key);

  @override
  State<PersonsPage> createState() => _PersonsPageState();
}

class _PersonsPageState extends State<PersonsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PersonsBloc>(context)
        .add(PersonsFetchEvent('', 1, context));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PersonsBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.persons_label.tr()),
        actions: [
          if (isCan('create-person'))

            IconButton(
            tooltip: 'Добавить сотрудника',
            onPressed: () async => pushToAddUsersPage(bloc),
            icon: Image.asset(HRMSIcons.add),
          )
        ],
      ),
      drawer: const SideBar(),
      body: const _MainPageBody(),
    );
  }

  Future<void> pushToAddUsersPage(PersonsBloc bloc) async {
    final result = await Navigator.of(context).pushNamed(
      MainNavigationRouteNames.addPersonsScreen,
    );
    if (result == true) {
      bloc.add(const PersonsReloadEvent());
    }
  }
}

class _MainPageBody extends StatelessWidget {
  const _MainPageBody({Key? key}) : super(key: key);

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
          BlocBuilder<PersonsBloc, PersonsState>(
            builder: (context, state) {
              switch (state.personsStatus) {
                case PersonsStatus.loading:
                  return const ReusableCircularIndicator();
                case PersonsStatus.success:
                  return _PersonsWidgetWidget(
                    personsContainer: state.personsContainer,
                  );
                case PersonsStatus.nothingFound:
                  return const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: Text(
                        'Пользователей не найдено',
                      ),
                    ),
                  );
                case PersonsStatus.failure:
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

class _PersonsWidgetWidget extends StatelessWidget {
  final PersonsContainer personsContainer;

  const _PersonsWidgetWidget({
    required this.personsContainer,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kPersonsTableColumns = <DataColumn>[
      const DataColumn(
          label: Text(
            '№',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      DataColumn(
          label: Text(
            LocaleKeys.full_name_label.tr(),
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
            columns: kPersonsTableColumns,
            rows: dataRow(personsContainer),
          ),
          const SizedBox(height: 16),
          const PaginationRow(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class PaginationRow extends StatelessWidget {
  const PaginationRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PersonsBloc>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: PaginationBloc.paginationWidget(
        bloc.state.personsContainer.currentPage,
        bloc.state.personsContainer.totalPage,
      )
          .map((pages) => PaginationButtons(
                onTap: () {
                  if (PaginationBloc.isNumeric(pages)) {
                    bloc.add(PersonsFetchEvent(
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

List<DataRow> dataRow(final PersonsContainer personsContainer) {
  List<DataRow> positionRow = [];
  for (Person persons in personsContainer.persons) {
    positionRow.add(
      DataRow(
        cells: <DataCell>[
          DataCell(Text('${persons.id}')),
          DataCell(Text('${persons.firstName} ${persons.lastName}')),
          DataCell(
            ActionsWidget(
              id: persons.id!,
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
    final bloc = context.watch<PersonsBloc>();
    return Row(
      children: <Widget>[
        if (isCan('update-person'))

          IconButton(
          onPressed: () async {
            final result = await Navigator.of(context).pushNamed(
                MainNavigationRouteNames.editPersonScreen,
                arguments: id);
            if (result == true) {
              bloc.add(
                const PersonsReloadEvent(),
              );
            }
          },
          icon: SvgPicture.asset(
            HRMSIcons.editLogo,
            width: 18,
            height: 18,
          ),
        ),
        if (isCan('delete-person'))

          IconButton(
          onPressed: () async {
            final result = await showConfirmDialogCustom(
              context,
              title: getStringAsync(LANG) == 'ru' ? "${LocaleKeys.delete_person.tr()} №$id" : "№$id-${LocaleKeys.delete_person.tr()}",
              negativeText: LocaleKeys.cancel_text.tr(),
              positiveText: LocaleKeys.delete_text.tr(),
              dialogType: DialogType.DELETE,
              onAccept: (context) {
                Navigator.pop(context, true);
              },
            );
            if (result == true) {
              bloc.add(PersonsDeleteEvent(id, context));
            }
          },
          icon: SvgPicture.asset(HRMSIcons.deleteLogo, width: 18, height: 18),
        ),
      ],
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
    final bloc = context.read<PersonsBloc>();
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
          bloc.add(PersonsFetchEvent(
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
            bloc.add(const PersonsResetLoadEvent());
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
