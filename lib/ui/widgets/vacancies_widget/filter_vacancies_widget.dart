import 'package:flutter/material.dart';
import 'package:hrms/blocs/vacancies/vacancies_bloc.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';

class FilterVacanciesWidget extends StatefulWidget {
  final VacanciesBloc bloc;

  const FilterVacanciesWidget({Key? key, required this.bloc})
      : super(key: key);

  @override
  _FilterVacanciesWidgetState createState() => _FilterVacanciesWidgetState();
}

class _FilterVacanciesWidgetState extends State<FilterVacanciesWidget> {
  int? jobPositionId;
  int? regionId;
  int? recruiterId;
  int? statesId;
  int? branchId;
  late final VacanciesBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;
    jobPositionId = bloc.state.jobPositionId;
    regionId = bloc.state.regionId;
    recruiterId = bloc.state.recruiterId;
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
          const Text('По рекрутёру:', style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) {
              // bloc.add(BranchesSetFiltersEvent(
              //     shopCategory: value, regionId: bloc.state.regionId));
              recruiterId = value;
              setState(() {});
            },
            value: recruiterId,
            items: bloc.state.recruitersItems,
          ),
          const SizedBox(height: 16),

          const Text('По региону:', style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) {
              // bloc.add(BranchesSetFiltersEvent(
              //     shopCategory: value, regionId: bloc.state.regionId));
              regionId = value;
              setState(() {});
            },
            value: regionId,
            items: bloc.state.regionsItems,
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
          const Text('По статусу:', style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) {
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
            items: bloc.state.jobPositionsItem,
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
                          VacanciesFetchEvent(
                            query: bloc.state.searchQuery,
                            page: 1,
                            jobPositionId: jobPositionId,
                            regionId: regionId,
                            recruiterId: recruiterId,
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
