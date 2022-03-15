import 'package:flutter/material.dart';
import 'package:hrms/blocs/navbar/candidates_stats_mvvm.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/ui/widgets/action_button.dart';
import 'package:hrms/ui/widgets/reusable_circular_progress_indicator.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/select_date_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandidatesStatistics extends StatefulWidget {
  const CandidatesStatistics({Key? key}) : super(key: key);

  @override
  State<CandidatesStatistics> createState() => _CandidatesStatisticsState();
}

class _CandidatesStatisticsState extends State<CandidatesStatistics> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    Future.microtask(
      () => context.read<CandidatesStatsViewModel>().load(context),
    );
    _tooltipBehavior =
        TooltipBehavior(enable: false, format: 'point.y', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CandidatesStatsViewModel>();
    return model.data.isInitializing
        ? const Center(
            child: ReusableCircularIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.05,
                  width: MediaQuery.of(context).size.width,
                  child: SfFunnelChart(
                    //smartLabelMode: SmartLabelMode.hide,
                    legend: Legend(
                      isResponsive: true,
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap,
                      position: LegendPosition.bottom,
                      textStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      // title: LegendTitle(
                      //     text: '158',
                      //     //'${LocaleKeys.statistics_count_text.tr()}: ${candidatesStatsModel.result.quantity}',
                      //     textStyle: TextStyle(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w600)),
                    ),
                    tooltipBehavior: _tooltipBehavior,
                    series: model.getFunnelSeries(),
                  ),
                ),
                const _StatisticsFilterWidget(),
              ],
            ),
          );
  }
}

class _StatisticsFilterWidget extends StatelessWidget {
  const _StatisticsFilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CandidatesStatsViewModel>();
    final data = model.data;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
      child: Column(
        children: <Widget>[
          const Text('С:', style: HRMSStyles.labelStyle),
          const SizedBox(height: 8),
          SelectDateWidget(
            onTap: () => model.selectFromDate(context: context),
            clearDate: () => model.clearFromDate(),
            dateTimeController: data.fromDate,
          ),
          const SizedBox(height: 16.0),
          const Text('По:', style: HRMSStyles.labelStyle),
          const SizedBox(height: 8),
          SelectDateWidget(
            onTap: () => model.selectToDate(context: context),
            clearDate: () => model.clearToDate(),
            dateTimeController: data.toDate,
          ),
          const SizedBox(height: 16.0),
          const Text('Рекрутёр:', style: HRMSStyles.labelStyle),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) => model.setRecruiter(value),
            value: data.recruiterId,
            items: data.recruiterItems,
          ),
          const SizedBox(height: 16.0),
          const Text('Филиал:', style: HRMSStyles.labelStyle),
          const SizedBox(height: 8),
          ReusableDropDownButton(
            onChanged: (value) => model.setBranch(value),
            value: data.branchId,
            items: data.branchesItems,
          ),
          const SizedBox(height: 24),
          ActionButton(
            text: 'Получить статистику',
            onPressed: () => model.getStatistics(),
            isLoading: model.data.isLoading,
          ),
        ],
      ),
    );
  }
}
