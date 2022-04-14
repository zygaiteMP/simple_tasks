import 'package:tasks_api/src/model/task.dart';

abstract class TasksApi {
  const TasksApi();

  Stream<List<Task>> getTasks();

  Future<void> upsertTask(Task task);

  Future<void> deleteTask(String id);
}