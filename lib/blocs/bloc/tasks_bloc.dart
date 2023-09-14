import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_with_bloc/constants.dart';
import 'package:todo_app_with_bloc/data/local_storage.dart';
import 'package:todo_app_with_bloc/services/services.dart';
import 'package:uuid/uuid.dart';

import '../../models/task_model.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {}

  void deleteTask(Task task, List<Task> list, int index,
      {ListType selectedListType = ListType.allTasks}) async {
    List<Task> newList = state.allTasks;
    bool isRemove = newList.remove(task);

    if (isRemove) {
      if (state.localStorage != null) {
        state.localStorage!.deleteTask(task: task);
      }
      newList = await state.localStorage!.getTasks();
      getAllTask(newList);
    } else {
      getAllTask(state.allTasks);
    }

    print("alltasks length : ${state.allTasks.length}");
    print("completedtasks length : ${state.completedTasks.length}");
    print("activetasks length : ${state.activeTasks.length}");
  }

  void addTaskNew(Task task) async {
    List<Task> list = await Services().addTasktoList(state.allTasks, task);

    //newList= state.allTasks;

    state.localStorage!.addTask(task: task);

    getAllTask(list);
  }

  void removeAt(int index, {ListType selectedListType = ListType.allTasks}) {
    emit(state.copyWith(allTasks: state.allTasks..removeAt(index)));
    getAllTask(state.allTasks);
  }

  void checkComplete(
      {required bool value,
      required int index,
      ListType selectedListType = ListType.allTasks,
      bool needRefh = false}) async {
    final state = this.state;
    List<Task> list;
    list = await state.localStorage!.getTasks();
    List<Task> completeList = await Services().filteredCompletedTasks(list);

    List<Task> activeList = await Services().filteredActiveTasks(list);

    bool check = list[index].isComplete!;

    if (value) {
      check = true;
    } else {
      check = false;
    }

    Task newTask = Task(
        id: const Uuid().v4(),
        title: state.allTasks[index].title,
        isComplete: check,
        createdAt: state.allTasks[index].createdAt);

    list[index] = newTask;

    if (selectedListType == ListType.completed) {
      emit(state.copyWith(
        completedTasks: completeList,
        needRefresh: needRefh,
      ));
      changeText("Completed");

      selectedListChange(ListType.completed);
    } else if (selectedListType == ListType.active) {
      emit(state.copyWith(
        activeTasks: activeList,
        needRefresh: needRefh,
      ));
      changeText("Active");

      selectedListChange(ListType.active);
    } else {
      emit(state.copyWith(needRefresh: true));
    }
  }

  void updateTitle(
    bool isComplete,
    String title,
    DateTime createdAt,
    int index,
  ) async {
    final state = this.state;
    List<Task> list;
    list = await state.localStorage!.getTasks();

    Task newTask = Task(
        id: const Uuid().v4(),
        title: title,
        isComplete: isComplete,
        createdAt: createdAt);

    list[index] = newTask;
    changeRefresh(true);
  }

  void getAllTask(List<Task> list,
      {String text = "All",
      ListType selectedListType = ListType.allTasks,
      bool needRefh = false}) async {
    List<Task> completeList = await Services().filteredCompletedTasks(list);

    List<Task> activeList = await Services().filteredActiveTasks(list);

    if (selectedListType == ListType.allTasks) {
      emit(state.copyWith(
        allTasks: list,
        needRefresh: needRefh,
      ));
      changeText("All");
      selectedListChange(ListType.allTasks);
      changeText(text);
    } else if (selectedListType == ListType.completed) {
      emit(state.copyWith(
        completedTasks: completeList,
        needRefresh: needRefh,
      ));
      changeText("Completed");

      selectedListChange(ListType.completed);
    } else {
      emit(state.copyWith(
        activeTasks: activeList,
        needRefresh: needRefh,
      ));
      changeText("Active");

      selectedListChange(ListType.active);
    }

    //emit(state.copyWith(allTasks: selectedListType == ListType.allTasks ? list :state.activeTasks,selectedListType: ListType.active : ))
  }

  void searchList(List<Task> list,
      {ListType selectedListType = ListType.allTasks,
      String? value,
      bool needRefh = false}) async {
    List<Task> searchList = await Services().searchTasks(
      list,
      value!,
    );

    if (selectedListType == ListType.allTasks) {
      emit(state.copyWith(
        allTasks: searchList,
        needRefresh: needRefh,
      ));
      selectedListChange(ListType.allTasks);
    } else if (selectedListType == ListType.completed) {
      emit(state.copyWith(
        completedTasks: searchList,
        needRefresh: needRefh,
      ));

      selectedListChange(ListType.completed);
    } else {
      emit(state.copyWith(
        activeTasks: searchList,
        needRefresh: needRefh,
      ));

      selectedListChange(ListType.active);
    }
  }

  void changeRefresh(bool value) {
    emit(state.copyWith(
      needRefresh: value,
    ));
  }

  void selectedListChange(ListType listType, {var value}) {
    emit(state.copyWith(selectedListType: listType, needRefresh: value));
  }

  void changeText(String text) {
    String mText = "All";
    mText = text;

    emit(state.copyWith(text: mText));
  }

  void localStorageInit(LocalStorage localStorage) {
    emit(state.copyWith(localStorage: localStorage));
  }
}
