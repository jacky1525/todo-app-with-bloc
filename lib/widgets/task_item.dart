import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_with_bloc/blocs/bloc_exports.dart';
import 'package:todo_app_with_bloc/constants.dart';

import '../data/local_storage.dart';
import '../models/task_model.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final int index;
  final TasksBloc tasksBloc;
  final LocalStorage localStorage;
  List<Task> tasksBlocList;
  TaskItem(
      {super.key,
      required this.localStorage,
      required this.task,
      required this.tasksBlocList,
      required this.index,
      required this.tasksBloc});

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textEditingController.text = task.title;
    return ListTile(
      title: task.isComplete!
          ? Text(
              task.title,
              style: Constants().textStyle,
            )
          : TextField(
              minLines: 1,
              maxLines: null,
              style: Constants().textStyle,
              textInputAction: TextInputAction.done,
              controller: textEditingController,
              onSubmitted: (value) {
                task.title = value;
                tasksBloc.updateTitle(
                    task.isComplete!, task.title, DateTime.now(), index);
                localStorage.updateTask(task: task);
              },
              decoration: const InputDecoration(border: InputBorder.none),
            ),
      leading: Transform.scale(
        scale: 1.25,
        child: Checkbox(
          value: task.isComplete,
          focusColor: Colors.red,
          onChanged: (value) {
            tasksBloc.checkComplete(
                value: value!,
                index: index,
                needRefh: true,
                selectedListType: tasksBloc.state.selectedListType);
            value = task.isComplete;
            localStorage.updateIsComplete(task: task);
          },
          checkColor: Colors.red,
        ),
      ),
      trailing: Text(
        DateFormat("hh:mm a").format(task.createdAt),
        style: Constants().timeStyle,
      ),
    );
  }
}
