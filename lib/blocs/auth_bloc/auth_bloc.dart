import 'package:flutter/material.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:nb_utils/nb_utils.dart';


class AuthViewModel extends ChangeNotifier {
  final _authService = AuthService();

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final loginFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  bool _obscureText = true;

  bool get obscureText => _obscureText;

  bool _keyboardVisible = false;

  bool get keyboardVisible => _keyboardVisible;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;

  bool get canStartAuth => !_isAuthProgress;

  bool get isAuthProgress => _isAuthProgress;

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  AuthViewModel() {
    loginFocusNode.addListener(() {
      loginFocusNode.hasFocus
          ? _keyboardVisible = true
          : _keyboardVisible = false;
    });
    passwordFocusNode.addListener(() {
      passwordFocusNode.hasFocus
          ? _keyboardVisible = true
          : _keyboardVisible = false;
    });
  }

  Future<String?> _login(String login, String password) async {

    try {
      await _authService.login(login, password);
      await setValue(LOGIN, login);
      await setValue(PASSWORD, password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          return 'Сервер не доступен. Проверте подключение к интернету';
        case ApiClientExceptionType.auth:
          await removeKey(LOGIN);
          await removeKey(PASSWORD);
          return 'Неправильный логин или пароль!';
        case ApiClientExceptionType.sessionExpired:
        case ApiClientExceptionType.other:
          await removeKey(LOGIN);
          await removeKey(PASSWORD);
          return 'Произошла ошибка. Попробуйте еще раз';
      }
    } catch (e) {
      return 'Неизвестная ошибка, поторите попытку или проверьте подключение к интернету';
    }
    return null;
  }

  Future<void> authenticate(BuildContext context) async {
    final login = loginTextController.text.isEmpty
        ? getStringAsync(LOGIN)
        : loginTextController.text;
    final password = passwordTextController.text.isEmpty
        ? getStringAsync(PASSWORD)
        : passwordTextController.text;
    loginTextController.text = login;
    passwordTextController.text = password;
    loginTextController.selection = TextSelection.fromPosition(TextPosition(offset: loginTextController.text.length));
    passwordTextController.selection = TextSelection.fromPosition(TextPosition(offset: passwordTextController.text.length));
    if (!_isValid(login, password)) {
      _updateState('Заполните логин и пароль', false);
      return;
    }
    _updateState(null, true);

    _errorMessage = await _login(login, password);
    if (_errorMessage == null) {
      await _authService.userInfo().whenComplete(() {
        MainNavigation.resetNavigation(context);
        _updateState(_errorMessage, false);
      });
    } else {
      _updateState(_errorMessage, false);
    }
  }

  void showPassword() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  void _updateState(String? errorMessage, bool isAuthProgress) {
    if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
      return;
    }
    _errorMessage = errorMessage;
    _isAuthProgress = isAuthProgress;
    notifyListeners();
  }
}
