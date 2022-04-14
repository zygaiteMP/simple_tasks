import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:tasks/edit_task/bloc/edit_task_bloc.dart';
import 'package:tasks/edit_task/view/edit_task_page.dart';
import 'package:tasks_repository/tasks_repository.dart';

class MockEditTaskBloc extends MockBloc<EditTaskEvent, EditTaskState>
    implements EditTaskBloc {}

void main() {
  final mockTask = Task(id: '2', details: "Task details", isCompleted: false);
  late MockNavigator navigator;
  late EditTaskBloc bloc;

  setUp(() {
    navigator = MockNavigator();
    when(() => navigator.push(any())).thenAnswer((_) async {
      return null;
    });
    bloc = MockEditTaskBloc();
    when(() => bloc.state).thenReturn(
      EditTaskState(
        task: mockTask,
        details: mockTask.details,
        isCompleted: mockTask.isCompleted,
      ),
    );
  });

  group('EditTaskPage', () {
    Widget buildSubject() {
      return MockNavigatorProvider(
        navigator: navigator,
        child: BlocProvider.value(
          value: bloc,
          child: const EditTaskPage(),
        ),
      );
    }
  });
}
