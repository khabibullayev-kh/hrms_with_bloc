import 'package:hrms/data/models/auth_info.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/network/network_utils.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthApiClient {
  Future auth({required String username, required String password}) async {
    return handleResponse(await buildHttpResponse(
        'auth/login?username=$username&password=$password',
        request: {},
        method: HttpMethod.POST));
  }

  Future<void> gerUserInfoRequest() async {
    final response = await handleResponse(await buildHttpResponse('auth/user?',
        request: {}, method: HttpMethod.GET));
    AuthInfo authInfo = AuthInfo.fromJson(response['result']);
    await SharedPreferences.getInstance().then((value) {
      value.setString(USER_NAME, authInfo.firstName + ' ' + authInfo.lastName);
      value.setString(ROLE_NAME, authInfo.role!);
      value.setInt(ROLE_ID, authInfo.roleId!);
      value.setString(SEX, authInfo.sex!);
      value.setStringList(PERMISSIONS, authInfo.permissions!);
      print(value.getInt(ROLE_ID));
    });
  }
}
