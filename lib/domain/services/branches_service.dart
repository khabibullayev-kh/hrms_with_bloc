import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/domain/network/branches_api_client.dart';
import 'package:hrms/domain/network/region_district_api_client.dart';
import 'package:hrms/domain/network/user_management_api/user_api_client.dart';

class BranchesService {
  final _branchesApiClient = BranchesApiClient();
  final _usersApiClient = UsersApiClient();
  final _regDistApiClient = RegDistApiClient();

  Future getBranches({
    String? searchQuery,
    int? page,
    String? shopCategory,
    int? regionId,
    bool? isPaginated,
  }) async {
    return _branchesApiClient.getBranches(
      searchQuery: searchQuery,
      page: page,
      shopCategory: shopCategory,
      regionId: regionId,
      isPagination: isPaginated,
    );
  }

  Future getRegions() async {
    return _regDistApiClient.getRegions();
  }

  Future<Branch> getBranch(int id) async {
    return _branchesApiClient.getBranch(id: id);
  }

  Future getDistricts(int regionId) async {
    return _regDistApiClient.getDistricts(regionId);
  }

  Future getRoles(int roleId) async {
    return _usersApiClient.getRoles(roleId);
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
    await _branchesApiClient.updateBranch(
      branchId: branchId,
      nameUz: nameUz,
      nameRu: nameRu,
      address: address,
      landmark: landmark,
      shopCategory: shopCategory,
      regId: regId,
      distId: distId,
      recruiters: recruiters,
      dirId: dirId,
      kadrs: kadrs,
      regManagerId: regManagerId,
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
    await _branchesApiClient.addBranch(
      nameUz: nameUz,
      nameRu: nameRu,
      address: address,
      landmark: landmark,
      shopCategory: shopCategory,
      regId: regId,
      distId: distId,
      recruiters: recruiters,
      dirId: dirId,
      kadrs: kadrs,
      regManagerId: regManagerId,
    );
  }

  Future<void> deleteBranch(int id) async {
    return _branchesApiClient.deleteBranch(id: id);
  }

}
