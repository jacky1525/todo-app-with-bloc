import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_with_bloc/blocs/bloc/tasks_bloc.dart';

import '../models/task_model.dart';

class Services {
  Future<List<Task>> searchTasks(List<Task> list, String value) async {
    var taskBox = await Hive.openBox<Task>("tasks");

    List<Task> searchList = taskBox.values
        .where((task) => task.title.toLowerCase().contains(value.toLowerCase()))
        .toList();

    return searchList;
  }

  Future<List<Task>> filteredCompletedTasks(List<Task> allList) async {
    var taskBox = await Hive.openBox<Task>("tasks");

    List<Task> completedList =
        taskBox.values.where((task) => task.isComplete == true).toList();

    return completedList;
  }

  Future<List<Task>> filteredActiveTasks(List<Task> allList) async {
    var taskBox = await Hive.openBox<Task>("tasks");

    List<Task> activeList =
        taskBox.values.where((task) => task.isComplete == false).toList();
    return activeList;
  }

  Future<List<Task>> addTasktoList(List<Task> list, Task task) async {
    List<Task> newList = [];
    if (list.isNotEmpty) {
      list.add(task);
      return list;
    } else {
      list.forEach((taskItem) {
        newList.add(taskItem);
      });
      newList.add(task);
      return newList;
    }
  }
}
