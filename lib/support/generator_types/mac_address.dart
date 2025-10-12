/*
 * Copyright (c) 2025 Konstantin Adamov
 *  SPDX-License-Identifier: MIT
 *
 *  For full license text, see the LICENSE file in the repo root.
 */

import 'dart:math';
import '../base_generator.dart';

class MacAddressGenerator extends BaseGenerator {
  @override
  String get id => 'mac_address';
  @override
  String get name => 'Mac Address';
  @override
  bool get digitsAreEditable => false;
  @override
  int get defaultDigits => 12; // 6 bytes * 2 hex chars/byte

  @override
  String generate(int lines, int digits) { // Removed upperCase parameter
    // 'digits' parameter is ignored
    final rnd = Random();
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < lines; i++) {
      StringBuffer lineBuffer = StringBuffer();
      for (int j = 0; j < 6; j++) {
        lineBuffer.write(rnd.nextInt(16).toRadixString(16));
        lineBuffer.write(rnd.nextInt(16).toRadixString(16));
        if (j < 5) {
          lineBuffer.write(":");
        }
      }
      sb.writeln(lineBuffer.toString()); // Output raw string, toRadixString(16) is lowercase
    }
    return sb.toString();
  }
}
