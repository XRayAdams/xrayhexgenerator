/*
 * Copyright (c) 2025 Konstantin Adamov
 *  SPDX-License-Identifier: MIT
 *
 *  For full license text, see the LICENSE file in the repo root.
 */

import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './generators.dart';

/// Provider class for HEX generator functionality.
class HEXGeneratorProvider with ChangeNotifier {
  final List<BaseGenerator> availableGenerators = [
    CustomGenerator(),
    GuidGenerator(),
    MacAddressGenerator(),
    HexColorGenerator(),
    HexColorWithAlphaGenerator(),
    ByteSequenceGenerator(),
    PrefixedHexGenerator(),
  ];

  bool isLoaded = false;
  int _lines = 20;
  int _digits = 16;
  bool _upperCase = true;
  BaseGenerator? _selectedGenerator;

  HEXGeneratorProvider() {
    // Initialize with the first generator as default before loading prefs
    _selectedGenerator = availableGenerators.isNotEmpty
        ? availableGenerators.first
        : null;
    _digits = _selectedGenerator?.defaultDigits ?? 16;
    loadPrefs();
  }

  String get lines => _lines.toString();

  set lines(String value) {
    _lines = int.tryParse(value) ?? 20;
    _savePref();
    notifyListeners(); // Notify listeners when lines change
  }

  String get digits => _digits.toString();

  set digits(String value) {
    // Only set digits if the current generator allows it
    if (_selectedGenerator?.digitsAreEditable ?? true) {
      _digits = int.tryParse(value) ?? _selectedGenerator?.defaultDigits ?? 16;
      _savePref();
      notifyListeners(); // Notify listeners when digits change
    }
  }

  bool get upperCase => _upperCase;

  set upperCase(bool value) {
    _upperCase = value;
    _savePref();
    notifyListeners(); // Notify listeners when upperCase changes
  }

  BaseGenerator? get selectedGenerator => _selectedGenerator;

  set selectedGenerator(BaseGenerator? value) {
    if (value != null && _selectedGenerator?.id != value.id) {
      _selectedGenerator = value;
      // Update digits based on the new generator's properties
      _digits = _selectedGenerator?.defaultDigits ?? 16;
      _savePref();
      notifyListeners();
    }
  }

  bool get digitsAreEditable => _selectedGenerator?.digitsAreEditable ?? true;

  Future<void> loadPrefs() async {
    isLoaded = false; // Set to false before loading
    notifyListeners(); // Notify UI that loading is starting

    final SharedPreferences pref = await SharedPreferences.getInstance();

    _lines = pref.getInt('lines') ?? 20;
    _upperCase = pref.getBool('upperCase') ?? true;

    String? selectedGeneratorId = pref.getString('selectedGeneratorId');
    if (selectedGeneratorId != null) {
      _selectedGenerator = availableGenerators.firstWhere(
        (gen) => gen.id == selectedGeneratorId,
        orElse: () =>
            availableGenerators.first, // Default to first if not found
      );
    } else {
      _selectedGenerator = availableGenerators.first;
    }

    // Load digits, respecting whether the loaded generator type allows editing
    if (_selectedGenerator?.digitsAreEditable ?? true) {
      _digits =
          pref.getInt('digits') ?? _selectedGenerator?.defaultDigits ?? 16;
    } else {
      _digits = _selectedGenerator?.defaultDigits ?? 16;
    }

    isLoaded = true;
    notifyListeners();
  }

  Future<void> _savePref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('lines', _lines);
    await pref.setInt('digits', _digits);
    await pref.setBool('upperCase', _upperCase);

    if (_selectedGenerator != null) {
      await pref.setString('selectedGeneratorId', _selectedGenerator!.id);
    }
  }

  void share(String text) {
    if (text.isNotEmpty) {
      SharePlus.instance.share(ShareParams(text: text));
    }
  }

  String generate() {
    if (_selectedGenerator == null) {
      return "Error: No generator selected";
    }
    String rawOutput = _selectedGenerator!.generate(_lines, _digits);

    return _upperCase ? rawOutput.toUpperCase() : rawOutput.toLowerCase();
  }
}
