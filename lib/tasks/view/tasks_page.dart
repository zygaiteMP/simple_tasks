import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tasks/edit_task/view/edit_task_page.dart';
import 'package:tasks/tasks/bloc/tasks_bloc.dart';
import 'package:tasks/tasks/widgets/task_tile.dart';
import 'package:tasks_repository/tasks_repository.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TasksBloc(repo: context.read<TasksRepository>())
          ..add(const TasksSubscriptionRequested()),
        child: const TasksView());
  }
}

class TasksView extends StatelessWidget {
  const TasksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tasksTitle),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TasksBloc, TasksState>(
            listenWhen: (prev, curr) => prev.status != curr.status,
            listener: (context, state) {
              if (state.status == TasksStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(
                      l10n.tasksLoadErrorTitle,
                    ),
                  ));
              }
            },
          )
        ],
        child: BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
          if (state.tasks.isEmpty) {
            if (state.status == TasksStatus.loading) {
              return const Center(child: CupertinoActivityIndicator());
            } else {
              return Center(
                child: Text(l10n.tasksEmptyTitle),
              );
            }
          } else {
            return Scrollbar(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return TaskTile(
                        task: state.tasks[index],
                        onTap: () {
                          Navigator.of(context).push(
                            EditTaskPage.route(task: state.tasks[index]),
                          );
                        },
                        onDismiss: () {
                          context
                              .read<TasksBloc>()
                              .add(TasksTappedTaskRemove(state.tasks[index]));
                        },
                        onTapCompleted: (isCompleted) {
                          context.read<TasksBloc>().add(TasksToggledCompletion(
                              state.tasks[index], isCompleted));
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: state.tasks.length));
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            EditTaskPage.route(task: null),
          );
        },
        tooltip: l10n.tasksFabTitleAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
