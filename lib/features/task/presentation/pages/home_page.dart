import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/shadows.dart';
import 'package:task_manager/core/logger.dart';
import 'package:task_manager/features/task/domain/todo_model.dart';
import 'package:task_manager/features/task/presentation/pages/add_edit_task_page.dart';
import 'package:task_manager/features/task/presentation/widgets/custom_sliver_header.dart';
import 'package:task_manager/features/task/presentation/widgets/task_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isHidden = true;

  List<TodoModel> todos = [
    TodoModel(
      title: 'Buy groceries',
      importance: Importance.high,
      deadline: DateTime.now().add(const Duration(days: 1)),
    ),
    TodoModel(
      title: 'Walk the dog',
      importance: Importance.low,
    ),
    TodoModel(
      title: 'Buy groceries',
      importance: Importance.high,
      deadline: DateTime.now().add(const Duration(days: 1)),
    ),
    TodoModel(
      title: 'Walk the dog',
      importance: Importance.low,
    ),
    TodoModel(
      title: 'Buy groceries',
      importance: Importance.high,
      deadline: DateTime.now().add(const Duration(days: 1)),
    ),
    TodoModel(
      title: 'Walk the dog',
      importance: Importance.low,
    ),
    TodoModel(
      title: 'Buy groceries',
      importance: Importance.high,
      deadline: DateTime.now().add(const Duration(days: 1)),
    ),
    TodoModel(
      title: 'Walk the dog',
      importance: Importance.none,
    ),
    TodoModel(
      title: 'Buy groceries',
      importance: Importance.none,
      deadline: DateTime.now().add(const Duration(days: 1)),
    ),
    TodoModel(
      title: 'Walk the dog',
      importance: Importance.none,
    ),
    TodoModel(
      title: 'Buy groceries',
      importance: Importance.high,
      deadline: DateTime.now().add(const Duration(days: 1)),
    ),
    TodoModel(
      title: 'Walk the dog',
      importance: Importance.low,
    ),
    TodoModel(
      title: 'Buy groceries',
      importance: Importance.high,
      deadline: DateTime.now().add(const Duration(days: 1)),
    ),
    TodoModel(
      title: 'Walk the dog',
      importance: Importance.low,
    ),
    TodoModel(
      title: 'Buy groceries',
      importance: Importance.high,
      deadline: DateTime.now().add(const Duration(days: 1)),
    ),
    TodoModel(
      title: 'Walk the dog',
      importance: Importance.low,
    ),
  ];

  void _toggleDone(TodoModel todo) {
    int index = todos.indexWhere((e) => e.id == todo.id);

    setState(
      () => todos[index] = todos[index].copyWith(isDone: !todos[index].isDone),
    );
    logger.i(
        'Task "${todo.title}" toggled to ${todo.isDone ? 'done' : 'not done'}');
  }

  void _deleteTodo(TodoModel todo) {
    setState(() {
      todos.remove(todo);
    });
    logger.i('Task "${todo.title}" deleted');
  }

  Future<void> _addOrEditTask({TodoModel? todo}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskPage(todo: todo),
      ),
    );

    if (result != null && result is TodoModel) {
      setState(() {
        if (todo != null) {
          final index = todos.indexWhere((e) => e.id == todo.id);
          todos[index] = result;
          logger.i('Task "${result.title}" edited');
        } else {
          todos.add(result);
          logger.i('Task "${result.title}" added');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TodoModel> currentTasks = todos;
    if (isHidden) {
      currentTasks = todos.where((e) => !e.isDone).toList();
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: CustomSliverHeader(
              topPadding: MediaQuery.of(context).padding.top,
              doneCount: todos.where((e) => e.isDone).length,
              isHidden: isHidden,
              onTap: () => setState(() => isHidden = !isHidden),
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  boxShadow: AppShadows.tileShadow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    for (var todo in currentTasks)
                      InkWell(
                        onTap: () => _addOrEditTask(todo: todo),
                        child: TaskItem(
                          todo: todo,
                          onToggleDone: _toggleDone,
                          onDelete: _deleteTodo,
                          isHidden: isHidden,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTask(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
