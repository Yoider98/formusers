import 'package:flutter_test/flutter_test.dart';
import 'package:formusers/data/models/user.dart';
import 'package:formusers/features/user/provider/user_provider.dart';

void main() {
  group('UserProvider - editUserData', () {
    test('debe editar nombre y apellido del usuario actual', () {
      final provider = UserProvider();

      provider.createUser('Yoider', 'Yancy', DateTime(2000, 1, 1));
      expect(provider.currentUser!.firstName, 'Yoider');
      expect(provider.currentUser!.lastName, 'Yancy');

      provider.editUserData(firstName: 'matias', lastName: 'mier');

      expect(provider.currentUser!.firstName, 'matias');
      expect(provider.currentUser!.lastName, 'mier');
    });

    test('debe editar la fecha de nacimiento', () {
      final provider = UserProvider();

      provider.createUser('Yoider', 'Yancy', DateTime(2000, 1, 1));
      expect(provider.currentUser!.birthDate, DateTime(2000, 1, 1));

      provider.editUserData(birthDate: DateTime(1999, 12, 31));

      expect(provider.currentUser!.birthDate, DateTime(1999, 12, 31));
    });
  });
}
