import 'package:hrms/data/models/roles/roles.dart';
import 'package:hrms/data/models/user.dart';
import 'package:hrms/domain/network/user_management_api/roles_api_client.dart';
import 'package:hrms/domain/network/user_management_api/user_api_client.dart';

class UsersService {
  final _userApiClient = UsersApiClient();
  final _rolesApiClient = RolesApiClient();

  Future<User> getUser(int id) async {
    return _userApiClient.getUser(id: id);
  }

  Future<Roles> getRoles(bool isPaginated) async {
    return _rolesApiClient.getRolesRequest(isPaginated: isPaginated);
  }

  Future<void> updateUser({
    required int userId,
    required String name,
    required String lastName,
    required String email,
    required String username,
    String? password,
    required int roleId,
  }) async {
    await _userApiClient.updateUser(
      userId: userId,
      name: name,
      lastName: lastName,
      email: email,
      username: username,
      roleId: roleId,
      password: password,
    );
  }

  Future<void> addUser({
    required String name,
    required String lastName,
    required String email,
    required String username,
    required String password,
    required int roleId,
  }) async {
    await _userApiClient.addUser(
      name: name,
      lastName: lastName,
      email: email,
      username: username,
      roleId: roleId,
      password: password
    );
  }

  Future<void> deleteUser(int id) async {
    await _userApiClient.deleteUser(id: id);
  }
}
