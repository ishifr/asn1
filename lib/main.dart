import 'dart:io';
import 'package:asn1/my_app.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    WindowOptions windowOptions = const WindowOptions(
      size: Size(700, 700),
      minimumSize: Size(500, 400),
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}
