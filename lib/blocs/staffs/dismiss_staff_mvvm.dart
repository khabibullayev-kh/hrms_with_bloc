import 'package:flutter/material.dart';
import 'package:hrms/blocs/staffs/staffs_bloc.dart';
import 'package:hrms/data/resources/colors.dart';
import 'package:hrms/domain/services/staffs_service.dart';
import 'package:nb_utils/nb_utils.dart';

class DismissStaffData {
  bool isLoading = false;
  DateTime selectedDateTime = DateTime.now();
  TextEditingController dateOfDismiss = TextEditingController();
}

class DismissStaffViewModel extends ChangeNotifier {
  final _staffsService = StaffsService();

  final data = DismissStaffData();

  final int staffId;
  final StaffsBloc bloc;

  DismissStaffViewModel({required this.staffId, required this.bloc});

  Future<void> deleteBranch(BuildContext context) async {
    if (data.dateOfDismiss.text.isNotEmpty) {
      data.isLoading = true;
      notifyListeners();
      await _staffsService
          .dismissStaff(staffId, data.dateOfDismiss.text)
          .whenComplete(() => {
                Navigator.pop(context),
                bloc.add(const StaffsReloadEvent()),
              });
    } else {
      Fluttertoast.showToast(
          msg: 'Выберите дату увольнения',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  selectDate({required BuildContext? context}) async {
    final DateTime? picked = await showDatePicker(
        context: context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime.now().add(const Duration(days: 1000)),
        initialDatePickerMode: DatePickerMode.day,
        helpText: 'Выберите дату',
        cancelText: 'Отменить',
        confirmText: 'Ок',
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: HRMSColors.green,
              colorScheme: const ColorScheme.light(primary: HRMSColors.green),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        });
    if (picked != null && picked != data.selectedDateTime) {
      data.selectedDateTime = picked;
      data.dateOfDismiss.text =
          "${data.selectedDateTime.day.toString().padLeft(2, '0')}"
                  ".${data.selectedDateTime.month.toString().padLeft(2, '0')}"
                  ".${data.selectedDateTime.year.toString().padLeft(2, '0')}"
              .split(' ')[0];
      notifyListeners();
    }
  }

  clearDate() {
    data.dateOfDismiss.clear();
    notifyListeners();
  }
}
