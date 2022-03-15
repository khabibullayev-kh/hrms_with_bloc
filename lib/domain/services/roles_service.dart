import 'package:hrms/data/models/permissions/permissions.dart';
import 'package:hrms/data/models/roles/role.dart';
import 'package:hrms/data/models/roles/roles.dart';
import 'package:hrms/domain/network/user_management_api/permissions_api_client.dart';
import 'package:hrms/domain/network/user_management_api/roles_api_client.dart';

class RolesService {
  final _rolesApiClient = RolesApiClient();
  final _permissionsApiClient = PermissionsApiClient();

  Future<Roles> getRoles(
    bool isPaginated,
    String searchQuery,
    int page,
  ) async {
    return _rolesApiClient.getRolesRequest(
      isPaginated: isPaginated,
      searchQuery: searchQuery,
      page: page,
    );
  }

  Future<Role> getRole(int id) async {
    return _rolesApiClient.getRole(id: id);
  }

  Future<void> updateRole({
    required int roleId,
    required String name,
    required String nameUz,
    required String nameRu,
    required List permissions,
  }) async {
    await _rolesApiClient.updateRole(
      roleId: roleId,
      name: name,
      nameRu: nameRu,
      nameUz: nameUz,
      permissions: permissions,
    );
  }

  Future<void> addRole({
    required String name,
    required String nameUz,
    required String nameRu,
    required List permissions,
  }) async {
    await _rolesApiClient.addRole(
        name: name, nameRu: nameRu, nameUz: nameUz, permissions: permissions);
  }

  Future<Permissions> getPermissions(bool isPaginated) async {
    return _permissionsApiClient.getPermissionsRequest(
        isPaginated: isPaginated);
  }

  Future<void> deleteRole(int id) async {
    return _rolesApiClient.deleteRole(id: id);
  }
}
