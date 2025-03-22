/*
 * Copyright (c) 2019-2024 Larry Aasen. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only call clearSavedSettings() during testing to reset internal values.
  await Upgrader.clearSavedSettings(); // REMOVE this for release builds

  // On Android, the default behavior will be to use the Google Play Store
  // version of the app.
  // On iOS, the default behavior will be to use the App Store version of
  // the app, so update the Bundle Identifier in example/ios/Runner with a
  // valid identifier already in the App Store.
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const appcastURL = "https://appcast.thientech.site/dist/appcast.xml";
  final upgrader = Upgrader(
      storeController: UpgraderStoreController(
        onMacOS: () => UpgraderAppcastStore(appcastURL: appcastURL),
        onWindows: () => UpgraderAppcastStore(appcastURL: appcastURL),
      ),
      debugLogging: true,
      durationUntilAlertAgain: Duration(seconds: 2));
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upgrader Example',
      home: UpgradeAlert(
        upgrader: upgrader,
        child: Scaffold(
          appBar: AppBar(title: const Text('Upgrader Example')),
          body: const Center(child: Text('Checking...')),
        ),
      ),
    );
  }
}
