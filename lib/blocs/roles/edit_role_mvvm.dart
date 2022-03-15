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

class RoleEditData {
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

class EditRoleViewModel extends ChangeNotifier {
  final _roleService = RolesService();
  final _authService = AuthService();

  final data = RoleEditData();

  final int roleId;

  EditRoleViewModel({required this.roleId});

  Future<void> loadRole(BuildContext context) async {
    try {
      final permissions = await _roleService.getPermissions(true);
      final role = await _roleService.getRole(roleId);
      updateData(permissions, role);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(Permissions? permissions, Role? role) {
    data.isInitializing = permissions == null;
    if (permissions == null || role == null) {
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
      data.role = role;
      data.roleNameController.text = role.name;
      data.roleNameUzController.text = role.nameUz!;
      data.roleNameRuController.text = role.nameRu!;
      for(Permission i in role.permissions!) {
          data.chosenPermissions.add(i.id);
      }
      notifyListeners();
    }
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
          .updateRole(
        roleId: roleId,
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
