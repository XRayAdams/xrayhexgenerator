/*
 * Copyright (c) 2025 Konstantin Adamov
 *  SPDX-License-Identifier: MIT
 *
 *  For full license text, see the LICENSE file in the repo root.
 */

import 'dart:math';
import '../base_generator.dart';

class PrefixedHexGenerator extends BaseGenerator {
  @override
  String get id => 'prefixed_hex';
  @override
  String get name => 'Prefixed HEX';
  @override
  bool get digitsAreEditable => true;
  @override
  int get defaultDigits => 16;

  @override
  String generate(int lines, int digits) { // Removed upperCase parameter
    final rnd = Random();
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < lines; i++) {
      StringBuffer lineBuffer = StringBuffer("0x");
      for (int j = 0; j < digits; j++) {
        lineBuffer.write(rnd.nextInt(16).toRadixString(16));
      }
      sb.writeln(lineBuffer.toString()); // Output raw string
    }
    return sb.toString();
  }
}
