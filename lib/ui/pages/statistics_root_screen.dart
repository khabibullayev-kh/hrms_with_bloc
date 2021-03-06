import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/blocs/navbar/candidates_stats_mvvm.dart';
import 'package:hrms/blocs/navbar/navigation_cubit.dart';
import 'package:hrms/blocs/navbar/shifts_stats_mvvm.dart';
import 'package:hrms/blocs/navbar/vacancies_stats_mvvm.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/ui/widgets/side_bar.dart';
import 'package:provider/provider.dart';
import 'package:hrms/ui/widgets/statistics/candidates_statistics.dart';
import 'package:hrms/ui/widgets/statistics/shifts_statistics.dart';
import 'package:hrms/ui/widgets/statistics/vacancies_statistics.dart';

class StatisticsRootScreen extends StatefulWidget {
  const StatisticsRootScreen({Key? key}) : super(key: key);

  @override
  _StatisticsRootScreenState createState() => _StatisticsRootScreenState();
}

class _StatisticsRootScreenState extends State<StatisticsRootScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
      ),
      drawer: const SideBar(),
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            selectedItemColor: HRMSColors.green,
            currentIndex: state.index,
            showUnselectedLabels: false,
            items: [
              if (isCan('get-stats-candidates'))
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: 'Кандидатоы',
                ),
              if (isCan('get-stats-shifts'))
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.wifi_protected_setup_rounded,
                  ),
                  label: 'Переводы',
                ),
              if (isCan('get-stats-vacancies'))
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: 'Вакансии',
                ),
            ],
            onTap: (index) {
              if (index == 0) {
                BlocProvider.of<NavigationCubit>(context)
                    .getNavBarItem(NavbarItem.candidates);
              } else if (index == 1) {
                BlocProvider.of<NavigationCubit>(context)
                    .getNavBarItem(NavbarItem.shifts);
              } else if (index == 2) {
                BlocProvider.of<NavigationCubit>(context)
                    .getNavBarItem(NavbarItem.vacancies);
              }
            },
          );
        },
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
        if (state.navbarItem == NavbarItem.candidates) {
          return ChangeNotifierProvider(
            create: (_) => CandidatesStatsViewModel(),
            child: const CandidatesStatistics(),
          );
        } else if (state.navbarItem == NavbarItem.shifts) {
          return ChangeNotifierProvider(
            create: (_) => ShiftsStatsViewModel(),
            child: const ShiftsStatisticsPage(),
          );
        } else if (state.navbarItem == NavbarItem.vacancies) {
          return ChangeNotifierProvider(
            create: (_) => VacanciesStatsViewModel(),
            child: const VacanciesStatisticsPage(),
          );
        }
        return Container();
      }),
    );
  }
}
