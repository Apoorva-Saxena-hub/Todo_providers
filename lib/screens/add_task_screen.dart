import 'package:flutter/material.dart';
import 'package:flutter_task/models/task.dart';
import 'package:flutter_task/providers/task_provider.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String? _description;
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      "Task Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                      label: RichText(
                        text: TextSpan(
                          text: "Title",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Title is required" : null,
                    onSaved: (v) => _title = v!,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description (optional)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSaved: (v) => _description = v,
                  ),
                  SizedBox(height: 16),
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
                      Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.teal,
                        ),
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
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

                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[200],
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.save, color: Colors.black),
                    label: Text(
                      "Save Task",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final provider = Provider.of<TaskProvider>(
                          context,
                          listen: false,
                        );
                        provider.addTask(
                          Task(
                            id: DateTime.now().millisecondsSinceEpoch,
                            title: _title,
                            description: _description,
                            dueDate: _dueDate,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
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
