import 'package:flutter/material.dart';
import 'package:hrms/blocs/shifts/shifts_bloc.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';

class FilterShiftsWidget extends StatefulWidget {
  final ShiftsBloc bloc;

  const FilterShiftsWidget({Key? key, required this.bloc})
      : super(key: key);

  @override
  _FilterShiftsWidgetState createState() => _FilterShiftsWidgetState();
}

class _FilterShiftsWidgetState extends State<FilterShiftsWidget> {
  int? toJobPositionId;
  int? statesId;
  int? branchId;
  late final ShiftsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;
    toJobPositionId = bloc.state.toJobPositionsId;
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
          const Text('По должности:', style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) {
              // bloc.add(BranchesSetFiltersEvent(
              //     shopCategory: value, regionId: bloc.state.regionId));
              toJobPositionId = value;
              setState(() {});
            },
            value: toJobPositionId,
            items: bloc.state.toJobPositionsItem,
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
          const SizedBox(
            height: 24,
          ),
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
                          ShiftsFetchEvent(
                            query: bloc.state.searchQuery,
                            page: 1,
                            toJobPositionId: toJobPositionId,
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
