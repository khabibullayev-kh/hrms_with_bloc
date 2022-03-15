import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms/data/models/shifts/shift.dart';
import 'package:hrms/domain/services/shifts_service.dart';
import 'package:image_picker/image_picker.dart';

class ChangeStatusData {
  bool isNextStateLoading = false;
  bool isCancelLoading = false;
  PickedFile? pickedFile;
  TextEditingController commentController = TextEditingController();
}

class ChangeShiftsStatusViewModel extends ChangeNotifier {
  final Shift shift;

  ChangeShiftsStatusViewModel({required this.shift});

  final data = ChangeStatusData();
  final _shiftsService = ShiftsService();

  bool isLoading() {
    return data.isNextStateLoading || data.isCancelLoading;
  }

  openGallery() async {
    final pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      data.pickedFile = pickedFile;
    } else {
      print('No image selected.');
    }
    notifyListeners();
  }

  openCamera() async {
    final pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      data.pickedFile = pickedFile;
    } else {
      print('No image selected.');
    }
    notifyListeners();
  }

  Future<void> cancelState(BuildContext context) async {
    data.isCancelLoading = true;
    notifyListeners();
    await _shiftsService
        .updateState(
          action: 'cancel',
          shiftId: shift.id,
          message: data.commentController.text,
        )
        .whenComplete(() => Navigator.pop(context, true));
  }

  Future<void> updateFirstState(BuildContext context) async {
    data.isNextStateLoading = true;
    //print(data.pickedFile?.path);
    notifyListeners();
    await _shiftsService
        .updateState(
          shiftId: shift.id,
          message: data.commentController.text.isEmpty
              ? '-'
              : data.commentController.text,
          fileImage:
              data.pickedFile != null ? File(data.pickedFile!.path) : null,
        )
        .whenComplete(() => Navigator.pop(context, true));
  }
}
