import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../parse_config.dart';
import 'auth_service.dart';

class TaskService {
  TaskService(this._authService);
  final AuthService _authService;

  Future<ParseUser> _requireUser() async {
    final user = await _authService.currentUser();
    if (user == null) {
      throw AuthException('Please log in again.');
    }
    return user;
  }

  Future<List<ParseObject>> fetchTasks() async {
    final user = await _requireUser();
    final query = QueryBuilder<ParseObject>(ParseObject(Back4AppKeys.taskClassName))
      ..whereEqualTo('user', user.toPointer())
      ..orderByDescending('createdAt');
    final response = await query.query();
    if (!response.success) {
      throw AuthException(response.error?.message ?? 'Could not load tasks.');
    }
    return (response.results ?? []).cast<ParseObject>();
  }

  Future<ParseObject> createTask({
    required String title,
    required String description,
  }) async {
    final user = await _requireUser();
    final task = ParseObject(Back4AppKeys.taskClassName)
      ..set('title', title)
      ..set('description', description)
      ..set('user', user.toPointer())
      ..setACL(ParseACL(owner: user));
    final response = await task.save();
    if (!response.success) {
      throw AuthException(response.error?.message ?? 'Could not create task.');
    }
    return task;
  }

  Future<void> updateTask({
    required ParseObject task,
    required String title,
    required String description,
  }) async {
    task
      ..set('title', title)
      ..set('description', description);
    final response = await task.save();
    if (!response.success) {
      throw AuthException(response.error?.message ?? 'Could not update task.');
    }
  }

  Future<void> deleteTask(ParseObject task) async {
    final response = await task.delete();
    if (!response.success) {
      throw AuthException(response.error?.message ?? 'Could not delete task.');
    }
  }
}
