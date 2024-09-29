import 'package:parse_server_sdk/parse_server_sdk.dart';
import '../models/task.dart';

class TaskService {
  Future<List<Task>> getTasks() async {
    final ParseResponse response = await ParseObject('Task').getAll();
    if (response.success && response.results != null) {
      // Adjusting the mapping here to convert ParseObject to Task correctly
      return response.results!.map((e) {
        // Cast to ParseObject and call toJson to get a Map
        final parseObject = e as ParseObject;
        return Task.fromJson(parseObject.toJson());
      }).toList();
    } else {
      throw Exception('Failed to load tasks: ${response.error?.message}');
    }
  }

  Future<void> addTask(Task task) async {
    final taskObject = ParseObject('Task')..set('title', task.title)..set('description', task.description)..set('isCompleted', task.isCompleted);
    final response = await taskObject.save();
    if (!response.success) {
      throw Exception('Failed to save task: ${response.error?.message}');
    }
  }

  Future<void> updateTask(Task task) async {
    final taskObject = ParseObject('Task')..objectId = task.id..set('isCompleted', task.isCompleted);
    final response = await taskObject.save();
    if (!response.success) {
      throw Exception('Failed to update task: ${response.error?.message}');
    }
  }

  Future<void> deleteTask(String id) async {
    final taskObject = ParseObject('Task')..objectId = id;
    final response = await taskObject.delete();
    if (!response.success) {
      throw Exception('Failed to delete task: ${response.error?.message}');
    }
  }
}
