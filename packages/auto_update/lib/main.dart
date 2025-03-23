import 'package:auto_updater/auto_updater.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:upgrader/upgrader.dart';

class AutoUpdate {
  AutoUpdate._();
  static final AutoUpdate _instance = AutoUpdate._();
  Future<void> setupAutoUpdate({
    required String appcastURL,
    required int interval,
    bool enableAutoCheck = true,
  }) async {
    if (UniversalPlatform.isWindows || UniversalPlatform.isMacOS) {
      await autoUpdater.setFeedURL(appcastURL);

      if (enableAutoCheck) {
        await autoUpdater.checkForUpdates();
        await autoUpdater.setScheduledCheckInterval(interval);
      }
      return;
    }
  }

  void addListener(UpdaterListener listener) =>
      autoUpdater.addListener(listener);
  void removeListener(UpdaterListener listener) =>
      autoUpdater.removeListener(listener);
}

final autoUpdate = AutoUpdate._instance;

class AutoUpdateAlert extends StatelessWidget {
  final String appcastURL;
  final int interval;
  final bool enableAutoCheck;
  final Widget child;
  final Duration durationUntilAlertAgain;
  final String? countryCode;
  final String? languageCode;
  final UpgraderOS? upgraderOS;
  final bool debugDisplayAlways;
  final UpgraderDevice? upgraderDevice;
  final UpgraderMessages? messages;
  final void Function({
    required bool display,
    String? installedVersion,
    UpgraderVersionInfo? versionInfo,
  })?
  willDisplayUpgrade;
  final bool debugDisplayOnce;
  final bool Function()? onUpdate;
  final GlobalKey<State<StatefulWidget>>? dialogKey;
  final bool Function()? onIgnore;
  final bool Function()? onLater;
  final bool barrierDismissible = false;
  final TextStyle? cupertinoButtonTextStyle;
  final UpgradeDialogStyle dialogStyle = UpgradeDialogStyle.material;
  final bool Function()? shouldPopScope;
  final bool showIgnore = true;

  final GlobalKey<NavigatorState>? navigatorKey;
  final bool showLater = true;
  final bool showReleaseNotes = true;
  final Map<String, String>? clientHeaders;

  const AutoUpdateAlert({
    super.key,
    required this.appcastURL,
    this.interval = 3600,
    this.enableAutoCheck = true,
    required this.child,
    this.durationUntilAlertAgain = const Duration(days: 3),
    this.countryCode,
    this.languageCode,
    this.upgraderOS,
    this.debugDisplayAlways = false,
    this.upgraderDevice,
    this.messages,
    this.willDisplayUpgrade,
    this.debugDisplayOnce = false,
    this.onUpdate,
    this.dialogKey,
    this.onIgnore,
    this.onLater,
    this.cupertinoButtonTextStyle,
    this.shouldPopScope,
    this.navigatorKey,
    this.clientHeaders,
  });

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isWindows || UniversalPlatform.isMacOS) {
      return child;
    }
    final upgrader = Upgrader(
      storeController: UpgraderStoreController(
        onLinux: () => UpgraderAppcastStore(appcastURL: appcastURL),
        onWeb: () => UpgraderAppcastStore(appcastURL: appcastURL),
      ),
      debugLogging: true,
      durationUntilAlertAgain: durationUntilAlertAgain,
      countryCode: countryCode,
      languageCode: languageCode,
      upgraderOS: upgraderOS,
      debugDisplayAlways: debugDisplayAlways,
      upgraderDevice: upgraderDevice,
      messages: messages,
      willDisplayUpgrade: willDisplayUpgrade,
      debugDisplayOnce: debugDisplayOnce,
      clientHeaders: clientHeaders,
    );

    return UpgradeAlert(
      upgrader: upgrader,
      barrierDismissible: barrierDismissible,
      cupertinoButtonTextStyle: cupertinoButtonTextStyle,
      dialogStyle: dialogStyle,
      shouldPopScope: shouldPopScope,
      showIgnore: showIgnore,
      key: key,
      navigatorKey: navigatorKey,
      showLater: showLater,
      showReleaseNotes: showReleaseNotes,
      onLater: onLater,
      onIgnore: onIgnore,
      onUpdate: onUpdate,
      dialogKey: dialogKey,
      child: child,
    );
  }
}
