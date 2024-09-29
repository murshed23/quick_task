import 'package:flutter/material.dart';
import 'task_list_screen.dart';
import 'add_task_screen.dart'; // Import the AddTaskScreen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Management')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskListScreen()),
                );
              },
              child: Text('View Tasks'),
            ),
            SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskScreen(onTaskAdded: () {})), // Placeholder for onTaskAdded
                );
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
