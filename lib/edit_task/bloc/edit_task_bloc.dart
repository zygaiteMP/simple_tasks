import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'edit_task_event.dart';

part 'edit_task_state.dart';

class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState> {
  final TasksRepository _repo;

  EditTaskBloc({required TasksRepository repository, required Task? task})
      : _repo = repository,
        super(EditTaskState(
            task: task,
            details: task?.details ?? '',
            isCompleted: task?.isCompleted ?? false)) {
    on<EditTaskDetailsChanged>(_onDetailsChanged);
    on<EditTaskCompletedChanged>(_onTaskCompletedChanged);
    on<EditTaskDoneTapped>(_onTaskDone);
  }

  void _onDetailsChanged(
      EditTaskDetailsChanged event, Emitter<EditTaskState> emit) {
    emit(state.copyWith(details: event.details));
  }

  void _onTaskCompletedChanged(
      EditTaskCompletedChanged event, Emitter<EditTaskState> emit) {
    emit(state.copyWith(isCompleted: event.isCompleted));
  }

  Future<void> _onTaskDone(
      EditTaskDoneTapped event, Emitter<EditTaskState> emit) async {
    emit(state.copyWith(status: EditTaskStatus.loading));
    final task = (state.task ?? Task(details: ''))
        .copyWith(details: state.details, isCompleted: state.isCompleted);
    if (task.details.isNotEmpty) {
      try {
        await _repo.saveTask(task);
        emit(state.copyWith(status: EditTaskStatus.success));
      } catch (e) {
        emit(state.copyWith(status: EditTaskStatus.failure));
      }
    } else {
      emit(state.copyWith(status: EditTaskStatus.failure));
    }
  }
}
