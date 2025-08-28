import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class TaskService {
  static const String _taskKey = "tasks";

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_taskKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Task.fromMap(e)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(tasks.map((e) => e.toMap()).toList());
    await prefs.setString(_taskKey, jsonString);
  }
}
