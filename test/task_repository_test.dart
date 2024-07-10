import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/shared_preferences_helper.dart';
import 'package:task_manager/features/task/domain/todo_model.dart';
import 'package:task_manager/features/task/data/task_repository.dart';

class MockSharedPreferencesHelper extends Mock
    implements SharedPreferencesHelper {}

void main() {
  late TaskRepository taskRepository;
  late Box<TodoModel> taskBox;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await setUpTestHive();
    Hive.registerAdapter(TodoModelAdapter());
    Hive.registerAdapter(ImportanceAdapter());
  });

  setUp(() async {
    taskBox = await Hive.openBox<TodoModel>('tasks');
    taskRepository = TaskRepository();

    // Mocking SharedPreferencesHelper methods
    // when(() => SharedPreferencesHelper.getRevision())
    //     .thenAnswer((_) async => 1);
    // when(() => SharedPreferencesHelper.setRevision(any()))
    //     .thenAnswer((_) async => true);
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  group('TaskRepository', () {
    group('addTask', () {
      test('adds a task to the box', () async {
        final task = TodoModel(
          id: '1',
          text: 'Test task',
          importance: Importance.basic,
          done: false,
          createdAt: 1632980400000,
          changedAt: 1632980400000,
          lastUpdatedBy: 'test_device',
        );

        await taskRepository.addTask(task);

        final fetchedTask = taskBox.get(task.id);
        expect(fetchedTask, equals(task));
      });
    });

    group('deleteTask', () {
      test('deletes a task from the box', () async {
        final task = TodoModel(
          id: '1',
          text: 'Test task',
          importance: Importance.basic,
          done: false,
          createdAt: 1632980400000,
          changedAt: 1632980400000,
          lastUpdatedBy: 'test_device',
        );

        await taskBox.put(task.id, task);
        await taskRepository.deleteTask(task.id);

        final fetchedTask = taskBox.get(task.id);
        expect(fetchedTask, isNull);
      });
    });

    group('getTasks', () {
      test('returns list of tasks', () async {
        final task = TodoModel(
          id: '1',
          text: 'Test task',
          importance: Importance.basic,
          done: false,
          createdAt: 1632980400000,
          changedAt: 1632980400000,
          lastUpdatedBy: 'test_device',
        );

        await taskBox.put(task.id, task);

        final tasks = await taskRepository.getTasks();
        expect(tasks, [task]);
      });
    });

    group('getRevision', () {
      test('returns the current revision', () async {
        SharedPreferences.setMockInitialValues({"revision": 1});
        final revision = await taskRepository.getRevision();
        expect(revision, 1);
      });
    });
  });
}
