/*
 * Copyright (c) 2025 Konstantin Adamov
 *  SPDX-License-Identifier: MIT
 *
 *  For full license text, see the LICENSE file in the repo root.
 */

abstract class BaseGenerator {
  String get id; // Unique identifier for saving preferences
  String get name; // Display name for the UI
  bool get digitsAreEditable;
  int get defaultDigits; // For generators with fixed or default digit counts

  // Remove upperCase parameter
  String generate(int lines, int digits);
}
