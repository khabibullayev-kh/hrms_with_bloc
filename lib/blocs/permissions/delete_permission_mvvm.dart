import 'package:flutter/material.dart';
import 'package:hrms/blocs/permissions/permissions_bloc.dart';
import 'package:hrms/domain/services/permissions_service.dart';

class PermissionDeleteData {
  bool isLoading = false;
}

class DeletePermissionViewModel extends ChangeNotifier {
  final _permissionsService = PermissionsService();

  final data = PermissionDeleteData();

  final int permissionId;
  final PermissionsBloc bloc;

  DeletePermissionViewModel({required this.permissionId, required this.bloc});

  Future<void> deletePermission(int permissionId, BuildContext context) async {
    data.isLoading = true;
    notifyListeners();
    await _permissionsService.deletePermission(permissionId).whenComplete(() => {
      Navigator.pop(context),
      bloc.add(PermissionsReloadEvent(
        bloc.state.searchQuery,
        bloc.state.permissionsContainer.permissions.length == 1
            ? bloc.state.currentPage - 1
            : bloc.state.currentPage,
      )),
    });
  }
}
