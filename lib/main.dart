// ignore_for_file: avoid_print
import 'package:flutter/foundation.dart'
    show Key, TargetPlatform, UniqueKey, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Color,
        KeyedSubtree,
        MaterialApp,
        State,
        StatefulWidget,
        ThemeData,
        Widget,
        runApp;
import 'package:flutter_background/flutter_background.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

void main() async {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    const config = FlutterBackgroundAndroidConfig(
        notificationTitle: 'Fiscalberry Background',
        notificationText: "Texto explicando que hace",
        enableWifiLock: true,
        showBadge: true,
        shouldRequestBatteryOptimizationsOff: true,
        notificationImportance: AndroidNotificationImportance.Default);

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
  await Hive.initFlutter();
  await Hive.openBox('printers');
  runApp(RestartWidget(
    child: MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(248, 9, 28, 201),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Fiscalberry - Paxapos',
      home: const App(),
    ),
  ));
  print('App launched');
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({required this.child, super.key});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    print('Restarting');
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
