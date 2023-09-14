part of 'tasks_bloc.dart';

class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class AddTask extends TasksEvent {
  final Task task;

  const AddTask({required this.task});

  @override
  List<Object> get props => [task];
}

class GetTask extends TasksEvent {
  final Task task;

  const GetTask({required this.task});

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TasksEvent {
  final Task task;

  const DeleteTask({required this.task});

  @override
  List<Object> get props => [task];
}

class ChangeListCompleted extends TasksEvent {
  final Task task;

  const ChangeListCompleted({required this.task});
  @override
  List<Object> get props => [task];
}

class UpdateTitle extends TasksEvent {
  final Task task;

  const UpdateTitle({required this.task});

  @override
  List<Object> get props => [task];
}

class UpdateComplete extends TasksEvent {
  final Task task;

  const UpdateComplete({required this.task});

  @override
  List<Object> get props => [task];
}
