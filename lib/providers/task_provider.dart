import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];

  List<Task> get pendingTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList();

  Future<void> loadTasks() async {
    _tasks = await _taskService.loadTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _taskService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> updateTask(Task updated) async {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index != -1) {
      _tasks[index] = updated;
      await _taskService.saveTasks(_tasks);
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _taskService.saveTasks(_tasks);
    notifyListeners();
  }
}
