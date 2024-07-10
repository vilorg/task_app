import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/core/device_info.dart';
import 'package:task_manager/core/network_info.dart';
import 'package:task_manager/features/task/data/task_repository.dart';
import 'package:task_manager/features/task/domain/todo_model.dart';
import 'package:task_manager/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('integration test', () {
    testWidgets('home screen -> detail screen -> home screen', (tester) async {
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
      // Load app widget.
      await tester.pumpWidget(MyApp(
        taskRepository: taskRepository,
        deviceId: deviceId,
        networkInfo: networkInfo,
        token: dotenv.env['API_TOKEN']!,
      ));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.add), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      await tester.enterText(find.byType(TextField), "Example by test");
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.text("Example by test"), findsOneWidget);
    });
  });
}
