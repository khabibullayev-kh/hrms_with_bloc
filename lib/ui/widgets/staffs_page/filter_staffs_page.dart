import 'package:flutter/material.dart';
import 'package:hrms/blocs/shifts/shifts_bloc.dart';
import 'package:hrms/blocs/staffs/staffs_bloc.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';

class FilterStaffsWidget extends StatefulWidget {
  final StaffsBloc bloc;

  const FilterStaffsWidget({Key? key, required this.bloc}) : super(key: key);

  @override
  _FilterStaffsWidgetState createState() => _FilterStaffsWidgetState();
}

class _FilterStaffsWidgetState extends State<FilterStaffsWidget> {
  int? departmentId;
  int? statesId;
  int? branchId;
  late final StaffsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;
    departmentId = bloc.state.departmentsId;
    statesId = bloc.state.statesId;
    branchId = bloc.state.branchId;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('По статусу:', style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) {
              // bloc.add(BranchesSetFiltersEvent(
              //     shopCategory: value, regionId: bloc.state.regionId));
              statesId = value;
              setState(() {});
            },
            value: statesId,
            items: bloc.state.statesItems,
          ),
          const SizedBox(height: 16),
          const Text('По департаменту:', style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) {
              // bloc.add(BranchesSetFiltersEvent(
              //     shopCategory: value, regionId: bloc.state.regionId));
              departmentId = value;
              setState(() {});
            },
            value: departmentId,
            items: bloc.state.departmentsItems,
          ),
          const SizedBox(height: 16),
          const Text('По филиалу:', style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) {
              // bloc.add(BranchesSetFiltersEvent(
              //     shopCategory: value, regionId: bloc.state.regionId));
              branchId = value;
              setState(() {});
            },
            value: branchId,
            items: bloc.state.branchesItems,
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  ActionButton(
                    text: 'Отменить',
                    onPressed: () => Navigator.pop(context),
                    isLoading: false,
                    color: Colors.red,
                  ),
                  const Expanded(child: SizedBox()),
                  ActionButton(
                      text: 'Применить',
                      onPressed: () {
                        bloc.add(
                          StaffsFetchEvent(
                            query: bloc.state.searchQuery,
                            page: 1,
                            departmentId: departmentId,
                            stateId: statesId,
                            branchId: branchId,
                            context: context,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      isLoading: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
