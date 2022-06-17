import 'package:flutter/material.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/navigation/main_navigation.dart';

class LoaderViewModel {
  final BuildContext context;
  final _authService = AuthService();

  LoaderViewModel(this.context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    await checkAuth();
  }

  Future<void> checkAuth() async {
    final isAuth = await _authService.isAuth();
    final nextScreen = isAuth && isCan('get-candidates')
        ? MainNavigationRouteNames.candidatesScreen
        : isAuth && isCan('get-vacancies')
            ? MainNavigationRouteNames.vacancyScreen
                : MainNavigationRouteNames.auth;
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}
