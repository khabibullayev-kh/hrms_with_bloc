import 'package:flutter/material.dart';
import 'package:hrms/blocs/branches/branches_bloc.dart';
import 'package:hrms/domain/services/branches_service.dart';

class BranchDeleteData {
  bool isLoading = false;
}

class DeleteBranchViewModel extends ChangeNotifier {
  final _branchesService = BranchesService();

  final data = BranchDeleteData();

  final int branchId;
  final BranchesBloc bloc;

  DeleteBranchViewModel({required this.branchId, required this.bloc});

  Future<void> deleteBranch(int branchId, BuildContext context) async {
    data.isLoading = true;
    notifyListeners();
    await _branchesService.deleteBranch(branchId).whenComplete(() => {
      Navigator.pop(context),
      bloc.add(BranchesReloadEvent(
        bloc.state.searchQuery,
        bloc.state.branchesContainer.branches.length == 1
            ? bloc.state.currentPage - 1
            : bloc.state.currentPage,
        bloc.state.branchesContainer.branches.length == 1 ? null : bloc.state.regionId,
        bloc.state.branchesContainer.branches.length == 1 ? null : bloc.state.shopCategory,
      )),
    });
  }
}
