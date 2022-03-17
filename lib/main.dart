import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/data/resources/keys.dart';
import 'package:hrms/my_app.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:hrms/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await initialize();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (getStringAsync(LANG) == '') setValue(LANG, 'ru');
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('ru'), Locale('uz')],
        path: 'assets/translations',
        // <-- change the path of the translation files
        fallbackLocale: const Locale('ru'),
        child: const MyApp()),
  );
  // BlocOverrides.runZoned(
  //   () => (EasyLocalization(
  //     child: const MyApp(),
  //
  //     supportedLocales: const [
  //       Locale('uz'),
  //       Locale('ru'),
  //     ],
  //     path: 'assets/translations',
  //
  //     fallbackLocale:  Locale('ru'),
  //     assetLoader: const CodegenLoader(),
  //   )),
  //   blocObserver: BlocsObserver(),
  // );
}
