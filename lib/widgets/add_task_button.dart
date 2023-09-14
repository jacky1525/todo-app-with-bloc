import 'package:flutter/material.dart';
import 'package:todo_app_with_bloc/animation/custom_rect_tween.dart';
import 'package:todo_app_with_bloc/animation/hero_dialog_route.dart';
import 'package:todo_app_with_bloc/blocs/bloc_exports.dart';
import 'package:todo_app_with_bloc/constants.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:todo_app_with_bloc/data/local_storage.dart';
import 'package:todo_app_with_bloc/models/task_model.dart';
import 'package:uuid/uuid.dart';

class AddTaskButton extends StatelessWidget {
  final LocalStorage localStorage;
  List<Task> tasksBlocList;
  final TasksBloc tasksBloc;
  AddTaskButton({
    required this.localStorage,
    super.key,
    required this.tasksBlocList,
    required this.tasksBloc,
  });

  @override
  Widget build(BuildContext buildContext) {
    const String _heroTodo = 'add-todo-hero';
    return Flexible(
      flex: 02,
      child: GestureDetector(
        onTap: () {
          Navigator.of(buildContext).push(
            HeroDialogRoute(
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 16),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Hero(
                        tag: _heroTodo,
                        createRectTween: (begin, end) {
                          return CustomRectTween(begin: begin!, end: end!);
                        },
                        child: Material(
                          color: Constants().buttonIconColor,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 3,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    onTapOutside: (event) => FocusManager
                                        .instance.primaryFocus
                                        ?.unfocus(),
                                    onSubmitted: (value) {
                                      Navigator.of(context).pop();
                                      picker.DatePicker.showTimePicker(
                                        context,
                                        showSecondsColumn: false,
                                        locale: picker.LocaleType.tr,
                                        onConfirm: (time) {
                                          var task = Task(
                                              id: const Uuid().v4(),
                                              title: value,
                                              isComplete: false,
                                              createdAt: time);
                                          tasksBloc.addTaskNew(task);
                                          tasksBloc.changeRefresh(true);
                                        },
                                        theme: picker.DatePickerTheme(
                                          backgroundColor:
                                              Constants().buttonIconColor,
                                          itemStyle: TextStyle(
                                              color:
                                                  Constants().addButtonColor),
                                          cancelStyle: TextStyle(
                                              color:
                                                  Constants().addButtonColor),
                                          doneStyle: TextStyle(
                                              color:
                                                  Constants().addButtonColor),
                                        ),
                                      );
                                    },
                                    cursorColor: Constants().addButtonColor,
                                    style: Constants().textStyle,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        child: Hero(
          tag: _heroTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Icon(
            Icons.add,
            color: Constants().addButtonColor,
            size: 32,
          ),
        ),
      ),
    );
  }
}
