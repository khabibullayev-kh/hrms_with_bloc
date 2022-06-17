import 'package:flutter/material.dart';
import 'package:hrms/blocs/users/users_bloc.dart';
import 'package:hrms/domain/services/user_service.dart';

class UserDeleteData {
  bool isLoading = false;
}

class DeleteUserViewModel extends ChangeNotifier {
  final _usersService = UsersService();

  final data = UserDeleteData();

  final int userId;
  final UsersBloc usersBloc;

  DeleteUserViewModel({required this.userId, required this.usersBloc});

  Future<void> deleteUser(int userId, BuildContext context) async {
    data.isLoading = true;
    notifyListeners();
    await _usersService.deleteUser(userId).whenComplete(() => {
          Navigator.pop(context),
          usersBloc.add(UsersReloadEvent(
            usersBloc.state.searchQuery,
            usersBloc.state.usersListContainer.users.length == 1
                ? usersBloc.state.currentPage - 1
                : usersBloc.state.currentPage,
          )),
        });
  }
}
