// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:task_manager/core/device_info.dart';
import 'package:task_manager/core/logger.dart';
import 'package:task_manager/core/network_info.dart';
import 'package:task_manager/features/task/data/task_repository.dart';
import 'package:task_manager/features/task/domain/todo_model.dart';
import 'package:task_manager/provider.dart';
import 'package:task_manager/router.dart';

import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(TodoModelAdapter());
  Hive.registerAdapter(ImportanceAdapter());

  final taskRepository = TaskRepository();
  await taskRepository.init();

  final deviceId = await DeviceInfo.getDeviceId();
  final networkInfo = NetworkInfo(Connectivity());

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

  runApp(MyApp(
    taskRepository: taskRepository,
    deviceId: deviceId,
    networkInfo: networkInfo,
    token: dotenv.env['API_TOKEN']!,
  ));
}

class MyApp extends StatelessWidget {
  final TaskRepository taskRepository;
  final String deviceId;
  final NetworkInfo networkInfo;
  final String token;

  const MyApp({
    super.key,
    required this.taskRepository,
    required this.deviceId,
    required this.networkInfo,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      deviceId: deviceId,
      token: token,
      child: MaterialApp.router(
        routerConfig: router,
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
      ),
    );
  }
}
