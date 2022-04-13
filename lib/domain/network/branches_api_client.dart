import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/branches/branches.dart';
import 'package:hrms/domain/network/network_utils.dart';

class BranchesApiClient {
  Future<Branches> getBranches({
    String? searchQuery,
    int? page,
    String? shopCategory,
    int? regionId,
    bool? isPagination,
    bool? isContentFull,
  }) async {
    final decoded = await handleResponse(
      await buildHttpResponse(
        'branches/get?' +
            (isPagination == null
                ? (('search=$searchQuery&page=$page') +
                    (shopCategory != null
                        ? '&shop_category=$shopCategory'
                        : '') +
                    (regionId != null ? '&region_id=$regionId' : ''))
                : 'pagination=0') +
            (isContentFull != null ? '&content=full' : ''),
        method: HttpMethod.GET,
      ),
    );
    final response = Branches.fromJson(decoded);
    return response;
  }

  Future<Branch> getBranch({required int id}) async {
    final decoded = await handleResponse(
      await buildHttpResponse('branches/get/$id?', method: HttpMethod.GET),
    );
    return Branch.fromJson(decoded['result']['branch']);
  }

  Future<void> deleteBranch({required int id}) async {
    await handleResponse(
      await buildHttpResponse('branches/$id', method: HttpMethod.DELETE),
    );
  }

  Future<void> updateBranch({
    required int branchId,
    required String nameUz,
    required String nameRu,
    required String address,
    required String landmark,
    required String shopCategory,
    required int regId,
    required int distId,
    required List recruiters,
    required int dirId,
    required List kadrs,
    required int regManagerId,
  }) async {
    Map recruitersData = {for (var item in recruiters) 'recruiters[$item]': '$item'};
    Map kadrsData = {for (var item in kadrs) 'personnel_officers[$item]': '$item'};
    Map data = {...kadrsData, ...recruitersData};
    await handleResponse(
      await buildHttpResponse(
        'branches/update/$branchId?name_uz=$nameUz&name_ru=$nameRu'
            '&address=$address&landmark=$landmark&shop_category=$shopCategory'
            '&region_id=$regId&district_id=$distId'
            '&director_id=$dirId&regional_manager_id=$regManagerId',
        method: HttpMethod.PATCH,
        request: data,
      ),
    );
  }

  Future<void> addBranch({
    required String nameUz,
    required String nameRu,
    required String address,
    required String landmark,
    required String shopCategory,
    required int regId,
    required int distId,
    required List recruiters,
    required int dirId,
    required List kadrs,
    required int regManagerId,
  }) async {
    Map recruitersData = {for (var item in recruiters) 'recruiters[$item]': '$item'};
    Map kadrsData = {for (var item in kadrs) 'personnel_officers[$item]': '$item'};
    Map data = {...kadrsData, ...recruitersData};
    await handleResponse(
      await buildHttpResponse(
        'branches/create?name_uz=$nameUz&name_ru=$nameRu&address=$address&'
        'landmark=$landmark&shop_category=$shopCategory&region_id=$regId&'
        'district_id=$distId&director_id=$dirId&'
        'regional_manager_id=$regManagerId',
        method: HttpMethod.POST,
        request: data,
      ),
    );
  }
}
