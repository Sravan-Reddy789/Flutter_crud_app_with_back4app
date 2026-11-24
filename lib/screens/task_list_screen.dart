import 'package:material_ui/material_ui.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../services/auth_service.dart';
import '../services/task_service.dart';
import 'login_screen.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, required this.authService});

  final AuthService authService;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late final TaskService _taskService;
  late Future<List<ParseObject>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _taskService = TaskService(widget.authService);
    _tasksFuture = _taskService.fetchTasks();
  }

  void _reload() {
    setState(() {
      _tasksFuture = _taskService.fetchTasks();
    });
  }

  Future<void> _openForm({ParseObject? task}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => TaskFormScreen(taskService: _taskService, task: task),
      ),
    );
    if (saved == true) {
      _reload();
    }
  }

  Future<void> _delete(ParseObject task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text(task.get<String>('title') ?? 'This task'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    try {
      await _taskService.deleteTask(task);
      _reload();
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  Future<void> _logout() async {
    try {
      await widget.authService.logout();
    } on AuthException catch (error) {
      _showMessage(error.message);
      return;
    }
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => LoginScreen(authService: widget.authService),
      ),
      (_) => false,
    );
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My tasks'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('New task'),
      ),
      body: FutureBuilder<List<ParseObject>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _MessageState(
              icon: Icons.error_outline,
              message: snapshot.error.toString(),
              actionLabel: 'Retry',
              onAction: _reload,
            );
          }
          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) {
            return _MessageState(
              icon: Icons.inbox_outlined,
              message: 'No tasks yet. Create your first task.',
              actionLabel: 'Refresh',
              onAction: _reload,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              itemCount: tasks.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = tasks[index];
                final title = task.get<String>('title') ?? 'Untitled';
                final description = task.get<String>('description') ?? '';
                return Card(
                  child: ListTile(
                    title: Text(title),
                    subtitle: Text(
                      description,
                      maxLines: 2,
                      overflow: .ellipsis,
                    ),
                    onTap: () => _openForm(task: task),
                    trailing: IconButton(
                      tooltip: 'Delete',
                      onPressed: () => _delete(task),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: .center),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
