/*
 * Copyright (c) 2025 Konstantin Adamov
 *  SPDX-License-Identifier: MIT
 *
 *  For full license text, see the LICENSE file in the repo root.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xrayhexgenerator/support/hexgenerator_provider.dart';
import 'package:xrayhexgenerator/ui/home_page.dart';
import 'package:yaru/yaru.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  await YaruWindowTitleBar.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      builder: (context, yaru, child) {
        return MultiProvider(
          providers: [ChangeNotifierProvider(create: (context) => HEXGeneratorProvider())],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            // Assign the GlobalKey
            title: 'HEX Generator',
            theme: yaru.theme,
            debugShowCheckedModeBanner: false,
            darkTheme: yaru.darkTheme,
            themeMode: ThemeMode.system,
            home: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: const MyHomePage(title: 'HEX Generator'),
            ),
          ),
        );
      },
    );
  }
}
