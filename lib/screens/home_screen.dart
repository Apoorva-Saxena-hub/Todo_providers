import 'package:flutter/material.dart';
import 'package:flutter_task/screens/add_task_screen.dart';
import 'package:flutter_task/screens/task_detail_screen.dart';
import 'package:flutter_task/widgets/theme_provider.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final theme = Theme.of(context); // <-- use theme

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "To-Do List",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => context.read<ThemeProvider>().toggleTheme(),
              child: Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AnimatedAlign(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: context.watch<ThemeProvider>().isDark
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Icon(
                    context.watch<ThemeProvider>().isDark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: provider.pendingTasks.isEmpty && provider.completedTasks.isEmpty
          ? Center(
              child: Text(
                "No tasks yet",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onBackground, // adapts with theme
                ),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    if (provider.pendingTasks.isNotEmpty)
                      buildTaskSection(
                        context,
                        "Pending Tasks",
                        provider.pendingTasks,
                        Theme.of(context).colorScheme.surfaceVariant,
                        Icons.access_time,
                      ),
                    SizedBox(height: 30),
                    if (provider.completedTasks.isNotEmpty)
                      buildTaskSection(
                        context,
                        "Completed Tasks",
                        provider.completedTasks,
                        Theme.of(context).colorScheme.secondaryContainer,
                        Icons.check_circle,
                      ),
                  ],
                ),
              ),
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddTaskScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildTaskSection(
    BuildContext context,
    String title,
    List tasks,
    Color bgColor,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4)),
        ],
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer, // auto switch
          ),
        ),
        children: tasks
            .map<Widget>(
              (task) => ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (task.dueDate != null)
                      Text(
                        "${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}",
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskDetailScreen(task: task),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
