import 'package:material_ui/material_ui.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'parse_bootstrap.dart';
import 'parse_config.dart';
import 'screens/login_screen.dart';
import 'screens/task_list_screen.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeParse();
  runApp(TaskManagerApp(authService: AuthService()));
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: AuthGate(authService: authService),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    if (!Back4AppKeys.isConfigured) {
      return LoginScreen(authService: authService);
    }

    return FutureBuilder<ParseUser?>(
      future: authService.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data != null) {
          return TaskListScreen(authService: authService);
        }
        return LoginScreen(authService: authService);
      },
    );
  }
}
