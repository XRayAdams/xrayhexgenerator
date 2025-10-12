/*
 * Copyright (c) 2025 Konstantin Adamov
 *  SPDX-License-Identifier: MIT
 *
 *  For full license text, see the LICENSE file in the repo root.
 */

import 'package:uuid/uuid.dart';
import '../base_generator.dart';

class GuidGenerator extends BaseGenerator {
  @override
  String get id => 'guid';
  @override
  String get name => 'GUID';
  @override
  bool get digitsAreEditable => false;
  @override
  int get defaultDigits => 32; // GUIDs have a fixed length (32 hex chars without hyphens)

  @override
  String generate(int lines, int digits) { // Removed upperCase parameter
    // 'digits' parameter is ignored as GUID has a fixed length representation here
    StringBuffer sb = StringBuffer();
    final uid = Uuid();
    for (int i = 0; i < lines; i++) {
      var tmp = uid.v4().replaceAll('-', ''); // Remove hyphens for consistent 32 digits
      sb.writeln(tmp.toLowerCase()); // Output raw string, typically lowercase for GUIDs
    }
    return sb.toString();
  }
}
