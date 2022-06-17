import 'package:flutter/material.dart';
import 'package:hrms/domain/services/permissions_service.dart';
import 'package:nb_utils/nb_utils.dart';

class PermissionAddData {
  bool isLoading = false;
  TextEditingController roleNameUzController = TextEditingController();
  TextEditingController roleNameRuController = TextEditingController();
  TextEditingController roleNameController = TextEditingController();
}

class AddPermissionViewModel extends ChangeNotifier {
  final _permissionsService = PermissionsService();

  final data = PermissionAddData();

  AddPermissionViewModel();

  void addPermission(BuildContext context) async {
    if (data.roleNameUzController.text != '' &&
        data.roleNameRuController.text != '' &&
        data.roleNameController.text != '') {
      data.isLoading = true;
      notifyListeners();
      await _permissionsService
          .addPermission(
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
