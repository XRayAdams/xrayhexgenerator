/*
 * Copyright (c) 2025 Konstantin Adamov
 *  SPDX-License-Identifier: MIT
 *
 *  For full license text, see the LICENSE file in the repo root.
 */
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';

import '../support/hexgenerator_provider.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/mode_selector_drop_down.dart';
import 'about_dialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _resultController = TextEditingController();
  final TextEditingController _digitsController = TextEditingController();
  final TextEditingController _linesController = TextEditingController(); // Added for lines

  final _digitsNode = FocusNode();
  final _linesNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers in initState after the provider is available if needed,
    // or rely on the build method to update them based on provider values.
    // For now, build method will handle updates.
  }

  @override
  Widget build(BuildContext context) {
    HEXGeneratorProvider generator = Provider.of<HEXGeneratorProvider>(context);

    // Update controllers when the provider changes
    // This ensures the UI reflects the provider's state, especially after loading prefs
    // or when the generator type changes.
    _digitsController.text = generator.digits;
    _linesController.text = generator.lines;

    return Scaffold(
      appBar: YaruWindowTitleBar(
        title: Text(widget.title),
        actions: [
          YaruOptionButton(
            child: const Icon(YaruIcons.menu),
            onPressed: () {
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              final Offset offset = renderBox.localToGlobal(Offset.zero);
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  offset.dx + renderBox.size.width - 190,
                  offset.dy + 50,
                  offset.dx + renderBox.size.width,
                  offset.dy,
                ),
                items: [const PopupMenuItem(value: "about", child: Text("About..."))],
              ).then((value) {
                if (value == "about") {
                  if (context.mounted) {
                    showDialog(context: context, builder: (context) => const CustomAboutDialog());
                  }
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kYaruPagePadding),
        child: !generator.isLoaded
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  YaruSection(
                    width: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text("Output mode:"),
                            const SizedBox(width: 10),
                            if (generator.availableGenerators.isNotEmpty) ModeSelectorDropDown(generator: generator),
                            Expanded(child: Container()),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Form(
                            key: _formKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    enabled: generator.digitsAreEditable,
                                    decoration: const InputDecoration(labelText: 'Digits'),
                                    keyboardType: TextInputType.number,
                                    controller: _digitsController,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _digitsNode,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context).requestFocus(_linesNode);
                                    },
                                    validator: (value) {
                                      if (value == null || int.tryParse(value) == null) {
                                        return 'Not a number';
                                      }
                                      if ((int.tryParse(value) ?? 0) <= 0 && generator.digitsAreEditable) {
                                        return 'Must be > 0';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      if (generator.digitsAreEditable) {
                                        generator.digits = newValue!;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: 'Lines'),
                                    keyboardType: TextInputType.number,
                                    controller: _linesController,
                                    // Use controller
                                    textInputAction: TextInputAction.next,
                                    focusNode: _linesNode,
                                    onFieldSubmitted: (value) {
                                      // Potentially trigger generation or move focus
                                      // For now, just request focus on digits if form is valid
                                      if (_formKey.currentState?.validate() ?? false) {
                                        _formKey.currentState?.save();
                                        FocusScope.of(context).requestFocus(_digitsNode);
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null || int.tryParse(value) == null) {
                                        return 'Not a number';
                                      }
                                      if ((int.tryParse(value) ?? 0) <= 0) {
                                        return 'Must be > 0';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      generator.lines = newValue!;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: YaruSwitchListTile(
                            title: const Text("Output in Uppercase:"),
                            value: generator.upperCase,
                            onChanged: (bool? value) {
                              // No need for setState here if provider notifies listeners
                              generator.upperCase = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        style: const TextStyle(fontFamily: 'UbuntuMono', fontSize: 18),
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(border: OutlineInputBorder(), alignLabelWithHint: true),
                        maxLines: null,
                        readOnly: true,
                        expands: true,
                        controller: _resultController,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        CustomOutlinedButton(
                          title: "Generate",
                          icon: YaruIcons.send,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _resultController.text = generator.generate();
                              setState(() {}); // To update share button state immediately
                            }
                          },
                        ),
                        Spacer(),
                        CustomOutlinedButton(
                          title: "Copy",
                          icon: YaruIcons.copy,
                          onPressed: _resultController.text.isEmpty
                              ? null
                              : () {
                                  Clipboard.setData(ClipboardData(text: _resultController.text));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 1),
                                      width: 200,
                                      dismissDirection: DismissDirection.horizontal,
                                      content: Text('Copied to clipboard!'),
                                    ),
                                  );
                                },
                        ),
                        const SizedBox(width: 10),
                        CustomOutlinedButton(
                          title: "Save",
                          icon: YaruIcons.floppy_filled,
                          onPressed: _resultController.text.isEmpty
                              ? null
                              : () async {
                                  await saveToFile(generator);
                                },
                        ),
                        const SizedBox(width: 10),
                        CustomOutlinedButton(
                          title: "Share",
                          icon: YaruIcons.share_filled,
                          onPressed: _resultController.text.isEmpty
                              ? null
                              : () {
                                  generator.share(_resultController.text);
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> saveToFile(HEXGeneratorProvider generator) async {
    var data = Uint8List.fromList(_resultController.text.codeUnits);

    const String fileName = 'hexgenerator_output.txt'; // Made filename more specific
    final FileSaveLocation? result = await getSaveLocation(
      suggestedName: fileName,
      // initialDirectory: "~/Documents", // Consider making initialDirectory platform-aware or configurable
    );
    if (result == null) {
      return;
    }

    final XFile textFile = XFile.fromData(data, mimeType: 'text/plain', name: fileName);
    await textFile.saveTo(result.path);
  }

  @override
  void dispose() {
    _resultController.dispose();
    _digitsController.dispose();
    _linesController.dispose(); // Dispose new controller
    _digitsNode.dispose();
    _linesNode.dispose();
    super.dispose();
  }
}
