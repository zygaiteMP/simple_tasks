import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tasks/edit_task/bloc/edit_task_bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage({Key? key}) : super(key: key);

  static Route<void> route({Task? task}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditTaskBloc(
          repository: context.read<TasksRepository>(),
          task: task,
        ),
        child: const EditTaskPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTaskBloc, EditTaskState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status && curr.status == EditTaskStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditTaskView(),
    );
  }
}

class EditTaskView extends StatelessWidget {
  const EditTaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit =
        context.select((EditTaskBloc bloc) => bloc.state.task != null);
    final state = context.select((EditTaskBloc bloc) => bloc.state);
    return Scaffold(
        appBar: AppBar(
          title:
              Text(isEdit ? l10n.editTaskTitleEdit : l10n.editTaskTitleCreate),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [_DetailsField(), _CompletionField()],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (state.status != EditTaskStatus.loading &&
                state.status != EditTaskStatus.success) {
              if (state.details.isNotEmpty) {
                context.read<EditTaskBloc>().add(const EditTaskDoneTapped());
              } else {
                _showMissingDetailsAlert(context);
              }
            }
          },
          tooltip: (isEdit
              ? l10n.editTaskFabTitleEdit
              : l10n.editTaskFabTitleCreate),
          child: const Icon(Icons.done),
        ));
  }
}

void _showMissingDetailsAlert(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(l10n.alertDetailsMissingTitle),
            content: Text(l10n.alertDetailsMissingDescription),
          ));
}

class _DetailsField extends StatelessWidget {
  const _DetailsField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<EditTaskBloc>().state;

    return Container(
        margin: const EdgeInsets.all(16),
        child: TextFormField(
          decoration: InputDecoration(labelText: l10n.editTaskDetailsLabel),
          key: const Key('editTaskView_details_textFormField'),
          initialValue: state.details,
          onChanged: (value) {
            context.read<EditTaskBloc>().add(EditTaskDetailsChanged(value));
          },
        ));
  }
}

class _CompletionField extends StatelessWidget {
  const _CompletionField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<EditTaskBloc>().state;

    return CheckboxListTile(
      title: Text(l10n.editTaskCompletedLabel),
      value: state.isCompleted,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (value) {
        context
            .read<EditTaskBloc>()
            .add(EditTaskCompletedChanged(value ?? false));
      },
    );
  }
}
