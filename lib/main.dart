// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/provider.dart';
import 'package:task_manager/router.dart';

import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));

  await remoteConfig.fetchAndActivate();

  final Color? remoteColor = getImportanceColor();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

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
    remoteColor: remoteColor,
  ));
}

Color? getImportanceColor() {
  final remoteConfig = FirebaseRemoteConfig.instance;
  final colorString = remoteConfig.getString('importance_color');
  if (colorString == "default") return null;
  return Color(int.tryParse(colorString.replaceFirst('#', '0xFF')) ?? 0xFFFFFF);
}

class MyApp extends StatelessWidget {
  final Color? remoteColor;
  final TaskRepository taskRepository;
  final String deviceId;
  final NetworkInfo networkInfo;
  final String token;

  const MyApp({
    super.key,
    this.remoteColor,
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
        theme: remoteColor != null
            ? AppTheme.lightTheme.copyWith(
                colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
                  error: remoteColor,
                ),
              )
            : AppTheme.lightTheme,
        darkTheme: remoteColor != null
            ? AppTheme.darkTheme.copyWith(
                colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
                  error: remoteColor,
                ),
              )
            : AppTheme.darkTheme,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
