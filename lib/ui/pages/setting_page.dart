import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/blocs/settings/settings_view_model.dart';
import 'package:hrms/ui/widgets/reusable_drop_down_widget.dart';
import 'package:hrms/ui/widgets/side_bar.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hrms/translations/locale_keys.g.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<SettingsViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings_label.tr()),
      ),
      drawer: const SideBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(LocaleKeys.choose_language_text.tr()),
            const SizedBox(height: 8),
            // Platform.isIOS
            //     ? CupertinoPicker(
            //         itemExtent: 32.0,
            //         onSelectedItemChanged: (selectedIndex) =>
            //             model.setLang(selectedIndex, context),
            //         children: model.data.pickerItems,
            //       )
            //     :
            ReusableDropDownButton(
                    onChanged: (value) => model.setLang(value, context),
                    value: model.data.currentLang,
                    items: model.data.langItems,
                  )
          ],
        ),
      ),
    );
  }
}
