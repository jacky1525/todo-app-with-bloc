// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool? isComplete;

  @HiveField(3)
  final DateTime createdAt;

  Task(
      {required this.id,
      required this.title,
      required this.isComplete,
      required this.createdAt});

  factory Task.create({required String title, required DateTime createdAt}) {
    return Task(
        id: const Uuid().v1(),
        title: title,
        createdAt: createdAt,
        isComplete: false);
  }

  Task copyWith({
    String? id,
    String? title,
    bool? isComplete,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isComplete: isComplete ?? this.isComplete,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
