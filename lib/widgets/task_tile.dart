import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  TaskTile({required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (_) => onTap?.call(),
      ),
      onTap: onTap,
    );
  }
}
