import 'package:flutter/material.dart';
import 'package:hrms/data/models/permissions/permission.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/permissions_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:nb_utils/nb_utils.dart';

class PermissionEditData {
  bool isInitializing = true;
  bool isLoading = false;
  TextEditingController roleNameUzController = TextEditingController();
  TextEditingController roleNameRuController = TextEditingController();
  TextEditingController roleNameController = TextEditingController();
}

class EditPermissionViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final _permissionsService = PermissionsService();

  final data = PermissionEditData();

  final int permissionId;

  EditPermissionViewModel({required this.permissionId});

  Future<void> loadPermission(BuildContext context) async {
    try {
      final permissions = await _permissionsService.getPermission(permissionId);
      updateData(permissions);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(Permission? permission) {
    data.isInitializing = permission == null;
    if (permission == null) {
      notifyListeners();
      return;
    }
    data.roleNameController.text = permission.name;
    data.roleNameUzController.text = permission.nameUz;
    data.roleNameRuController.text = permission.nameRu;
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
        throw UnimplementedError();
    }
  }

  void editPermission(BuildContext context) async {
    if (data.roleNameUzController.text != '' &&
        data.roleNameRuController.text != '' &&
        data.roleNameController.text != '') {
      data.isLoading = true;
      notifyListeners();
      await _permissionsService
          .updatePermission(
        permissionId: permissionId,
        name: data.roleNameController.text,
        nameUz: data.roleNameUzController.text,
        nameRu: data.roleNameRuController.text,
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
        fontSize: 16.0,
      );
    }
  }
}
