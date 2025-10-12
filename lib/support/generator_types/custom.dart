/*
 * Copyright (c) 2025 Konstantin Adamov
 *  SPDX-License-Identifier: MIT
 *
 *  For full license text, see the LICENSE file in the repo root.
 */

import 'dart:math';
import '../base_generator.dart';

class CustomGenerator extends BaseGenerator {
  @override
  String get id => 'custom';
  @override
  String get name => 'Custom';
  @override
  bool get digitsAreEditable => true;
  @override
  int get defaultDigits => 16; // Default for custom

  @override
  String generate(int lines, int digits) { // Removed upperCase parameter
    final rnd = Random();
    StringBuffer sb = StringBuffer();
    StringBuffer lineBuffer = StringBuffer();
    for (int i = 0; i < lines; i++) {
      lineBuffer.clear();
      for (int j = 0; j < digits; j++) {
        lineBuffer.write(rnd.nextInt(16).toRadixString(16));
      }
      sb.writeln(lineBuffer.toString()); // Output raw string
    }
    return sb.toString();
  }
}
