import 'package:flutter/material.dart';
import 'package:flutter_task/models/task.dart';
import 'package:flutter_task/providers/task_provider.dart';
import 'package:provider/provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String? _description;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _title = widget.task.title;
    _description = widget.task.description;
    _dueDate = widget.task.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Edit Task"))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: _title,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Title required";
                      final regex = RegExp(r'^[a-zA-Z\s]+$');
                      if (!regex.hasMatch(value))
                        return "Title can only contain letters";
                      return null;
                    },
                    onSaved: (value) => _title = value!,
                  ),

                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _description,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v != null && v.isNotEmpty) {
                        final regex = RegExp(r'^[a-zA-Z0-9\s]+$');
                        if (!regex.hasMatch(v))
                          return "Only letters and numbers allowed";
                      }
                      return null;
                    },
                    onSaved: (value) => _description = value,
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        "Due Date: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _dueDate != null
                            ? "${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}"
                            : "No date chosen",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _dueDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dueDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  const Divider(height: 30),
                  Row(
                    children: [
                      Checkbox(
                        value: widget.task.isCompleted,
                        onChanged: (val) {
                          provider.updateTask(
                            Task(
                              id: widget.task.id,
                              title: widget.task.title,
                              description: widget.task.description,
                              isCompleted: val!,
                              dueDate: widget.task.dueDate,
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                      const Text("Mark as complete"),
                    ],
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blueAccent, Colors.purpleAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final updatedTask = Task(
                              id: widget.task.id,
                              title: _title,
                              description: _description,
                              isCompleted: widget.task.isCompleted,
                              dueDate: _dueDate,
                            );

                            provider.updateTask(updatedTask);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        provider.deleteTask(widget.task.id);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Delete Task",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
