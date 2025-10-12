/*
 * Copyright (c) 2025 Konstantin Adamov
 *  SPDX-License-Identifier: MIT
 *
 *  For full license text, see the LICENSE file in the repo root.
 */

import 'dart:math';
import '../base_generator.dart';

class ByteSequenceGenerator extends BaseGenerator {
  @override
  String get id => 'byte_sequence';
  @override
  String get name => 'Byte Sequence';
  @override
  bool get digitsAreEditable => true; // User defines total hex characters, implies number of bytes
  @override
  int get defaultDigits => 16; // Default e.g. 8 bytes (16 hex chars)

  @override
  String generate(int lines, int digits) { // Removed upperCase parameter
    final rnd = Random();
    StringBuffer sb = StringBuffer();
    int numHexChars = digits; 
    if (numHexChars % 2 != 0) {
        // Ensure even number of hex chars for full bytes, or adjust logic as preferred
        numHexChars = (numHexChars / 2).floor() * 2; 
    }
    int numBytes = (numHexChars / 2).floor();

    for (int i = 0; i < lines; i++) {
      StringBuffer lineBuffer = StringBuffer();
      for (int j = 0; j < numBytes; j++) {
        lineBuffer.write(rnd.nextInt(16).toRadixString(16));
        lineBuffer.write(rnd.nextInt(16).toRadixString(16));
        if (j < numBytes - 1) {
          lineBuffer.write(" ");
        }
      }
      sb.writeln(lineBuffer.toString()); // Output raw string
    }
    return sb.toString();
  }
}
