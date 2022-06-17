import 'package:flutter/material.dart';
import 'package:hrms/data/models/persons/person.dart';
import 'package:hrms/data/models/persons/persons.dart';
import 'package:hrms/data/models/roles/role.dart';
import 'package:hrms/data/models/roles/roles.dart';
import 'package:hrms/data/models/users/user.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/user_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:collection/collection.dart';

class UserEditData {
  bool isInitializing = true;
  bool isLoading = false;
  List<Person> persons = [];
  TextEditingController usernameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController fioController = TextEditingController();
  int? personId;
  int roleId = 1;
  List<DropdownMenuItem<int>> dropdownMenuItems = [];
}

class EditUserViewModel extends ChangeNotifier {
  final _usersService = UsersService();
  final _authService = AuthService();

  final int userId;
  List<DropdownMenuItem<int>> rolesItem = [];

  final data = UserEditData();

  EditUserViewModel(this.userId);

  Future<void> loadUser(BuildContext context) async {
    try {
      final persons = await _usersService.getPersons();
      final user = await _usersService.getUser(userId);
      final roles = await _usersService.getRoles(true);
      updateData(user, roles, persons);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(User? user, Roles? roles, Persons? persons) {
    data.isInitializing = user == null;
    if (user == null || roles == null || persons == null) {
      notifyListeners();
      return;
    }
    data.personId = user.personId;
    data.usernameController.text = user.username;
    data.persons.addAll(persons.result.persons);
    data.fioController.text = persons.result.persons.firstWhereOrNull((person) => person.id == data.personId)?.fullName ?? '';
    data.roleId = user.roleId;
    if (roles.result.roles.isNotEmpty) {
      for (Role role in roles.result.roles) {
        var item = DropdownMenuItem(
          child: Text(role.name),
          value: role.id,
        );
        rolesItem.add(item);
      }
      data.dropdownMenuItems = rolesItem;
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
        throw UnimplementedError(exception.type.toString());
    }
  }

  void setRole(dynamic value) {
    if (value == data.roleId) {
      return;
    }
    data.roleId = value;
    notifyListeners();
  }

  Future<void> updateUser(BuildContext context) async {
    if ((data.personId != null && data.fioController.text != '') &&
        data.usernameController.text != '') {
      data.isLoading = true;
      notifyListeners();
      await _usersService
          .updateUser(
        userId: userId,
        personId: data.personId!,
        username: data.usernameController.text,
        roleId: data.roleId,
        password: data.userPasswordController.text != ''
            ? data.userPasswordController.text
            : null,
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
