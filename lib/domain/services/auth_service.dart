
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hrms/data/data_provider/session_data_provider.dart';
import 'package:hrms/data/resources/keys.dart';
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
    //clearSharedPref();
  }

  Future<void> deleteTokenFromDB() async {
    // Assume user is logged in for this example
    await FirebaseFirestore.instance
        .collection('users')
        .doc(getIntAsync(ROLE_ID).toString())
        .delete();
  }

  Future<void> logoutAndDeleteData() async {
    await _sessionDataProvider.deleteToken();
    await removeKey(LOGIN);
    await removeKey(PASSWORD);
    await deleteTokenFromDB();
  }

}
