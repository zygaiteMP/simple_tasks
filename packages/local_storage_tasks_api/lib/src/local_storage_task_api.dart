import 'dart:async';
import 'dart:convert';

import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks_api/tasks_api.dart';

class LocalStorageTasksApi extends TasksApi {
  static const kTaskPrefsKey = 'simple_task_key_global';

  final SharedPreferences _prefs;
  final _taskStreamSubject = BehaviorSubject<List<Task>>.seeded(const []);

  LocalStorageTasksApi({required SharedPreferences prefs}) : _prefs = prefs {
    _init();
  }

  void _init() {
    final tasksJson = _prefs.getString(kTaskPrefsKey);
    if (tasksJson == null) {
      _taskStreamSubject.add(const []);
    } else {
      _taskStreamSubject.add(List<Map>.from(json.decode(tasksJson) as List)
          .map((e) => Task.fromJson(Map<String, dynamic>.from(e)))
          .toList());
    }
  }

  @override
  Future<void> deleteTask(String id) {
    final tasks = _taskStreamSubject.value.toList();
    final index = tasks.indexWhere((element) => element.id == id);
    if (index != -1) {
      tasks.removeAt(index);
      _taskStreamSubject.add(tasks);
      return _prefs.setString(kTaskPrefsKey, json.encode(tasks));
    } else {
      throw Exception('Cannot delete non existent task.');
    }
  }

  @override
  Stream<List<Task>> getTasks() => _taskStreamSubject.asBroadcastStream();

  @override
  Future<void> upsertTask(Task task) {
    final tasks = _taskStreamSubject.value.toList();
    final index = tasks.indexWhere((element) => element.id == task.id);
    if (index >= 0) {
      tasks[index] = task;
    } else {
      tasks.add(task);
    }
    _taskStreamSubject.add(tasks);
    return _prefs.setString(kTaskPrefsKey, json.encode(tasks));
  }
}
