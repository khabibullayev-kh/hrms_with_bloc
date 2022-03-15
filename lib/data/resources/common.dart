import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:new_version/new_version.dart';

enum NavbarItem { candidates, shifts, vacancies }

Color getColor(String shopCategory) {
  switch (shopCategory) {
    case 'A':
      return Colors.lightGreen;
    case 'B':
      return Colors.blueAccent;
    case 'C':
      return Colors.deepPurpleAccent;
    case 'D':
      return Colors.redAccent;
    default:
      return Colors.indigo;
  }
}

const kTableColumns = <DataColumn>[
  DataColumn(
      label: Text(
    '№',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
  DataColumn(
      label: Text(
    'ФИО',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
  DataColumn(
      label: Text(
    'Роль',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
  DataColumn(
      label: Text(
    'Действия',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
];

const kPersonsTableColumns = <DataColumn>[
  DataColumn(
      label: Text(
    '№',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
  DataColumn(
      label: Text(
    'ФИО',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
  DataColumn(
      label: Text(
    'Действия',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
];

const kRolesTableColumns = <DataColumn>[
  DataColumn(
      label: Text(
    '№',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
  DataColumn(
      label: Text(
    'Название',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
  DataColumn(
      label: Text(
    'Действия',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
];

const kBranchesTableColumns = <DataColumn>[
  DataColumn(
      label: Text(
    '№',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
  DataColumn(
      label: Text(
    'Название',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
  DataColumn(
      label: Text(
    'Категория',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
  DataColumn(
      label: Text(
    'Действия',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
];

const kDepartmentsTableColumns = <DataColumn>[
  DataColumn(
      label: Text(
    '№',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
  DataColumn(
      label: Text(
    'Название',
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
  DataColumn(
      label: Text(
    'К-во\nдолжностей',
    textAlign: TextAlign.center,
    style: TextStyle(fontWeight: FontWeight.bold),
  )),
];

enum shopCategories { A, B, C, D }

extension ShopCategoriesExtension on shopCategories {
  String get convertToString {
    switch (this) {
      case shopCategories.A:
        return 'A';
      case shopCategories.B:
        return 'B';
      case shopCategories.C:
        return 'C';
      case shopCategories.D:
        return 'D';
    }
  }
}

enum importanceEnums { high, medium, low }

extension ImportanceEnumsExtension on importanceEnums {
  String get convertToString {
    switch (this) {
      case importanceEnums.high:
        return 'Высокий';
      case importanceEnums.medium:
        return 'Средний';
      case importanceEnums.low:
        return 'Низкий';
    }
  }

  int get convertToInt {
    switch (this) {
      case importanceEnums.high:
        return 1;
      case importanceEnums.medium:
        return 2;
      case importanceEnums.low:
        return 3;
    }
  }
}

enum sexEnums { male, female }

extension SexExtension on sexEnums {
  String get convertToString {
    switch (this) {
      case sexEnums.male:
        return 'Мужчина';
      case sexEnums.female:
        return 'Женщина';
    }
  }
}

bool isCan(String permission) {
  if (getStringListAsync(PERMISSIONS) != null &&
      getStringListAsync(PERMISSIONS)!.contains(permission)) {
    return true;
  } else {
    return false;
  }
}

void checkVersion(BuildContext context) async {
  if (Platform.isAndroid) {
    final newVersion =
        NewVersion(androidId: "com.ishonch.hrms", iOSId: "com.ishonch.hrms");
    final status = await newVersion.getVersionStatus();
    status?.localVersion != status?.storeVersion
        ? newVersion.showUpdateDialog(
            context: context,
            versionStatus: status!,
            dialogTitle: "Обновление",
            allowDismissal: Platform.isIOS ? true : false,
            dialogText: "Пожалуйста обновите приложение!",
            updateButtonText: "Обновить",
            dismissButtonText: 'Обновить позже',
            dismissAction: () {
              Navigator.pop(context);
            })
        : print('OK');

    print('asdasd');
    print("DEVICE : " + status!.localVersion);
    print("STORE : " + status.storeVersion);
  }
}

statusColor(int statusId) {
  if (statusId == 13 || statusId == 16 || statusId == 11 || statusId == 6) {
    return const Color(0xFF76AA60);
  } else if (statusId == 14 || statusId == 15) {
    return const Color(0xFF8572BA);
  } else if (statusId == 17 || statusId == 22) {
    return Colors.yellow;
  } else if (statusId == 19) {
    return Colors.black;
  } else if (statusId == 20) {
    return Colors.grey;
  } else if (statusId == 23) {
    return Colors.lightBlueAccent;
  } else if (statusId == 18 || statusId == 8) {
    return Colors.blueAccent;
  } else {
    return Colors.red;
  }
}
