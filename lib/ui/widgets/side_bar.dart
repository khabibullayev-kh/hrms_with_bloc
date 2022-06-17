import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/icons.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/data/resources/styles.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:hrms/ui/pages/update_page.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:hrms/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late String sex;
  late String name;

  @override
  void initState() {
    sex = getStringAsync(SEX);
    name = getStringAsync(USER_NAME);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SideBarHeader(name: name, sex: sex),
            Flexible(
              child: ListView(
                padding: const EdgeInsets.all(0),
                // shrinkWrap: true,
                children: [
                  if (isCan('get-users') ||
                      isCan('get-roles') ||
                      isCan('get-permissions'))
                    ExpansionTile(
                      iconColor: HRMSColors.green,
                      textColor: HRMSColors.green,
                      childrenPadding: const EdgeInsets.only(left: 24),
                      title: Text(
                        LocaleKeys.user_management.tr(),
                        style: HRMSStyles.labelStyle,
                      ),
                      children: <Widget>[
                        if (isCan('get-users'))
                          ListTile(
                            title: Text(
                              LocaleKeys.users.tr(),
                              style: HRMSStyles.labelStyle,
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                MainNavigationRouteNames.usersScreen,
                              );
                            },
                          ),
                        if (isCan('get-roles'))
                          ListTile(
                            title: Text(
                              LocaleKeys.roles.tr(),
                              style: HRMSStyles.labelStyle,
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                MainNavigationRouteNames.rolesScreen,
                              );
                            },
                          ),
                        if (isCan('get-permissions'))
                          ListTile(
                            title: Text(
                              LocaleKeys.permissions.tr(),
                              style: HRMSStyles.labelStyle,
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                MainNavigationRouteNames.permissionsScreen,
                              );
                            },
                          ),
                      ],
                    ),
                  if (isCan('get-stats-candidates') ||
                      isCan('get-stats-shifts') ||
                      isCan('get-stats-vacancies'))
                    ListTile(
                      //leading: SvgPicture.asset(Images.barIcon7),
                      title: Text(
                        LocaleKeys.statistics_label.tr(),
                        style: HRMSStyles.labelStyle,
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          MainNavigationRouteNames.statisticsScreen,
                        );
                      },
                    ),
                  if (isCan('get-branches'))
                    ListTile(
                      //leading: SvgPicture.asset(Images.barIcon7),
                      title: Text(
                        LocaleKeys.branches_label.tr(),
                        style: HRMSStyles.labelStyle,
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          MainNavigationRouteNames.branchesScreen,
                        );
                      },
                    ),
                  if (isCan('get-departments'))
                    ListTile(
                      //leading: SvgPicture.asset(Images.barIcon7),
                      title: Text(
                        LocaleKeys.departments_label.tr(),
                        style: HRMSStyles.labelStyle,
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          MainNavigationRouteNames.departmentsScreen,
                        );
                      },
                    ),
                  if (isCan('get-candidates'))
                    ListTile(
                      //leading: SvgPicture.asset(Images.barIcon7),
                      title: Text(
                        LocaleKeys.candidates_label.tr(),
                        style: HRMSStyles.labelStyle,
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          MainNavigationRouteNames.candidatesScreen,
                        );
                      },
                    ),
                  if (isCan('get-shifts'))
                    ListTile(
                      //leading: SvgPicture.asset(Images.barIcon7),
                      title: Text(
                        LocaleKeys.shifts_label.tr(),
                        style: HRMSStyles.labelStyle,
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          MainNavigationRouteNames.shiftsScreen,
                        );
                      },
                    ),
                  if (isCan('get-vacancies'))
                    ListTile(
                      //leading: SvgPicture.asset(Images.barIcon7),
                      title: Text(
                        LocaleKeys.vacancies_label.tr(),
                        style: HRMSStyles.labelStyle,
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          MainNavigationRouteNames.vacancyScreen,
                        );
                      },
                    ),
                  if (isCan('show-persons'))
                    ListTile(
                      //leading: SvgPicture.asset(Images.barIcon7),
                      title: Text(
                        LocaleKeys.persons_label.tr(),
                        style: HRMSStyles.labelStyle,
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          MainNavigationRouteNames.personsScreen,
                        );
                      },
                    ),
                  if (isCan('show-staffs'))
                    ListTile(
                      //leading: SvgPicture.asset(Images.barIcon7),
                      title: Text(
                        LocaleKeys.staff_label.tr(),
                        style: HRMSStyles.labelStyle,
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          MainNavigationRouteNames.staffsScreen,
                        );
                      },
                    ),
                  ListTile(
                    //leading: SvgPicture.asset(Images.barIcon7),
                    title: Text(
                      LocaleKeys.settings_label.tr(),
                      style: HRMSStyles.labelStyle,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(
                        MainNavigationRouteNames.settings,
                      );
                    },
                  ),
                  if (isCan('in-app-update'))
                    ListTile(
                      //leading: SvgPicture.asset(Images.barIcon7),
                      title: const Text(
                        'Update Check',
                        style: HRMSStyles.labelStyle,
                      ),
                      onTap: () {
                      //   Navigator.of(context).pushReplacementNamed(
                      //     MainNavigationRouteNames.auth,
                      //   );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UpdatePage()),
                        );
                      },
                    ),
                  const LogOutWidget(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogOutWidget extends StatelessWidget {
  const LogOutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return SizedBox(
      height: 45,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          onPressed: () => {
            authService.logoutAndDeleteData(),
            MainNavigation.resetNavigation(context),
          },
          child: Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    LocaleKeys.exit_label.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            primary: HRMSColors.green,
            onPrimary: Colors.black,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

class SideBarHeader extends StatelessWidget {
  const SideBarHeader({
    Key? key,
    required this.name,
    required this.sex,
  }) : super(key: key);

  final String name;
  final String sex;

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        color: Color(0xFF76AA60),
      ),
      accountName: Text(
        name,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
      ),
      accountEmail: Text(
        getStringAsync(ROLE_NAME),
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14),
      ),
      currentAccountPicture: CircleAvatar(
          backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
              ? const Color(0xFF56ccf2)
              : Colors.white,
          child: sex == 'woman'
              ? SvgPicture.asset(HRMSIcons.female)
              : SvgPicture.asset(HRMSIcons.male)),
      // child: SvgPicture.asset(Images.male)),
    );
  }
}
