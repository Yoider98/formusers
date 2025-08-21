import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formusers/data/models/user.dart';
import 'package:provider/provider.dart';
import 'package:formusers/features/user/provider/user_provider.dart';
import 'package:formusers/features/user/view/user_summary_screen.dart';

void main() {
  group('UserSummaryScreen Tests', () {
    testWidgets('UserSummaryScreen muestra datos del usuario',
        (WidgetTester tester) async {
      final userProvider = UserProvider();

      // Crear un usuario
      final user = User(
        firstName: "Laura",
        lastName: "Martínez",
        birthDate: DateTime(1990, 5, 20),
      );

      // Seleccionar el usuario como actual
      userProvider.selectUser(user);

      // Construir el widget bajo prueba
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<UserProvider>.value(
            value: userProvider,
            child: const UserSummaryScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que el texto se muestre en pantalla
      expect(find.text("Nombre: Laura"), findsOneWidget);
      expect(find.text("Apellido: Martínez"), findsOneWidget);
    });
  });
}
