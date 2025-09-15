import 'package:flutter_test/flutter_test.dart';
import 'package:formusers/data/models/user.dart';
import 'package:formusers/features/user/provider/user_provider.dart';
import 'package:formusers/features/user/services/user_service.dart';
import 'package:formusers/data/repositories/user_repository.dart';

void main() {
  group('UserProvider - editUserData', () {
    late UserProvider provider;
    late UserService userService;
    late UserRepository userRepository;

    setUp(() {
      userRepository = UserRepositoryImpl();
      userService = UserService(userRepository);
      provider = UserProvider(userService);
    });

    test('debe editar nombre y apellido del usuario actual', () async {
      await provider.createUser('Yoider', 'Yancy', DateTime(2000, 1, 1));
      expect(provider.currentUser!.firstName, 'Yoider');
      expect(provider.currentUser!.lastName, 'Yancy');

      await provider.editUserData(firstName: 'matias', lastName: 'mier');

      expect(provider.currentUser!.firstName, 'matias');
      expect(provider.currentUser!.lastName, 'mier');
    });

    test('debe editar la fecha de nacimiento', () async {
      await provider.createUser('Yoider', 'Yancy', DateTime(2000, 1, 1));
      expect(provider.currentUser!.birthDate, DateTime(2000, 1, 1));

      await provider.editUserData(birthDate: DateTime(1999, 12, 31));

      expect(provider.currentUser!.birthDate, DateTime(1999, 12, 31));
    });
  });
}
