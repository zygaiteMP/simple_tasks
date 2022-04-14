part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class TasksTappedTaskEdit extends TasksEvent {
  final Task task;

  const TasksTappedTaskEdit(this.task);

  @override
  List<Object> get props => [task];
}

class TasksTappedTaskCreate extends TasksEvent {
  const TasksTappedTaskCreate();
}

class TasksTappedTaskRemove extends TasksEvent {
  final Task task;

  const TasksTappedTaskRemove(this.task);

  @override
  List<Object> get props => [task];
}

class TasksToggledCompletion extends TasksEvent {
  final Task task;
  final bool isCompleted;

  const TasksToggledCompletion(this.task, this.isCompleted);

  @override
  List<Object> get props => [task, isCompleted];
}

class TasksSubscriptionRequested extends TasksEvent {
  const TasksSubscriptionRequested();
}
