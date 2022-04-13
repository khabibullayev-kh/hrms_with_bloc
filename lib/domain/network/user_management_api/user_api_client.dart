import 'package:hrms/data/models/director_rec_kadr_regman/director.dart';
import 'package:hrms/data/models/users/user.dart';
import 'package:hrms/data/models/users/users.dart';
import 'package:hrms/domain/network/network_utils.dart';

class UsersApiClient {
  Future<UsersResponse> getUsersRequest(int page, String search) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'users/get?page=$page&search=$search',
        method: HttpMethod.GET,
      ),
    );
    final response = UsersResponse.fromJson(decoded);
    return response;
  }

  Future<List<Director>> getRoles(int roleId) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'users/get?role_id=$roleId',
        method: HttpMethod.GET,
      ),
    );
    final response = List<Director>.from(
      decoded['result']['users']['users'].map(
        (x) => Director.fromJson(x),
      ),
    );
    return response;
  }

  Future<User> getUser({required int id}) async {
    final decoded = await handleResponse(
      await buildHttpResponse('users/get/$id?', method: HttpMethod.GET),
    );
    return User.fromJson(decoded['result']['user']);
  }

  Future<void> updateUser({
    required int userId,
    required int personId,
    required String username,
    String? password,
    required int roleId,
  }) async {
    await handleResponse(
      await buildHttpResponse(
        'users/update/$userId?role_id=$roleId&person_id=$personId&id=$userId&username=$username&password=$password',
        method: HttpMethod.PATCH,
      ),
    );
  }

  Future<void> addUser({
    required int personId,
    required String username,
    required String password,
    required int roleId,
  }) async {
    await handleResponse(
      await buildHttpResponse(
        'users/create?role_id=$roleId&person_id=$personId&username=$username&password=$password',
        method: HttpMethod.POST,
      ),
    );
  }

  Future<void> deleteUser({required int id}) async {
    await handleResponse(
      await buildHttpResponse('users/$id', method: HttpMethod.DELETE),
    );
  }
}
