part of 'edit_task_bloc.dart';

abstract class EditTaskEvent extends Equatable {
  const EditTaskEvent();

  @override
  List<Object?> get props => [];
}

class EditTaskDetailsChanged extends EditTaskEvent {
  final String details;

  const EditTaskDetailsChanged(this.details);

  @override
  List<Object?> get props => [details];
}

class EditTaskCompletedChanged extends EditTaskEvent {
  final bool isCompleted;

  const EditTaskCompletedChanged(this.isCompleted);

  @override
  List<Object?> get props => [isCompleted];
}

class EditTaskDoneTapped extends EditTaskEvent {
  const EditTaskDoneTapped();
}
