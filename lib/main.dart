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
            home: const MyHomePage(title: 'HEX Generator'),
          ),
        );
      },
    );
  }
}
