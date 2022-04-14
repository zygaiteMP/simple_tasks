part of 'tasks_bloc.dart';

enum TasksStatus { initial, loading, failure, success }

class TasksState extends Equatable {
  const TasksState({this.status = TasksStatus.initial, this.tasks = const []});

  final TasksStatus status;
  final List<Task> tasks;

  @override
  List<Object?> get props => [status, tasks];

  TasksState copyWith(
      {TasksStatus Function()? status, List<Task> Function()? tasks}) {
    return TasksState(
      status: status != null ? status() : this.status,
      tasks: tasks != null ? tasks() : this.tasks,
    );
  }
}
