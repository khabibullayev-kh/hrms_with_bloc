import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print(await messaging.getToken(
    vapidKey: "BGpdLRs......",
  ));

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  print('User granted permission: ${settings.authorizationStatus}');

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
