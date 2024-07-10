import 'package:hive/hive.dart';
import 'package:task_manager/features/task/domain/todo_model.dart';
import 'package:task_manager/core/shared_preferences_helper.dart';

class TaskRepository {
  static const String _taskBoxName = 'tasks';

  Future<void> init() async {
    await Hive.openBox<TodoModel>(_taskBoxName);
  }

  Future<void> addTask(TodoModel task) async {
    final box = Hive.box<TodoModel>(_taskBoxName);
    await box.put(task.id, task);
  }

  Future<void> updateTask(TodoModel task) async {
    final box = Hive.box<TodoModel>(_taskBoxName);
    await box.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    final box = Hive.box<TodoModel>(_taskBoxName);
    await box.delete(id);
  }

  Future<List<TodoModel>> getTasks() async {
    final box = Hive.box<TodoModel>(_taskBoxName);
    return box.values.toList();
  }

  Future<int> getRevision() async {
    return SharedPreferencesHelper.getRevision();
  }

  Future<void> updateRevision(int newRevision) async {
    await SharedPreferencesHelper.setRevision(newRevision);
  }

  Future<void> replaceLocalData(List<TodoModel> tasks) async {
    final box = Hive.box<TodoModel>(_taskBoxName);
    await box.clear();
    for (var task in tasks) {
      await box.put(task.id, task);
    }
  }
}
