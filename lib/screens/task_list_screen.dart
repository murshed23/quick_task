import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/task.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart'; // Import the EditTaskScreen

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    futureTasks = TaskService().getTasks();
  }

  Future<void> refreshTasks() async {
    setState(() {
      futureTasks = TaskService().getTasks();
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> confirmDelete(Task task) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
    if (shouldDelete == true) {
      await TaskService().deleteTask(task.id);
      refreshTasks();
      showSnackBar('Task deleted successfully!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen(onTaskAdded: refreshTasks)),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final task = snapshot.data![index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (bool? value) async {
                      setState(() {
                        task.isCompleted = value!;
                      });
                      await TaskService().updateTask(task);
                      showSnackBar('Task updated successfully!');
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTaskScreen(
                          task: task,
                          onTaskUpdated: refreshTasks,
                        ),
                      ),
                    );
                  },
                  onLongPress: () => confirmDelete(task), // Call the confirmDelete method
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen(onTaskAdded: refreshTasks)),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}
