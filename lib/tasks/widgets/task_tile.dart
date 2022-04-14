import 'package:flutter/material.dart';
import 'package:tasks_repository/tasks_repository.dart';

class TaskTile extends StatelessWidget {
  const TaskTile(
      {Key? key,
      required this.task,
      this.onTap,
      this.onDismiss,
      this.onTapCompleted})
      : super(key: key);

  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final ValueChanged<bool>? onTapCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: Key('taskTile_dismissible_${task.id}'),
      child: ListTile(
        onTap: onTap,
        title: Text(
          task.details,
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: task.isCompleted
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : const TextStyle(decoration: TextDecoration.none),
        ),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            if (onTapCompleted != null) {
              onTapCompleted!(value!);
            }
          },
        ),
      ),
      background: Container(
        padding: const EdgeInsets.all(8),
        color: theme.colorScheme.errorContainer,
        child: Icon(Icons.delete_outlined, color: theme.cardColor),
        alignment: Alignment.centerRight,
      ),
      onDismissed: (value) {
        if (onDismiss != null) {
          onDismiss!();
        }
      },
    );
  }
}
