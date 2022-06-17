import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:hrms/data/models/adsources/ad_sources.dart' as dropdown;
import 'package:flutter/material.dart';
import 'package:hrms/data/models/branches/branch.dart';
import 'package:hrms/data/models/candidates/candidate.dart';
import 'package:hrms/data/models/vacancy/vacancy.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/domain/services/candidates_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';

class ChangeStatusData {
  bool isBlockLoading = false;
  bool isArchiveLoading = false;
  bool isNextStateLoading = false;
  bool isCancelLoading = false;
  bool isUnpackLoading = false;
  TextEditingController commentController = TextEditingController();
  TextEditingController dateOfMeetingController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController chooseFileController = TextEditingController();
  File? file;
  List<DropdownMenuItem<int?>> branchesItems = [
    const DropdownMenuItem(child: Text('Загрузка...'), value: null)
  ];
  List<DropdownMenuItem<int?>>? vacancyItems = [
    const DropdownMenuItem(child: Text('Загрузка...'), value: null)
  ];
  List<DropdownMenuItem<int?>> adSourcesItems = [
    const DropdownMenuItem(child: Text('Загрузка...'), value: null)
  ];
  int? branchId;
  int? vacancyId;
  int? adSourceId;
}

class ChangeCandidateStatusViewModel extends ChangeNotifier {
  final Candidate candidate;

  ChangeCandidateStatusViewModel({required this.candidate}) {
    if (candidate.state!.id == 15) {
      loadData(candidate);
    }
  }

  final data = ChangeStatusData();
  final _candidatesService = CandidatesService();

  Future<void> loadData(Candidate candidate) async {
    if (candidate.state!.id == 15) {
      await _candidatesService
          .getBranches(isPaginated: true)
          .then((value) async {
        data.branchId = value.result.branches[0].id;
        data.branchesItems = value.result.branches
            .map((Branch branch) => DropdownMenuItem(
                  child: Text(branch.name!),
                  value: branch.id,
                ))
            .toList();
        await _candidatesService.getAddSources().then((value) async {
          data.adSourceId = value[0].id;
          data.adSourcesItems = value
              .map((dropdown.AdSource adSource) => DropdownMenuItem(
            child: Text(adSource.name),
            value: adSource.id,
          ))
              .toList();
        });
        await _candidatesService
            .getVacancyPagination(value.result.branches[0].id)
            .then((value) {
          if (value.isNotEmpty) {
            data.vacancyId = value[0].id;
            data.vacancyItems = value
                .map((Vacancy vacancy) => DropdownMenuItem(
                      child: Text(getStringAsync(LANG) == 'ru'
                          ? vacancy.jobPosition!.nameRu!
                          : vacancy.jobPosition!.nameUz!),
                      value: vacancy.id,
                    ))
                .toList();

            notifyListeners();
          } else {
            data.vacancyId = null;
            data.vacancyItems = null;
            notifyListeners();
          }
        });
      });
    }
  }

  Future<void> getVacancies(int branchId) async {
    await _candidatesService.getVacancyPagination(branchId).then((value) {
      if (value.isNotEmpty) {
        data.vacancyId = value[0].id;
        data.vacancyItems = value
            .map((Vacancy vacancy) => DropdownMenuItem(
                  child: Text(getStringAsync(LANG) == 'ru'
                      ? vacancy.jobPosition!.nameRu!
                      : vacancy.jobPosition!.nameUz!),
                  value: vacancy.id,
                ))
            .toList();
        notifyListeners();
      } else {
        data.vacancyId = null;
        data.vacancyItems = null;
        notifyListeners();
      }
    });
  }

  setBranch(dynamic value) {
    if (value == data.branchId) {
      return;
    }
    data.branchId = value;
    getVacancies(data.branchId!);
    notifyListeners();
  }

  void setVacancy(dynamic value) {
    if (value == data.vacancyId) {
      return;
    }
    data.vacancyId = value;
    notifyListeners();
  }

  void setAdSource(dynamic value) {
    if (value == data.adSourceId) {
      return;
    }
    data.adSourceId = value;
    notifyListeners();
  }

  bool isLoading() {
    return data.isNextStateLoading ||
        data.isArchiveLoading ||
        data.isBlockLoading ||
        data.isCancelLoading;
  }

  void chooseFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'svg', 'pdf', 'doc', 'docx']

    );
    if (result != null) {
      data.file = File(result.files.single.path.toString());
      data.chooseFileController.text = basename(data.file!.path);
    } else {
      // User canceled the picker
    }
  }

  Future<void> reserveState(BuildContext context) async {
    data.isArchiveLoading = true;
    notifyListeners();
    if (data.vacancyId != null) {
      await _candidatesService
          .updateState(
        action: 'reserve',
        candidateId: candidate.id ?? 1,
        staffId: data.vacancyId,
        adSourceId: data.adSourceId,
        message: data.commentController.text,
      )
          .whenComplete(() => Navigator.pop(context, true));
    }

  }

  Future<void> blocState(BuildContext context) async {
    data.isBlockLoading = true;
    notifyListeners();
    await _candidatesService
        .updateState(
          action: 'block',
          candidateId: candidate.id ?? 1,
          message: data.commentController.text,
        )
        .whenComplete(() => Navigator.pop(context, true));
  }

  Future<void> cancelState(BuildContext context) async {
    data.isCancelLoading = true;
    notifyListeners();
    await _candidatesService
        .updateState(
          action: 'cancel',
          candidateId: candidate.id ?? 1,
          message: data.commentController.text,
        )
        .whenComplete(() => Navigator.pop(context, true));
  }

  Future<void> unPackState(BuildContext context) async {
    data.isUnpackLoading = true;
    notifyListeners();
    await _candidatesService
        .updateState(
          action: 'unpack',
          candidateId: candidate.id ?? 1,
          message: data.commentController.text,
        )
        .whenComplete(() => Navigator.pop(context, true));
  }

  Future<void> updateState(BuildContext context) async {
    switch (candidate.state!.id) {
      case 14:
        updateViewedState(context);
        return;
      case 15:
        updateOnMeetingState(context);
        return;
      default:
        updateFirstState(context);
    }
  }

  Future<void> updateFirstState(BuildContext context) async {
    data.isNextStateLoading = true;
    notifyListeners();
    await _candidatesService
        .updateState(
          candidateId: candidate.id ?? 1,
          message: data.commentController.text,
        )
        .whenComplete(() => Navigator.pop(context, true));
  }

  Future<void> updateViewedState(BuildContext context) async {
    if (data.addressController.text.isNotEmpty &&
        data.dateOfMeetingController.text.isNotEmpty) {
      data.isNextStateLoading = true;
      notifyListeners();
      await _candidatesService
          .updateState(
            candidateId: candidate.id ?? 1,
            message: data.commentController.text,
            interviewDate: data.dateOfMeetingController.text,
            interviewAddress: data.addressController.text,
          )
          .whenComplete(() => Navigator.pop(context, true));
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

  Future<void> updateOnMeetingState(BuildContext context) async {
    if (data.vacancyId != null && data.file != null) {
      data.isNextStateLoading = true;
      notifyListeners();
      await _candidatesService
          .changeStateWithJobOffer(
            candidateId: candidate.id ?? 1,
            message: data.commentController.text,
            fileImage: data.file!,
            staffId: data.vacancyId!,
            adSourceId: data.adSourceId!,
          )
          .whenComplete(() => Navigator.pop(context, true));
    } else {
      Fluttertoast.showToast(
          msg: data.file == null ? "Выберите файл!" : "Выберите должность",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
