import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:new_version/new_version.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hrms/translations/locale_keys.g.dart';

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

final dropDownItem = DropdownMenuItem(
  child: Text(LocaleKeys.dropdown_all_text.tr()),
  value: null,
);

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
        return LocaleKeys.high_level_text.tr();
      case importanceEnums.medium:
        return LocaleKeys.medium_level_text.tr();
      case importanceEnums.low:
        return LocaleKeys.low_level_text.tr();
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
        return LocaleKeys.man.tr();
      case sexEnums.female:
        return LocaleKeys.woman.tr();
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
  } else if (statusId == 18 || statusId == 8 || statusId == 5) {
    return Colors.blueAccent;
  } else {
    return Colors.red;
  }
}
