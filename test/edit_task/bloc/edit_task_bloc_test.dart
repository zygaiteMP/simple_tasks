import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tasks/edit_task/bloc/edit_task_bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';

class MockTaskRepository extends Mock implements TasksRepository {}

class FakeTask extends Fake implements Task {}

void main() {
  group('EditTaskBloc', () {
    late TasksRepository repo;

    setUp(() {
      repo = MockTaskRepository();
    });

    setUpAll(() {
      registerFallbackValue(FakeTask());
    });

    EditTaskBloc buildBloc() {
      return EditTaskBloc(
        repository: repo,
        task: null,
      );
    }

    test('works properly', () {
      expect(buildBloc, returnsNormally);
    });
    test('has correct initial state', () {
      expect(
        buildBloc().state,
        equals(const EditTaskState()),
      );
    });

    group('Task events', () {
      blocTest<EditTaskBloc, EditTaskState>(
        'Details Changed: emits new state with new details',
        build: buildBloc,
        act: (bloc) => bloc.add(const EditTaskDetailsChanged('new Details')),
        expect: () => const [
          EditTaskState(details: 'new Details'),
        ],
      );

      blocTest<EditTaskBloc, EditTaskState>(
        'Completed Changed: emits new state with updated isCompleted field.',
        build: buildBloc,
        act: (bloc) => bloc.add(const EditTaskCompletedChanged(true)),
        expect: () => const [
          EditTaskState(isCompleted: true),
        ],
      );

      blocTest<EditTaskBloc, EditTaskState>(
        'attempts to save new task to repository '
        'if no initial task was provided',
        setUp: () {
          when(() => repo.saveTask(any())).thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => const EditTaskState(
          details: 'details',
          isCompleted: false,
        ),
        act: (bloc) => bloc.add(const EditTaskDoneTapped()),
        expect: () => const [
          EditTaskState(
              status: EditTaskStatus.loading,
              details: 'details',
              isCompleted: false),
          EditTaskState(
              status: EditTaskStatus.success,
              details: 'details',
              isCompleted: false),
        ],
        verify: (bloc) {
          verify(
            () => repo.saveTask(
              any(
                that: isA<Task>()
                    .having((t) => t.details, 'details', equals('details'))
                    .having((t) => t.isCompleted, 'false', equals(false)),
              ),
            ),
          ).called(1);
        },
      );
    });
  });
}
