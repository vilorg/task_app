import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/core/constants/shadows.dart';
import 'package:task_manager/features/task/domain/cubit/task_cubit.dart';
import 'package:task_manager/features/task/domain/todo_model.dart';
import 'package:task_manager/features/task/presentation/widgets/todo_custom_sliver_header.dart';
import 'package:task_manager/features/task/presentation/widgets/task_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TaskLoaded && !state.isConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  localizations.noNetwork,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            List<TodoModel> todos = state.tasks;
            List<TodoModel> currentTasks = todos.toList();
            if (isHidden) {
              currentTasks = todos.where((e) => !e.done).toList();
            }
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: TodoCustomSliverHeader(
                    localizations: localizations,
                    topPadding: MediaQuery.of(context).padding.top,
                    doneCount: todos.where((e) => e.done).length,
                    isHidden: isHidden,
                    onTap: () => setState(() => isHidden = !isHidden),
                  ),
                  pinned: true,
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(15.0),
                  sliver: DecoratedSliver(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      boxShadow: AppShadows.tileShadow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          for (var todo in currentTasks)
                            TaskItem(
                              todo: todo,
                              onToggleDone: (todo) {
                                context.read<TaskCubit>().updateTask(
                                    todo.copyWith(done: !todo.done));
                              },
                              onDelete: (todo) {
                                context.read<TaskCubit>().deleteTask(todo.id);
                              },
                              isHidden: isHidden,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                    padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                )),
              ],
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No tasks'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add_task'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
