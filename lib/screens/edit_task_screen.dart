// edit_task_screen.dart
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final Function onTaskUpdated;

  EditTaskScreen({required this.task, required this.onTaskUpdated});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    title = widget.task.title;
    description = widget.task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onChanged: (value) {
                  title = value;
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onChanged: (value) {
                  description = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Update title and description
                      widget.task.title = title;
                      widget.task.description = description;
                      
                      // Debugging logs
                      print('Updating task: ${widget.task.toJson()}');

                      await TaskService().updateTask(widget.task);
                      widget.onTaskUpdated(); // Notify parent to refresh tasks
                      Navigator.pop(context);
                    } catch (e) {
                      print('Error updating task: $e');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update task')));
                    }
                  }
                },
                child: Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
