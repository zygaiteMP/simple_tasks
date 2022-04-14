part of 'edit_task_bloc.dart';

enum EditTaskStatus { initial, loading, failure, success }

class EditTaskState extends Equatable {
  final EditTaskStatus status;
  final Task? task;
  final String details;
  final bool isCompleted;

  const EditTaskState(
      {this.status = EditTaskStatus.initial,
      this.task,
      this.details = '',
      this.isCompleted = false});

  EditTaskState copyWith(
          {EditTaskStatus? status,
          Task? task,
          String? details,
          bool? isCompleted}) =>
      EditTaskState(
        status: status ?? this.status,
        task: task ?? this.task,
        details: details ?? this.details,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  @override
  List<Object?> get props => [status, task, details, isCompleted];
}
