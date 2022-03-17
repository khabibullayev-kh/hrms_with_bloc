import 'package:hrms/data/models/roles/role.dart';
import 'package:hrms/data/models/roles/roles.dart';
import 'package:hrms/domain/network/network_utils.dart';

class RolesApiClient {
  Future<Roles> getRolesRequest({
    required bool isPaginated,
    String? searchQuery,
    int? page,
  }) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'roles/get?' +
            (isPaginated ? 'pagination=0' : 'page=$page&search=$searchQuery'),
        method: HttpMethod.GET,
      ),
    );
    final response = Roles.fromJson(decoded);
    return response;
  }

  Future<Role> getRole({required int id}) async {
    final decoded = await handleResponse(
      await buildHttpResponse('roles/get/$id?', method: HttpMethod.GET),
    );
    return Role.fromJson(decoded['result']['role']);
  }

  Future<void> deleteRole({required int id}) async {
    await handleResponse(
      await buildHttpResponse('roles/$id', method: HttpMethod.DELETE),
    );
  }

  updateRole({
    required int roleId,
    required String name,
    required String nameUz,
    required String nameRu,
    required List permissions,
  }) async {
    Map data = {for (var item in permissions) 'permissions[$item]': '$item'};
    await handleResponse(
      await buildHttpResponse(
        'roles/update/$roleId?name=$name&name_uz=$nameUz&name_ru=$nameRu',
        method: HttpMethod.PATCH,
        request: data,
      ),
    );
  }

  Future<void> addRole({
    required String nameUz,
    required String nameRu,
    required String name,
    required List permissions,
  }) async {
    Map data = {for (var item in permissions) 'permissions[$item]': '$item'};
    await handleResponse(
      await buildHttpResponse(
        'roles/create?name=$name&name_uz=$nameUz&name_ru=$nameRu',
        method: HttpMethod.POST,
        request: data,
      ),
    );
  }
}
