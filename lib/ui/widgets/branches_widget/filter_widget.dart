import 'package:flutter/material.dart';
import 'package:hrms/blocs/branches/branches_bloc.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';

class FilterBranchesWidget extends StatefulWidget {
  final BranchesBloc bloc;

  const FilterBranchesWidget({Key? key, required this.bloc}) : super(key: key);

  @override
  _FilterBranchesWidgetState createState() => _FilterBranchesWidgetState();
}

class _FilterBranchesWidgetState extends State<FilterBranchesWidget> {
  int? regionId;
  String? shopCategory;
  late final BranchesBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;
    regionId = bloc.state.regionId;
    shopCategory = bloc.state.shopCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
          const Text('По категории:', style: HRMSStyles.loginText),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) {
              // bloc.add(BranchesSetFiltersEvent(
              //     shopCategory: value, regionId: bloc.state.regionId));
              shopCategory = value;
              setState(() {});
            },
            value: shopCategory,
            items: bloc.state.shopCategoryItems,
          ),
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
                          BranchesFetchEvent(
                              bloc.state.searchQuery,
                              1,
                              regionId,
                              shopCategory,
                              context),
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
