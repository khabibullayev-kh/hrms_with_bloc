import 'package:flutter/material.dart';
import 'package:hrms/data/models/permissions/permission.dart';
import 'package:hrms/data/models/permissions/permissions.dart';
import 'package:hrms/data/models/roles/role.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/roles_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

class RoleAddData {
  bool isInitializing = true;
  bool isLoading = false;
  TextEditingController roleNameUzController = TextEditingController();
  TextEditingController roleNameRuController = TextEditingController();
  TextEditingController roleNameController = TextEditingController();
  List<MultiSelectItem> items = [];
  List chosenPermissions = [];
  Role role = Role(
    id: 1,
    name: '',
    nameUz: '',
    nameRu: '',
    permissions: [],
  );
}

class AddRoleViewModel extends ChangeNotifier {
  final _roleService = RolesService();
  final _authService = AuthService();

  //List<MultiSelectDialogField> values = [];

  final data = RoleAddData();

  AddRoleViewModel();

  Future<void> loadUser(BuildContext context) async {
    try {
      final permissions = await _roleService.getPermissions(true);
      updateData(permissions);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(Permissions? permissions) {
    data.isInitializing = permissions == null;
    if (permissions == null) {
      notifyListeners();
      return;
    }
    if (permissions.result.permissions.isNotEmpty) {
      List<MultiSelectItem<int>> items = [];
      for (Permission permission in permissions.result.permissions) {
        var item = MultiSelectItem(permission.id, permission.nameRu);
        items.add(item);
      }
      data.items = items;
      notifyListeners();
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
        print(exception);
    }
  }

  void setPermissions(values) {
    data.chosenPermissions = values;
    notifyListeners();
  }

  void addRole(BuildContext context) async {
    if (data.roleNameUzController.text != '' &&
        data.roleNameRuController.text != '' &&
        data.roleNameController.text != '' &&
        data.chosenPermissions.isNotEmpty) {
      data.isLoading = true;
      notifyListeners();
      await _roleService
          .addRole(
        name: data.roleNameController.text,
        nameUz: data.roleNameUzController.text,
        nameRu: data.roleNameRuController.text,
        permissions: data.chosenPermissions,
      ).whenComplete(() {
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
