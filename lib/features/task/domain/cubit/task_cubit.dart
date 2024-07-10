import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/logger.dart';
import 'package:task_manager/core/network_info.dart';
import 'package:task_manager/features/task/data/task_repository.dart';
import 'package:task_manager/features/task/domain/todo_model.dart';
import 'package:task_manager/services/api_client.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final ApiClient apiClient;
  final TaskRepository taskRepository;
  final NetworkInfo networkInfo;
  final String deviceId;
  StreamSubscription<bool>? _connectivitySubscription;
  bool isConnected = true;

  // Конструктор, в котором мы подписываемся на изменения сетевого состояния
  TaskCubit(
      this.apiClient, this.taskRepository, this.networkInfo, this.deviceId)
      : super(TaskInitial()) {
    preloadInit();
  }

  void preloadInit() {
    _connectivitySubscription =
        networkInfo.onConnectivityChanged.listen((isConnected) {
      if (isConnected) {
        isConnected = true;
        syncOfflineChanges();
      } else {
        isConnected = false;
        if (state is TaskLoaded) {
          emit(TaskLoaded((state as TaskLoaded).tasks, isConnected));
        }
      }
    });
  }

  // Отменяем подписку при закрытии кубита
  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

  // Синхронизация оффлайн-изменений при восстановлении соединения
  Future<void> syncOfflineChanges() async {
    logger.i('Syncing offline changes');
    await _syncWithServer(await taskRepository.getRevision());
  }

  // Загрузка задач из локального хранилища и синхронизация с сервером при необходимости
  Future<void> fetchTasks() async {
    try {
      emit(TaskLoading());
      logger.i('Fetching tasks from local storage');
      final tasks = await taskRepository.getTasks();
      final revision = await taskRepository.getRevision();
      apiClient.revision = revision;
      logger.i(
          'Fetched ${tasks.length} tasks from local storage with revision $revision');
      bool result = true;
      if (isConnected) {
        result = await _syncWithServer(revision);
      }
      if (result) {
        emit(TaskLoaded(tasks, isConnected));
      }
    } catch (e) {
      logger.e('Failed to fetch tasks', error: e);
      emit(const TaskError('Failed to fetch tasks'));
    }
  }

  // Добавление новой задачи
  Future<void> addTask(TodoModel task) async {
    final newTask = task.copyWith(lastUpdatedBy: deviceId);
    await taskRepository.addTask(newTask);
    await _incrementLocalRevision();
    final currentState = state;
    if (currentState is TaskLoaded) {
      final updatedTasks = List<TodoModel>.from(currentState.tasks)
        ..add(newTask);
      emit(TaskLoaded(updatedTasks, isConnected));
    }

    if (isConnected) {
      try {
        await _syncWithServer(await taskRepository.getRevision());
      } catch (e) {
        logger.e('Failed to sync with server', error: e);
      }
    } else {
      logger.i('No internet connection. Task added offline');
    }
  }

  // Обновление существующей задачи
  Future<void> updateTask(TodoModel task) async {
    final updatedTask = task.copyWith(lastUpdatedBy: deviceId);
    await taskRepository.updateTask(updatedTask);
    await _incrementLocalRevision();
    final currentState = state;
    if (currentState is TaskLoaded) {
      final updatedTasks = currentState.tasks
          .map((t) => t.id == updatedTask.id ? updatedTask : t)
          .toList();
      emit(TaskLoaded(updatedTasks, isConnected));
    }

    if (isConnected) {
      try {
        await _syncWithServer(await taskRepository.getRevision());
      } catch (e) {
        logger.e('Failed to sync with server', error: e);
      }
    } else {
      logger.i('No internet connection. Task updated offline');
    }
  }

  // Удаление задачи
  Future<void> deleteTask(String id) async {
    await taskRepository.deleteTask(id);
    await _incrementLocalRevision();
    final currentState = state;
    if (currentState is TaskLoaded) {
      final updatedTasks =
          currentState.tasks.where((task) => task.id != id).toList();
      emit(TaskLoaded(updatedTasks, isConnected));
    }

    if (isConnected) {
      try {
        await _syncWithServer(await taskRepository.getRevision());
      } catch (e) {
        logger.e('Failed to sync with server', error: e);
      }
    } else {
      logger.i('No internet connection. Task deleted offline');
    }
  }

  // Увеличиваем локальную ревизию после каждого изменения данных
  Future<void> _incrementLocalRevision() async {
    final currentRevision = await taskRepository.getRevision();
    await taskRepository.updateRevision(currentRevision + 1);
  }

  // Синхронизация данных с сервером
  Future<bool> _syncWithServer(int localRevision) async {
    try {
      final serverTasks = await apiClient.getTodoList();
      final serverRevision = apiClient.revision;

      if (serverRevision > localRevision) {
        // Если ревизия на сервере больше, обновляем локальные данные
        logger.i('Server revision is greater. Updating local data.');
        await taskRepository.replaceLocalData(serverTasks);
        await taskRepository.updateRevision(serverRevision);
        emit(TaskLoaded(serverTasks, true));
        return false;
      } else if (localRevision > serverRevision) {
        // Если локальная ревизия больше, обновляем данные на сервере
        logger.i('Local revision is greater. Updating server data.');
        final localTasks = await taskRepository.getTasks();
        await apiClient.patchTodoList(localTasks, localRevision);
        await taskRepository.updateRevision(apiClient.revision);
      }
    } catch (e) {
      logger.e('Failed to sync with server', error: e);
    }
    return true;
  }
}
