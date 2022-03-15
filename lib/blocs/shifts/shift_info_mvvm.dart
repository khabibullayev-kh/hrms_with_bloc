import 'package:flutter/material.dart';
import 'package:hrms/data/models/shifts/shift.dart';
import 'package:hrms/domain/exceptions/api_client_exceptions.dart';
import 'package:hrms/domain/services/auth_service.dart';
import 'package:hrms/domain/services/shifts_service.dart';
import 'package:hrms/navigation/main_navigation.dart';

class ShiftInfoData {
  bool isInitializing = true;
  Shift? shift;
}

class ShiftInfoViewModel extends ChangeNotifier {
  final _shiftsService = ShiftsService();
  final _authService = AuthService();

  final data = ShiftInfoData();

  final int shiftId;

  ShiftInfoViewModel({required this.shiftId});

  Future<void> loadShift(BuildContext context) async {
    try {
      final shift = await _shiftsService.getShift(id: shiftId);
      updateData(shift);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(Shift? shift) {
    data.isInitializing = shift == null;
    if (shift == null) {
      notifyListeners();
      return;
    }
    data.shift = shift;
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
}
