/*
 * Copyright (c) 2025 Konstantin Adamov
 *  SPDX-License-Identifier: MIT
 *
 *  For full license text, see the LICENSE file in the repo root.
 */

import 'dart:math';
import '../base_generator.dart';

class HexColorGenerator extends BaseGenerator {
  @override
  String get id => 'hex_color';
  @override
  String get name => 'HEX Color';
  @override
  bool get digitsAreEditable => false;
  @override
  int get defaultDigits => 6; // RRGGBB

  @override
  String generate(int lines, int digits) { // Removed upperCase parameter
    // 'digits' parameter is ignored
    final rnd = Random();
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < lines; i++) {
      StringBuffer colorLine = StringBuffer("#");
      for (int j = 0; j < 6; j++) {
        colorLine.write(rnd.nextInt(16).toRadixString(16));
      }
      sb.writeln(colorLine.toString()); // Output raw string, toRadixString(16) is lowercase
    }
    return sb.toString();
  }
}
