import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum Importance { none, low, high }

class TodoModel extends Equatable {
  final String title;
  final Importance importance;
  final DateTime? deadline;
  final bool isDone;
  final String id;

  TodoModel({
    required this.title,
    required this.importance,
    this.deadline,
    this.isDone = false,
    id,
  }) : id = id ?? const Uuid().v4();

  // Метод для копирования объекта с изменением некоторых свойств
  TodoModel copyWith({
    String? title,
    Importance? importance,
    DateTime? deadline,
    bool? isDone,
  }) {
    return TodoModel(
      title: title ?? this.title,
      importance: importance ?? this.importance,
      deadline: deadline ?? this.deadline,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  List<Object> get props => [
        title,
        importance,
        deadline ?? DateTime.now(),
        isDone,
      ];

  @override
  bool get stringify => true;
}
