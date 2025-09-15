import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formusers/data/models/user.dart';
import 'package:provider/provider.dart';
import 'package:formusers/features/user/provider/user_provider.dart';
import 'package:formusers/features/user/services/user_service.dart';
import 'package:formusers/data/repositories/user_repository.dart';
import 'package:formusers/features/user/view/user_summary_screen.dart';

void main() {
  group('UserSummaryScreen Tests', () {
    late UserProvider userProvider;
    late UserService userService;
    late UserRepository userRepository;

    setUp(() {
      userRepository = UserRepositoryImpl();
      userService = UserService(userRepository);
      userProvider = UserProvider(userService);
    });

    testWidgets('UserSummaryScreen muestra datos del usuario',
        (WidgetTester tester) async {
      // Crear un usuario
      final user = User(
        firstName: "Laura",
        lastName: "Martínez",
        birthDate: DateTime(1990, 5, 20),
      );
      userProvider.selectUser(user);
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<UserProvider>.value(
            value: userProvider,
            child: const UserSummaryScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text("Nombre: Laura"), findsOneWidget);
      expect(find.text("Apellido: Martínez"), findsOneWidget);
    });
  });
}
