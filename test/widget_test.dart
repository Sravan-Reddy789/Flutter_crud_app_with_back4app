import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/services/auth_service.dart';

void main() {
  testWidgets('Login screen is shown when Back4App keys are not set', (
    tester,
  ) async {
    await tester.pumpWidget(TaskManagerApp(authService: AuthService()));

    expect(find.text('Task Manager'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Create an account'), findsOneWidget);
  });
}
