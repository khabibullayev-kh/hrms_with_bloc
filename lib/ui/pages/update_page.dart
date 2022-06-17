import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class UpdatePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<UpdatePage> {
  AppUpdateInfo? _updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  void immediateUpdate() async {
    if (Platform.isAndroid) {
      checkForUpdate().whenComplete(() {
        Future.delayed(Duration(seconds: 1), () {
          if (_updateInfo?.updateAvailability ==
              UpdateAvailability.updateAvailable) {
            InAppUpdate.performImmediateUpdate()
                .catchError((e) => showSnack(e.toString()));
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    immediateUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('In App Update Example App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Text('Update info: $_updateInfo'),
            ),
            ElevatedButton(
              child: Text('Check for Update'),
              onPressed: () => checkForUpdate(),
            ),
            ElevatedButton(
              child: Text('Perform immediate update'),
              onPressed: _updateInfo?.updateAvailability ==
                      UpdateAvailability.updateAvailable
                  ? () {
                      InAppUpdate.performImmediateUpdate()
                          .catchError((e) => showSnack(e.toString()));
                    }
                  : null,
            ),
            ElevatedButton(
              child: Text('Start flexible update'),
              onPressed: _updateInfo?.updateAvailability ==
                      UpdateAvailability.updateAvailable
                  ? () {
                      InAppUpdate.startFlexibleUpdate().then((_) {
                        setState(() {
                          _flexibleUpdateAvailable = true;
                        });
                      }).catchError((e) {
                        showSnack(e.toString());
                      });
                    }
                  : null,
            ),
            ElevatedButton(
              child: Text('Complete flexible update'),
              onPressed: !_flexibleUpdateAvailable
                  ? null
                  : () {
                      InAppUpdate.completeFlexibleUpdate().then((_) {
                        showSnack("Success!");
                      }).catchError((e) {
                        showSnack(e.toString());
                      });
                    },
            )
          ],
        ),
      ),
    );
  }
}
