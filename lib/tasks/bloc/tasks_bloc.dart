import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'tasks_event.dart';

part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository _repo;

  TasksBloc({required TasksRepository repo})
      : _repo = repo,
        super(const TasksState()) {
    on<TasksSubscriptionRequested>(_onSubscriptionRequested);
    on<TasksTappedTaskEdit>(_onTaskEdit);
    on<TasksTappedTaskRemove>(_onTaskDeletion);
    on<TasksToggledCompletion>(_onTaskCompletionToggled);
  }

  Future<void> _onSubscriptionRequested(
      TasksSubscriptionRequested event, Emitter<TasksState> emit) async {
    emit(state.copyWith(status: () => TasksStatus.loading));
    await emit.forEach<List<Task>>(_repo.getTasks(),
        onData: (tasks) => state.copyWith(
            status: () => TasksStatus.success, tasks: () => tasks),
        onError: (_, __) => state.copyWith(status: () => TasksStatus.failure));
  }

  Future<void> _onTaskEdit(
      TasksTappedTaskEdit event, Emitter<TasksState> emit) async {
    await _repo.saveTask(event.task);
  }

  Future<void> _onTaskCompletionToggled(
      TasksToggledCompletion event, Emitter<TasksState> emit) async {
    await _repo.saveTask(event.task.copyWith(isCompleted: event.isCompleted));
  }

  Future<void> _onTaskDeletion(
      TasksTappedTaskRemove event, Emitter<TasksState> emit) async {
    await _repo.deleteTask(event.task.id);
  }
}
