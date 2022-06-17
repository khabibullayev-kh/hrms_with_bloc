import 'package:hrms/data/models/permissions/permission.dart';
import 'package:hrms/data/models/permissions/permissions.dart';
import 'package:hrms/domain/network/user_management_api/permissions_api_client.dart';

class PermissionsService {
  final _permissionsApiClient = PermissionsApiClient();

  Future<Permissions> getPermissions(
      bool isPaginated,
      String searchQuery,
      int page,
      ) async {
    return _permissionsApiClient.getPermissionsRequest(
      isPaginated: isPaginated,
      searchQuery: searchQuery,
      page: page,
    );
  }

  Future<Permission> getPermission(int id) async {
    return _permissionsApiClient.getPermission(id: id);
  }

  Future<void> updatePermission({
    required int permissionId,
    required String name,
    required String nameUz,
    required String nameRu,
  }) async {
    await _permissionsApiClient.updatePermission(
      permissionId: permissionId,
      name: name,
      nameRu: nameRu,
      nameUz: nameUz,
    );
  }

  Future<void> addPermission({
    required String name,
    required String nameUz,
    required String nameRu,
  }) async {
    await _permissionsApiClient.addPermission(
        name: name, nameRu: nameRu, nameUz: nameUz,);
  }

  Future<void> deletePermission(int id) async {
    return _permissionsApiClient.deletePermission(id: id);
  }
}