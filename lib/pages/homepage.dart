import 'package:flutter/material.dart';
import 'package:todo_app_with_bloc/constants.dart';
import 'package:todo_app_with_bloc/data/local_storage.dart';
import 'package:todo_app_with_bloc/main.dart';
import 'package:todo_app_with_bloc/models/task_model.dart';
import 'package:todo_app_with_bloc/widgets/add_task_button.dart';
import 'package:todo_app_with_bloc/widgets/task_item.dart';
import '../blocs/bloc_exports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TasksBloc tasksBloc;
  List<Task> tasksBlocList = [];
  List<Task> allTasksBlocList = [];
  List<Task> completedTasksBlocList = [];
  List<Task> activeTasksBlocList = [];
  late LocalStorage localStorage;
  // ListType selectedListType = ListType.Tasks;

  void _getTasksFromDb() async {
    localStorage = locator<LocalStorage>();
    tasksBlocList = await localStorage.getTasks();
    tasksBloc.localStorageInit(localStorage);
    tasksBloc.getAllTask(tasksBlocList);
  }

  @override
  void initState() {
    tasksBloc = BlocProvider.of<TasksBloc>(context);

    _getTasksFromDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocBuilder<TasksBloc, TasksState>(
      buildWhen: (previous, current) {
        if (current.needRefresh) {
          tasksBloc.changeRefresh(false);
          return true;
        }
        return previous != current;
      },
      bloc: tasksBloc,
      builder: (context, state) {
        print("test");
        List<Task> list = tasksBloc.state.allTasks;
        if (tasksBloc.state.selectedListType == ListType.allTasks) {
          list = tasksBloc.state.allTasks;
        } else if (tasksBloc.state.selectedListType == ListType.completed) {
          list = tasksBloc.state.completedTasks;
        } else if (tasksBloc.state.selectedListType == ListType.active) {
          list = tasksBloc.state.activeTasks;
        }

        print(tasksBloc.state.selectedListType);
        return Scaffold(
          backgroundColor: const Color(0xff9cc5fc),
          resizeToAvoidBottomInset: false,
          body: Column(children: [
            SizedBox(
              width: width,
              height: height * 0.01,
            ),
            Container(
              height: height * AreaSizes().appbarMultip,
              width: width,
              decoration: BoxDecoration(gradient: Constants().appbarGradient),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                        flex: 05,
                        child: Container(
                          decoration:
                              BoxDecoration(gradient: Constants().bgGradient),
                          child: TextField(
                            /*  onSubmitted: (value) {
                              tasksBloc.searchList(
                                list,
                                needRefh: true,
                                value: value,
                              );
                            }, */
                            onChanged: (value) {
                              tasksBloc.searchList(
                                list,
                                needRefh: true,
                                value: value,
                              );
                              tasksBloc.changeText("All");
                            },
                            style: Constants().textStyle,
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            cursorColor: Constants().addButtonColor,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Constants().addButtonColor,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Constants().addButtonColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Constants().buttonIconColor),
                              ),
                            ),
                          ),
                        )),
                    AddTaskButton(
                      tasksBloc: tasksBloc,
                      localStorage: localStorage,
                      tasksBlocList: tasksBlocList,
                    ),
                    PopupMenuButton(
                      onSelected: (value) {
                        print("taskbloclist length : ${tasksBlocList.length}");
                        if (value == 'allTasks') {
                          tasksBloc.getAllTask(tasksBloc.state.allTasks,
                              selectedListType: ListType.allTasks,
                              text: "All",
                              needRefh: true);
                          print("allTasks length : ${state.allTasks.length}");
                        } else if (value == 'completedTasks') {
                          tasksBloc.getAllTask(tasksBloc.state.allTasks,
                              selectedListType: ListType.completed,
                              text: "Completed",
                              needRefh: true);
                          print(
                              "completedlist length : ${state.completedTasks.length}");
                        } else if (value == 'activeTasks') {
                          tasksBloc.getAllTask(tasksBloc.state.allTasks,
                              selectedListType: ListType.active,
                              text: "Active",
                              needRefh: true);
                          print(
                              "activeTasks length : ${state.activeTasks.length}");
                        }
                      },
                      icon: Icon(
                        Icons.more_vert_sharp,
                        color: Constants().addButtonColor,
                      ),
                      color: Constants().buttonIconColor,
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem(
                            value: 'allTasks',
                            child: Text(
                              'All',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'completedTasks',
                            child: Text(
                              'Completed',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'activeTasks',
                            child: Text(
                              'Active',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ];
                      },
                    ),
                  ]),
            ),
            Container(
                decoration: BoxDecoration(color: Colors.purple.shade200),
                height: height * 0.060,
                width: width,
                child: Center(
                    child: Text(
                  state.text!,
                  style: Constants().timeStyle,
                ))),
            Expanded(
              child: Container(
                height: height * AreaSizes().bodyMultip,
                width: width,
                decoration: BoxDecoration(gradient: Constants().bgGradient),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: list.isNotEmpty ? list.length : 1,
                  itemBuilder: (context, index) {
                    return list.isNotEmpty
                        ? Dismissible(
                            background: Center(
                              child: Text(
                                "Remove task",
                                style: Constants().textStyle,
                              ),
                            ),
                            key: ValueKey(list[index].id),
                            onDismissed: (direction) {
                              tasksBloc.changeRefresh(true);
                              // localStorage.deleteTask(task: list[index]);

                              tasksBloc.deleteTask(list[index], list, index,);
                              _getTasksFromDb();
                              print("<<<<<<<");
                              print("list : ${list.length}");
                              print("index : ${index}");
                              print(">>>>>>>");
                              /*    tasksBloc.removeAt(
                                index,
                              ); */
                            },
                            child: TaskItem(
                              tasksBlocList: tasksBlocList,
                              localStorage: localStorage,
                              tasksBloc: tasksBloc,
                              index: index,
                              task: list[index],
                            ),
                          )
                        : const Center(
                            child: Text(
                              "Add new task",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                  },
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}
