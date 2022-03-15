import 'package:flutter/material.dart';
import 'package:hrms/blocs/candidates/candidates_bloc.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';

class FilterCandidatesWidget extends StatefulWidget {
  final CandidatesBloc bloc;

  const FilterCandidatesWidget({Key? key, required this.bloc})
      : super(key: key);

  @override
  _FilterCandidatesWidgetState createState() => _FilterCandidatesWidgetState();
}

class _FilterCandidatesWidgetState extends State<FilterCandidatesWidget> {
  String? sex;
  int? regionId;
  int? jobPositionId;
  int? statesId;
  int? branchId;
  late final CandidatesBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;
    regionId = bloc.state.regionId;
    sex = bloc.state.sex;
    jobPositionId = bloc.state.jobPositionId;
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
          const Text('По полу:', style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) {
              // bloc.add(BranchesSetFiltersEvent(
              //     shopCategory: value, regionId: bloc.state.regionId));
              sex = value;
              print(value);
              setState(() {});
            },
            value: sex,
            items: bloc.state.sexItems,
          ),
          const SizedBox(height: 16),
          const Text('По области:', style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) {
              // bloc.add(BranchesSetFiltersEvent(
              //     regionId: value, shopCategory: bloc.state.shopCategory));
              regionId = value;
              setState(() {});
            },
            value: regionId,
            items: bloc.state.regionItems,
          ),
          const SizedBox(height: 16),
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
              jobPositionId = value;
              setState(() {});
            },
            value: jobPositionId,
            items: bloc.state.jobPositionItems,
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
                          CandidatesFetchEvent(
                            query: bloc.state.searchQuery,
                            page: 1,
                            sex: sex,
                            jobPositionId: jobPositionId,
                            stateId: statesId,
                            regionId: regionId,
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
