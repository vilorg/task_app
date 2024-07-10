import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:task_manager/features/task/domain/todo_model.dart';

extension CatExtension on Importance {
  String getText(AppLocalizations localization) {
    switch (this) {
      case Importance.important:
        return localization.imporanceHight;
      case Importance.low:
        return localization.imporanceLow;
      case Importance.basic:
        return localization.importanceNone;
    }
  }

  Color? color(BuildContext context) {
    Color? importanceColor = Theme.of(context).textTheme.bodyMedium?.color;

    if (this == Importance.important) {
      importanceColor = Theme.of(context).colorScheme.error;
    }
    return importanceColor;
  }
}
