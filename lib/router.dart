import 'package:go_router/go_router.dart';
import 'package:task_manager/features/task/domain/todo_model.dart';
import 'package:task_manager/features/task/presentation/pages/add_edit_task_page.dart';
import 'package:task_manager/features/task/presentation/pages/home_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'add_task',
          builder: (context, state) {
            final todo = state.extra as TodoModel?;
            return AddEditTaskPage(todo: todo);
          },
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    // Обработка диплинков
    if (state.uri.toString().contains('add_task')) {
      return '/add_task';
    }
    return null;
  },
);
