
import 'package:hrms/data/data_provider/session_data_provider.dart';
import 'package:hrms/domain/network/auth_api_client.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthService {
  final _authApiClient = AuthApiClient();
  final _sessionDataProvider = SessionDataProvider();

  Future<bool> isAuth() async {
    final token = await _sessionDataProvider.getToken();
    final isAuth = token != null;
    return isAuth;
  }

  Future<void> login(String login, String password) async {
    final response = await _authApiClient.auth(
      username: login,
      password: password,
    );
    _sessionDataProvider.setToken(response['access_token']);
  }

  Future<void> userInfo() async {
   await _authApiClient.gerUserInfoRequest();
  }

  Future<void> logout() async {
    await _sessionDataProvider.deleteToken();
    clearSharedPref();
  }
}
