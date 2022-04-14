import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/edit_task/bloc/edit_task_bloc.dart';

void main() {
  group('EditTaskEvent', () {
    group('DetailsChanged', () {
      test('supports value equality', () {
        expect(
          const EditTaskDetailsChanged('some details'),
          equals(const EditTaskDetailsChanged('some details')),
        );
      });

      test('props are correct', () {
        expect(
          const EditTaskDetailsChanged('details').props,
          equals(<Object?>[
            'details',
          ]),
        );
      });
    });

    group('CompletedChanged', () {
      test('supports value equality', () {
        expect(
          const EditTaskCompletedChanged(true),
          equals(const EditTaskCompletedChanged(true)),
        );
      });

      test('props are correct', () {
        expect(
          const EditTaskCompletedChanged(true).props,
          equals(<Object?>[
            true,
          ]),
        );
      });
    });

    group('EditTaskDoneTapped', () {
      test('supports value equality', () {
        expect(
          const EditTaskDoneTapped(),
          equals(const EditTaskDoneTapped()),
        );
      });

      test('props are correct', () {
        expect(
          const EditTaskDoneTapped().props,
          equals(<Object?>[]),
        );
      });
    });
  });
}
