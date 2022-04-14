import 'package:tasks_api/tasks_api.dart';

class TasksRepository {
  final TasksApi _tasksApi;

  const TasksRepository({required TasksApi api}) : _tasksApi = api;

  Stream<List<Task>> getTasks() => _tasksApi.getTasks();

  Future<void> deleteTask(String id) => _tasksApi.deleteTask(id);

  Future<void> saveTask(Task task) => _tasksApi.upsertTask(task);
}
