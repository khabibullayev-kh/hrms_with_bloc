import 'package:flutter/material.dart';
import 'package:hrms/blocs/roles/roles_bloc.dart';
import 'package:hrms/domain/services/roles_service.dart';

class RoleDeleteData {
  bool isLoading = false;
}

class DeleteRoleViewModel extends ChangeNotifier {
  final _roleService = RolesService();

  final data = RoleDeleteData();

  final int roleId;
  final RolesBloc rolesBloc;

  DeleteRoleViewModel({required this.roleId, required this.rolesBloc});

  Future<void> deleteRole(int roleId, BuildContext context) async {
    data.isLoading = true;
    notifyListeners();
    await _roleService.deleteRole(roleId).whenComplete(() => {
      Navigator.pop(context),
      rolesBloc.add(RolesReloadEvent(
        rolesBloc.state.searchQuery,
        rolesBloc.state.rolesContainer.roles.length == 1
            ? rolesBloc.state.currentPage - 1
            : rolesBloc.state.currentPage,
      )),
    });
  }
}
