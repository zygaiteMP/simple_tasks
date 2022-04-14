import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/edit_task/bloc/edit_task_bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';

void main() {
  group('EditTaskState', () {
    final mockTask = Task(id: '2', details: "Task details", isCompleted: false);
    EditTaskState createSubject(
        {EditTaskStatus status = EditTaskStatus.initial,
        Task? task,
        String details = ''}) {
      return EditTaskState(
          status: status, task: task, details: details, isCompleted: false);
    }

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: EditTaskStatus.initial,
          task: mockTask,
          details: 'Task details',
        ).props,
        equals(
            <Object?>[EditTaskStatus.initial, mockTask, 'Task details', false]),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: EditTaskStatus.initial,
          task: mockTask,
          details: 'Task details',
        ).props,
        equals(
            <Object?>[EditTaskStatus.initial, mockTask, 'Task details', false]),
      );
    });

    test('copyWith returns the same object if not arguments are provided', () {
      expect(
        createSubject().copyWith(),
        equals(createSubject()),
      );
    });
  });
}
