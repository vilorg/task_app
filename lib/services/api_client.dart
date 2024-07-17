import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:task_manager/features/task/domain/todo_model.dart';

class ApiClient {
  final Dio dio;
  int revision = 0;

  ApiClient({required this.dio}) {
    preloadInit();
  }

  void preloadInit() {
    // Добавим настройку для игнорирования ошибок проверки сертификатов
    if (!kReleaseMode) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final HttpClient client =
              HttpClient(context: SecurityContext(withTrustedRoots: false));
          client.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          return client;
        },
      );
    }
  }

  Future<List<TodoModel>> getTodoList() async {
    try {
      final response = await dio.get('/list');
      final data = response.data;
      if (data['status'] == 'ok') {
        revision = data['revision'];
        List<TodoModel> tasks = (data['list'] as List)
            .map((task) => TodoModel.fromJson(task))
            .toList();
        return tasks;
      } else {
        throw Exception('Failed to fetch todo list');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTodoItem(TodoModel task) async {
    try {
      final response = await dio.post('/list', data: task.toJson());
      if (response.data['status'] == 'ok') {
        revision = response.data['revision'];
      } else {
        throw Exception('Failed to add todo item');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTodoItem(String id, TodoModel task) async {
    try {
      final response = await dio.put('/list/$id', data: task.toJson());
      if (response.data['status'] == 'ok') {
        revision = response.data['revision'];
      } else {
        throw Exception('Failed to update todo item');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTodoItem(String id) async {
    try {
      final response = await dio.delete('/list/$id');
      if (response.data['status'] == 'ok') {
        revision = response.data['revision'];
      } else {
        throw Exception('Failed to delete todo item');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> patchTodoList(List<TodoModel> tasks, int localRevision) async {
    try {
      final response = await dio.patch(
        '/list',
        data: {
          'list': tasks.map((task) => task.toJson()).toList(),
        },
        options: Options(headers: {
          'X-Last-Known-Revision': localRevision,
        }),
      );
      if (response.data['status'] == 'ok') {
        revision = response.data['revision'];
      } else {
        throw Exception('Failed to patch todo list');
      }
    } catch (e) {
      rethrow;
    }
  }
}
