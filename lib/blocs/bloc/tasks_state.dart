part of 'tasks_bloc.dart';

class TasksState extends Equatable {
  final List<Task> allTasks;
  final List<Task> completedTasks;
  final List<Task> activeTasks;
  final bool needRefresh;
  final ListType selectedListType;
  final LocalStorage? localStorage;
  final String? text;

  const TasksState({
    LocalStorage? localStorage,
    List<Task>? allTasks,
    List<Task>? completedTasks,
    List<Task>? activeTasks,
    bool? needRefresh,
    ListType? selectedListType,
    String? text,
  })  : localStorage = localStorage ?? null,
        allTasks = allTasks ?? const <Task>[],
        completedTasks = completedTasks ?? const <Task>[],
        activeTasks = activeTasks ?? const <Task>[],
        needRefresh = needRefresh ?? false,
        selectedListType = selectedListType ?? ListType.allTasks,
        text = text ?? "All";

  @override
  List<Object?> get props => [
        localStorage,
        allTasks,
        completedTasks,
        activeTasks,
        needRefresh,
        selectedListType,
        text,
      ];

  TasksState copyWith({
    LocalStorage? localStorage,
    List<Task>? allTasks,
    List<Task>? completedTasks,
    List<Task>? activeTasks,
    bool? needRefresh,
    ListType? selectedListType,
    String? text,
  }) {
    return TasksState(
        localStorage: localStorage ?? this.localStorage,
        allTasks: allTasks ?? this.allTasks,
        completedTasks: completedTasks ?? this.completedTasks,
        activeTasks: activeTasks ?? this.activeTasks,
        needRefresh: needRefresh ?? this.needRefresh,
        selectedListType: selectedListType ?? this.selectedListType,
        text: text ?? this.text);
  }
}
