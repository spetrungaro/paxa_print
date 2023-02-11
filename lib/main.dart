// ignore_for_file: avoid_print
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';

import 'app.dart';

void main() async {
  runApp(
    MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(248, 9, 28, 201),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Fiscalberry - Paxapos',
      home: const App(),
    ),
  );
  print('App launched');

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    const config = FlutterBackgroundAndroidConfig(
      notificationTitle: 'Fiscalberry Background',
      notificationText: "Texto explicando que hace",
      enableWifiLock: true,
      showBadge: true,
      shouldRequestBatteryOptimizationsOff: true,
    );

    var hasPermissions = await FlutterBackground.hasPermissions;
    print(hasPermissions.toString());
    hasPermissions = await FlutterBackground.initialize(androidConfig: config);
    print(hasPermissions.toString());
    if (hasPermissions) {
      final backgroundExecution =
          await FlutterBackground.enableBackgroundExecution();
      print(backgroundExecution.toString());
    }
  } else {
    print('No need for permissions');
    print(defaultTargetPlatform.name);
  }
}
