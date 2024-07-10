// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'task_cubit.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TodoModel> tasks;
  final bool isConnected;

  const TaskLoaded(
    this.tasks,
    this.isConnected,
  );

  @override
  List<Object> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
