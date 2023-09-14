import 'package:hive/hive.dart';

import '../models/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<List<Task>> getTasks();
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
  Future<Task> updateIsComplete({required Task task});
}

class HiveLocalStorage extends LocalStorage {
  List<Task> _tasks = <Task>[];
  late Box<Task> _taskBox;
  HiveLocalStorage() {
    _taskBox = Hive.box<Task>("tasks");
  }

  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await _taskBox.delete(task.id);
    return true;
  }

  @override
  Future<List<Task>> getTasks() async {
    var taskBox = await Hive.openBox<Task>("tasks");
    var boxValues = taskBox.values;

    _tasks = boxValues.toList();
    if (_tasks.isNotEmpty) {
      _tasks.sort(((Task a, Task b) => b.createdAt.compareTo(a.createdAt)));
    }
    return _tasks;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> _allTask = <Task>[];

    _tasks.forEach((task) {
      _allTask.add(task);
    });

    if (_allTask.isNotEmpty) {
      _allTask.sort(((Task a, Task b) => b.createdAt.compareTo(a.createdAt)));
    }
    return _allTask;
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    await _taskBox.put(task.id, task);

    return task;
  }

  @override
  Future<Task> updateIsComplete({required Task task}) async {
    task.isComplete = !task.isComplete!;
    await _taskBox.put(task.id, task);

    return task;
  }
}
