import 'package:flutter/material.dart';
import 'package:hrms/blocs/navbar/vacancies_stats_mvvm.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_circular_progress_indicator.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class VacanciesStatisticsPage extends StatefulWidget {
  const VacanciesStatisticsPage({Key? key}) : super(key: key);

  @override
  State<VacanciesStatisticsPage> createState() => _VacanciesStatisticsState();
}

class _VacanciesStatisticsState extends State<VacanciesStatisticsPage> {

  @override
  void initState() {
    Future.microtask(
      () => context.read<VacanciesStatsViewModel>().load(context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<VacanciesStatsViewModel>();
    return model.data.isInitializing
        ? const Center(
            child: ReusableCircularIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                _CircularChartWidget(),
                _StatisticsFilterWidget(),
              ],
            ),
          );
  }
}

class _CircularChartWidget extends StatelessWidget {
  const _CircularChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<VacanciesStatsViewModel>();
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      width: MediaQuery.of(context).size.width,
      child: SfCircularChart(
        annotations: [
          CircularChartAnnotation(
              widget: Container(
                decoration: BoxDecoration(
                  color: HRMSColors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${getIntAsync(VACANCIES_QUANTITY)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ))
        ],
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom,
          alignment: ChartAlignment.center,
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [
          model.getCircularSeries(),
        ],
      ),
    );
  }
}


class _StatisticsFilterWidget extends StatelessWidget {
  const _StatisticsFilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<VacanciesStatsViewModel>();
    final data = model.data;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
      child: Column(
        children: <Widget>[
          Text(LocaleKeys.branch_text.tr(), style: HRMSStyles.labelStyle),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) => model.setBranch(value),
            value: data.branchId,
            items: data.branchesItems,
          ),
          const SizedBox(height: 16),
          Text(LocaleKeys.recruiter_text.tr(), style: HRMSStyles.labelStyle),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) => model.setRecruiter(value),
            value: data.recruiterId,
            items: data.recruitersItems,
          ),
          const SizedBox(height: 24),
          ActionButton(
            text: LocaleKeys.view_statistics.tr(),
            onPressed: () => model.getStatistics(),
            isLoading: model.data.isLoading,
          ),
        ],
      ),
    );
  }
}
