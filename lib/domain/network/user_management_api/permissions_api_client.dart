import 'package:hrms/data/models/permissions/permission.dart';
import 'package:hrms/data/models/permissions/permissions.dart';
import 'package:hrms/domain/network/network_utils.dart';

class PermissionsApiClient{
  Future<Permissions> getPermissionsRequest({
    required bool isPaginated,
    String? searchQuery,
    int? page,
  }) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'permissions/get?' + (isPaginated ? 'pagination=0' : 'page=$page&search=$searchQuery'),
        method: HttpMethod.GET,
      ),
    );
    final response = Permissions.fromJson(decoded);
    return response;
  }

  Future<Permission> getPermission({required int id}) async {
    final decoded = await handleResponse(
      await buildHttpResponse('permissions/get/$id?', method: HttpMethod.GET),
    );
    return Permission.fromJson(decoded['result']['permission']);
  }

  Future<void> deletePermission({required int id}) async {
    await handleResponse(
      await buildHttpResponse('permissions/$id', method: HttpMethod.DELETE),
    );
  }

  updatePermission({
    required int permissionId,
    required String name,
    required String nameUz,
    required String nameRu,
  }) async {
    await handleResponse(
      await buildHttpResponse(
        'permissions/update/$permissionId?name=$name&name_uz=$nameUz&name_ru=$nameRu',
        method: HttpMethod.PATCH,
      ),
    );
  }

  Future<void> addPermission({
    required String nameUz,
    required String nameRu,
    required String name,
  }) async {
    await handleResponse(
      await buildHttpResponse(
        'permissions/create?name=$name&name_uz=$nameUz&name_ru=$nameRu',
        method: HttpMethod.POST,
      ),
    );
  }
}