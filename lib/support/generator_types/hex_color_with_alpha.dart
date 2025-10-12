/*
 * Copyright (c) 2025 Konstantin Adamov
 *  SPDX-License-Identifier: MIT
 *
 *  For full license text, see the LICENSE file in the repo root.
 */

import 'dart:math';
import '../base_generator.dart';

class HexColorWithAlphaGenerator extends BaseGenerator {
  @override
  String get id => 'hex_color_alpha';
  @override
  String get name => 'HEX Color with alpha';
  @override
  bool get digitsAreEditable => false;
  @override
  int get defaultDigits => 8; // AARRGGBB

  @override
  String generate(int lines, int digits) { // Removed upperCase parameter
    // 'digits' parameter is ignored
    final rnd = Random();
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < lines; i++) {
      StringBuffer colorLine = StringBuffer("#");
      for (int j = 0; j < 8; j++) {
        colorLine.write(rnd.nextInt(16).toRadixString(16));
      }
      sb.writeln(colorLine.toString()); // Output raw string, toRadixString(16) is lowercase
    }
    return sb.toString();
  }
}
