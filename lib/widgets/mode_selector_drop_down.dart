
import 'package:flutter/material.dart';
import 'package:yaru/widgets.dart';

import '../support/base_generator.dart';
import '../support/hexgenerator_provider.dart';

class ModeSelectorDropDown extends StatelessWidget {
  const ModeSelectorDropDown({
    super.key,
    required this.generator,
  });

  final HEXGeneratorProvider generator;

  @override
  Widget build(BuildContext context) {
    return YaruPopupMenuButton<BaseGenerator>(
        initialValue: generator.selectedGenerator,
        onSelected: (BaseGenerator? value) {
          if (value != null) {
            generator.selectedGenerator = value;
            // Digits controller will be updated by the next build cycle
          }
        },
        child: Text(generator.selectedGenerator!.name),
        itemBuilder: (BuildContext context) {
          return generator.availableGenerators
              .map<PopupMenuEntry<BaseGenerator>>(
                (BaseGenerator value) {
              return PopupMenuItem<BaseGenerator>(
                value: value,
                child: Text(value.name),
              );
            },
          )
              .toList();
        }
    );
  }
}
