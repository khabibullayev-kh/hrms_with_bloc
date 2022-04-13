import 'package:flutter/material.dart';
import 'package:hrms/data/models/persons/person.dart';
import 'package:hrms/data/models/persons/persons.dart';
import 'package:hrms/data/models/roles/role.dart';
import 'package:hrms/data/models/roles/roles.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/user_service.dart';
import 'package:hrms/navigation/main_navigation.dart';
import 'package:nb_utils/nb_utils.dart';

class UserAddData {
  bool isInitializing = true;
  bool isLoading = false;
  List<Person> persons = [];
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController fioController = TextEditingController();
  int? personId;
  int roleId = 1;
  List<DropdownMenuItem<int>> dropdownMenuItems = [];
}

class AddUserViewModel extends ChangeNotifier {
  final _usersService = UsersService();

  final _authService = AuthService();

  List<DropdownMenuItem<int>> rolesItem = [];

  final data = UserAddData();

  AddUserViewModel();

  Future<void> loadUser(BuildContext context) async {
    try {
      final results = await Future.wait([
        _usersService.getPersons(),
        _usersService.getRoles(true),
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
    final Persons persons = results[0];
    data.persons.add(Person(id: null, fullName: ''));
    data.persons.addAll(persons.result.persons);
    final Roles roles = results[1];
    if (roles.result.roles.isNotEmpty) {
      data.roleId = roles.result.roles[0].id;
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
        print(exception);
    }
  }

  void setRole(dynamic value) {
    if (value == data.roleId) {
      return;
    }
    data.roleId = value;
    notifyListeners();
  }

  void updateUser(BuildContext context) async {
    if (data.userNameController.text != '' &&
        (data.personId != null && data.fioController.text != '') &&
        data.userPasswordController.text != '') {
      data.isLoading = true;
      notifyListeners();
      await _usersService
          .addUser(
        personId: data.personId!,
        username: data.userNameController.text,
        roleId: data.roleId,
        password: data.userPasswordController.text,
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
