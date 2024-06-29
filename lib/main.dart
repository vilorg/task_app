import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:task_manager/core/logger.dart';
import 'package:task_manager/features/task/domain/todo_model.dart';
import 'package:task_manager/features/task/presentation/pages/add_edit_task_page.dart';
import 'core/theme.dart';
import 'features/task/presentation/pages/home_page.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  // Настройка глобального обработчика ошибок
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    logger.e(
      'Flutter Error',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  logger.i("App started");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru'), // Russian language
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/add-edit': (context) => AddEditTaskPage(
              todo: ModalRoute.of(context)?.settings.arguments as TodoModel?,
            ),
      },
    );
  }
}
