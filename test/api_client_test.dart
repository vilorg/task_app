import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/features/task/domain/todo_model.dart';
import 'package:task_manager/services/api_client.dart';

import 'mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('ApiClient', () {
    late MockDio mockDio;
    late ApiClient apiClient;

    setUp(() {
      mockDio = MockDio();
      apiClient = ApiClient(dio: mockDio); // Устанавливаем mockDio в apiClient
    });
    test('getTodoList returns list of tasks', () async {
      final response = {
        "status": "ok",
        "list": [
          {
            "id": "1",
            "text": "Test task",
            "importance": "basic",
            "deadline": null,
            "done": false,
            "color": null,
            "created_at": 1632980400000,
            "changed_at": 1632980400000,
            "last_updated_by": "test_device"
          }
        ],
        "revision": 1
      };
      when(() => mockDio.get(any())).thenAnswer((_) async => Response(
            data: response,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/list'),
          ));

      final tasks = await apiClient.getTodoList();
      expect(tasks, isA<List<TodoModel>>());
      expect(tasks.length, 1);
      expect(tasks[0].id, "1");
    });

    test('getTodoList handles error response', () async {
      when(() => mockDio.get(any())).thenAnswer((_) async => Response(
            data: {'status': 'error', 'message': 'Failed to fetch list'},
            statusCode: 400,
            requestOptions: RequestOptions(path: '/list'),
          ));

      expect(() => apiClient.getTodoList(), throwsA(isA<Exception>()));
      verify(() => mockDio.get(any())).called(1);
    });

    test('addTodoItem sends a post request and returns success', () async {
      final task = TodoModel(
        text: 'Test task',
        importance: Importance.basic,
        done: false,
        createdAt: 1632980400000,
        changedAt: 1632980400000,
        lastUpdatedBy: 'test_device',
      );

      final response = {"status": "ok", "revision": 2};
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: response,
                statusCode: 200,
                requestOptions: RequestOptions(path: '/list'),
              ));

      await apiClient.addTodoItem(task);
      verify(() => mockDio.post(any(), data: task.toJson())).called(1);
      expect(apiClient.revision, 2);
    });

    test('addTodoItem handles error response', () async {
      final task = TodoModel(
        text: 'Test task',
        importance: Importance.basic,
        done: false,
        createdAt: 1632980400000,
        changedAt: 1632980400000,
        lastUpdatedBy: 'test_device',
      );

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {'status': 'error', 'message': 'Failed to add item'},
                statusCode: 400,
                requestOptions: RequestOptions(path: '/list'),
              ));

      expect(() => apiClient.addTodoItem(task), throwsA(isA<Exception>()));
      verify(() => mockDio.post(any(), data: task.toJson())).called(1);
    });

    test('updateTodoItem sends a put request and returns success', () async {
      final task = TodoModel(
        text: 'Updated task',
        importance: Importance.basic,
        done: true,
        createdAt: 1632980400000,
        changedAt: 1632980400000,
        lastUpdatedBy: 'test_device',
      );

      final response = {"status": "ok", "revision": 3};
      when(() => mockDio.put(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: response,
                statusCode: 200,
                requestOptions: RequestOptions(path: '/list/${task.id}'),
              ));

      await apiClient.updateTodoItem(task.id, task);
      verify(() => mockDio.put(any(), data: task.toJson())).called(1);
      expect(apiClient.revision, 3);
    });

    test('updateTodoItem handles error response', () async {
      final task = TodoModel(
        text: 'Updated task',
        importance: Importance.basic,
        done: true,
        createdAt: 1632980400000,
        changedAt: 1632980400000,
        lastUpdatedBy: 'test_device',
      );

      when(() => mockDio.put(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {'status': 'error', 'message': 'Failed to update item'},
                statusCode: 400,
                requestOptions: RequestOptions(path: '/list/${task.id}'),
              ));

      expect(() => apiClient.updateTodoItem(task.id, task),
          throwsA(isA<Exception>()));
      verify(() => mockDio.put(any(), data: task.toJson())).called(1);
    });

    test('deleteTodoItem sends a delete request and returns success', () async {
      final response = {"status": "ok", "revision": 4};
      when(() => mockDio.delete(any())).thenAnswer((_) async => Response(
            data: response,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/list/1'),
          ));

      await apiClient.deleteTodoItem('1');
      verify(() => mockDio.delete(any())).called(1);
      expect(apiClient.revision, 4);
    });

    test('deleteTodoItem handles error response', () async {
      when(() => mockDio.delete(any())).thenAnswer((_) async => Response(
            data: {'status': 'error', 'message': 'Failed to delete item'},
            statusCode: 400,
            requestOptions: RequestOptions(path: '/list/1'),
          ));

      expect(() => apiClient.deleteTodoItem('1'), throwsA(isA<Exception>()));
      verify(() => mockDio.delete(any())).called(1);
    });
  });
}
