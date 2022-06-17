import 'package:flutter/material.dart';
import 'package:hrms/data/models/director_rec_kadr_regman/director.dart';
import 'package:hrms/data/models/region_district/district.dart';
import 'package:hrms/data/resources/common.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/branches_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

class BranchEditData {
  bool isInitializing = true;
  bool isLoading = false;
  TextEditingController branchNameUzController = TextEditingController();
  TextEditingController branchNameRuController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  List<DropdownMenuItem<String>> shopCategoriesItems =
      shopCategories.values.map((shopCategories classType) {
    return DropdownMenuItem<String>(
      value: classType.convertToString,
      child: Text(classType.convertToString),
    );
  }).toList();
  List<DropdownMenuItem<int>> regionsItems = [];
  List<DropdownMenuItem<int>> districtItems = [];
  List<DropdownMenuItem<int>> directorsItems = [];
  List<DropdownMenuItem<int>> regManagersItems = [];
  List<MultiSelectItem> recruiterItems = [];
  List chosenRecruiters = [];
  List<MultiSelectItem> kadrsItems = [];
  List chosenKadrs = [];
  String shopCategory = 'A';
  int regionId = 1;
  int districtId = 1;
  int directorId = 1;
  int regManagersId = 1;
  int branchId = 1;
}

class EditBranchViewModel extends ChangeNotifier {
  final _branchesService = BranchesService();
  final _authService = AuthService();

  final int branchId;

  final data = BranchEditData();

  EditBranchViewModel({required this.branchId});

  Future<void> loadBranch(BuildContext context) async {
    try {
      await _branchesService.getBranch(branchId).then((value) => {
            data.branchNameUzController.text = value.nameUz!,
            data.branchNameRuController.text = value.nameRu!,
            data.addressController.text = value.address!,
            data.landmarkController.text = value.landmark!,
            data.shopCategory = value.shopCategory!,
            data.regionId = value.region!.id,
            data.districtId = value.district!.id,
            for (Director i in value.kadrs!) {data.chosenKadrs.add(i.id)},
            data.directorId = value.director!.id,
            for (Director i in value.recruiters!)
              {data.chosenRecruiters.add(i.id)},
            data.regManagersId = value.regionalManager!.id,
          });

      final results = await Future.wait([
        _branchesService.getRegions(),
        _branchesService.getDistricts(data.regionId),
        _branchesService.getRoles(KADR_ROLE_ID),
        _branchesService.getRoles(DIRECTOR_ROLE_ID),
        _branchesService.getRoles(REG_MANAGER_ROLE_ID),
        _branchesService.getRoles(RECRUITER_ROLE_ID),
      ]);
      updateData(results);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(final results) {
    data.isInitializing = results == null;
    if (results == null) {
      notifyListeners();
      return;
    }
    final List<District> regions = results[0];
    final List<District> districts = results[1];
    final List<Director> kadr = results[2];
    final List<Director> directors = results[3];
    final List<Director> regManagers = results[4];
    final List<Director> recruiters = results[5];
    if (regions.isNotEmpty) {
      data.regionsItems = regions
          .map((District district) => DropdownMenuItem<int>(
                child: Text(district.name!),
                value: district.id,
              ))
          .toList();
    }
    if (districts.isNotEmpty) {
      data.districtItems = districts
          .map((District district) => DropdownMenuItem<int>(
                child: Text(district.name!),
                value: district.id,
              ))
          .toList();
    }
    if (kadr.isNotEmpty) {
      data.kadrsItems = kadr
          .map((Director user) => MultiSelectItem<int>(
                user.id,
                user.fullName,
              ))
          .toList();
    }
    if (directors.isNotEmpty) {
      data.directorsItems = directors
          .map((Director user) => DropdownMenuItem<int>(
                child: Text(user.fullName),
                value: user.id,
              ))
          .toList();
    }
    if (regManagers.isNotEmpty) {
      data.regManagersItems = regManagers
          .map((Director user) => DropdownMenuItem<int>(
                child: Text(user.fullName),
                value: user.id,
              ))
          .toList();
    }
    if (recruiters.isNotEmpty) {
      data.recruiterItems = recruiters
          .map((Director user) => MultiSelectItem<int>(
                user.id,
                user.fullName,
              ))
          .toList();
    }
    notifyListeners();
  }

  void _handleApiClientException(
    ApiClientException exception,
    BuildContext context,
  ) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        throw UnimplementedError(exception.type.name);
    }
  }

  void setShopCategory(dynamic value) {
    if (value == data.shopCategory) {
      return;
    }
    data.shopCategory = value;
    notifyListeners();
  }

  void setRegion(dynamic value) async {
    if (value == data.regionId) {
      return;
    }
    data.regionId = value;
    notifyListeners();
    final results = await Future.wait([
      _branchesService.getDistricts(data.regionId),
    ]);
    updateDistrict(results);
    //notifyListeners();
  }

  updateDistrict(final results) async {
    final List<District> districts = results[0];
    if (districts.isNotEmpty) {
      data.districtId = districts[0].id;
      data.districtItems = districts
          .map((District district) => DropdownMenuItem<int>(
                child: Text(district.name!),
                value: district.id,
              ))
          .toList();
      notifyListeners();
    }
  }

  void setDistrict(dynamic value) {
    if (value == data.districtId) {
      return;
    }
    data.districtId = value;
    notifyListeners();
  }

  void setKadr(dynamic values) {
    data.chosenKadrs = values;
    notifyListeners();
  }

  void setDirector(dynamic value) {
    if (value == data.directorId) {
      return;
    }
    data.directorId = value;
    notifyListeners();
  }

  void setRecruiter(dynamic values) {
    data.chosenRecruiters = values;
    notifyListeners();
  }

  void setRegManager(dynamic value) {
    if (value == data.regManagersId) {
      return;
    }
    data.regManagersId = value;
    notifyListeners();
  }

  Future<void> updateBranch(BuildContext context) async {
    if (data.branchNameUzController.text.isNotEmpty &&
        data.branchNameRuController.text.isNotEmpty &&
        data.addressController.text.isNotEmpty &&
        data.landmarkController.text.isNotEmpty &&
        data.chosenKadrs.isNotEmpty &&
        data.chosenRecruiters.isNotEmpty) {
      data.isLoading = true;
      notifyListeners();
      await _branchesService
          .updateBranch(
        branchId: branchId,
        nameUz: data.branchNameUzController.text,
        nameRu: data.branchNameRuController.text,
        address: data.addressController.text,
        landmark: data.landmarkController.text,
        shopCategory: data.shopCategory,
        regId: data.regionId,
        distId: data.districtId,
        recruiters: data.chosenRecruiters,
        dirId: data.directorId,
        kadrs: data.chosenKadrs,
        regManagerId: data.regManagersId,
      )
          .whenComplete(() {
        Navigator.pop(context, true);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Заполните все поля",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
