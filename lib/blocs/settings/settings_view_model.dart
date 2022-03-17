import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:nb_utils/nb_utils.dart';

class SettingsData {
  String currentLang = getStringAsync(LANG);
  List<DropdownMenuItem<String>> langItems = [
    const DropdownMenuItem(
        child: Text(
          'Русский',
          overflow: TextOverflow.ellipsis,
        ),
        value: 'ru'),
    const DropdownMenuItem(
        child: Text(
          'O\'zbekcha',
          overflow: TextOverflow.ellipsis,
        ),
        value: 'uz')
  ];
}

class SettingsViewModel extends ChangeNotifier {
  final data = SettingsData();

  void setLang(dynamic value, BuildContext context) async {
    if (value == data.currentLang) {
      return;
    }
    data.currentLang = value;
    setValue(LANG, data.currentLang);
    notifyListeners();
    await context.setLocale(Locale(data.currentLang));
  }
}
