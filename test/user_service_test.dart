import 'package:flutter_test/flutter_test.dart';
import 'package:formusers/data/models/user.dart';
import 'package:formusers/features/user/services/user_service.dart';
import 'package:formusers/data/repositories/user_repository.dart';

class MockUserRepository implements UserRepository {
  final List<User> _users = [];
  bool _shouldThrowError = false;

  void setShouldThrowError(bool shouldThrow) {
    _shouldThrowError = shouldThrow;
  }

  @override
  Future<List<User>> getAllUsers() async {
    if (_shouldThrowError) throw Exception('Error de red');
    await Future.delayed(const Duration(milliseconds: 10));
    return List.unmodifiable(_users);
  }

  @override
  Future<User?> getUserById(String id) async {
    if (_shouldThrowError) throw Exception('Error de red');
    await Future.delayed(const Duration(milliseconds: 10));
    try {
      final index = int.parse(id);
      if (index >= 0 && index < _users.length) {
        return _users[index];
      }
    } catch (e) {
      // ID inválido
    }
    return null;
  }

  @override
  Future<void> saveUser(User user) async {
    if (_shouldThrowError) throw Exception('Error de red');
    await Future.delayed(const Duration(milliseconds: 10));
    _users.add(user);
  }

  @override
  Future<void> updateUser(User user) async {
    if (_shouldThrowError) throw Exception('Error de red');
    await Future.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> deleteUser(String id) async {
    if (_shouldThrowError) throw Exception('Error de red');
    await Future.delayed(const Duration(milliseconds: 10));
    try {
      final index = int.parse(id);
      if (index >= 0 && index < _users.length) {
        _users.removeAt(index);
      }
    } catch (e) {
      throw Exception('ID de usuario inválido: $id');
    }
  }

  @override
  Future<void> addAddressToUser(String userId, Address address) async {
    if (_shouldThrowError) throw Exception('Error de red');
    await Future.delayed(const Duration(milliseconds: 10));
    final user = await getUserById(userId);
    if (user != null) {
      final updatedUser = user.copyWith(
        addresses: [...user.addresses, address],
      );
      await updateUser(updatedUser);
    } else {
      throw Exception('Usuario no encontrado: $userId');
    }
  }

  @override
  Future<void> updateUserAddress(
      String userId, int addressIndex, Address address) async {
    if (_shouldThrowError) throw Exception('Error de red');
    await Future.delayed(const Duration(milliseconds: 10));
    final user = await getUserById(userId);
    if (user != null &&
        addressIndex >= 0 &&
        addressIndex < user.addresses.length) {
      final updatedAddresses = List<Address>.from(user.addresses);
      updatedAddresses[addressIndex] = address;
      final updatedUser = user.copyWith(addresses: updatedAddresses);
      await updateUser(updatedUser);
    } else {
      throw Exception('Usuario o índice de dirección inválido');
    }
  }

  @override
  Future<void> removeUserAddress(String userId, int addressIndex) async {
    if (_shouldThrowError) throw Exception('Error de red');
    await Future.delayed(const Duration(milliseconds: 10));
    final user = await getUserById(userId);
    if (user != null &&
        addressIndex >= 0 &&
        addressIndex < user.addresses.length) {
      final updatedAddresses = List<Address>.from(user.addresses);
      updatedAddresses.removeAt(addressIndex);
      final updatedUser = user.copyWith(addresses: updatedAddresses);
      await updateUser(updatedUser);
    } else {
      throw Exception('Usuario o índice de dirección inválido');
    }
  }
}

void main() {
  group('UserService', () {
    late UserService userService;
    late MockUserRepository mockRepository;

    setUp(() {
      mockRepository = MockUserRepository();
      userService = UserService(mockRepository);
    });

    group('createUser', () {
      test('debe crear un usuario correctamente', () async {
        final user = await userService.createUser(
          firstName: 'Juan',
          lastName: 'Pérez',
          birthDate: DateTime(1990, 1, 1),
        );

        expect(user.firstName, 'Juan');
        expect(user.lastName, 'Pérez');
        expect(user.birthDate, DateTime(1990, 1, 1));
        expect(user.addresses, isEmpty);
      });

      test('debe lanzar excepción si el nombre está vacío', () async {
        expect(
          () => userService.createUser(
            firstName: '',
            lastName: 'Pérez',
            birthDate: DateTime(1990, 1, 1),
          ),
          throwsA(isA<UserServiceException>()),
        );
      });

      test('debe lanzar excepción si el apellido está vacío', () async {
        expect(
          () => userService.createUser(
            firstName: 'Juan',
            lastName: '',
            birthDate: DateTime(1990, 1, 1),
          ),
          throwsA(isA<UserServiceException>()),
        );
      });

      test('debe lanzar excepción si la fecha es futura', () async {
        expect(
          () => userService.createUser(
            firstName: 'Juan',
            lastName: 'Pérez',
            birthDate: DateTime(2030, 1, 1),
          ),
          throwsA(isA<UserServiceException>()),
        );
      });

      test('debe manejar errores del repositorio', () async {
        mockRepository.setShouldThrowError(true);

        expect(
          () => userService.createUser(
            firstName: 'Juan',
            lastName: 'Pérez',
            birthDate: DateTime(1990, 1, 1),
          ),
          throwsA(isA<UserServiceException>()),
        );
      });
    });

    group('addAddressToUser', () {
      test('debe agregar una dirección correctamente', () async {
        final user = User(
          firstName: 'Juan',
          lastName: 'Pérez',
          birthDate: DateTime(1990, 1, 1),
        );

        final address = Address(
          street: 'Calle 123',
          city: 'Bogotá',
          department: 'Cundinamarca',
          municipality: 'Bogotá',
          country: 'Colombia',
        );

        final updatedUser = await userService.addAddressToUser(user, address);

        expect(updatedUser.addresses.length, 1);
        expect(updatedUser.addresses.first.street, 'Calle 123');
      });

      test('debe lanzar excepción si la calle está vacía', () async {
        final user = User(
          firstName: 'Juan',
          lastName: 'Pérez',
          birthDate: DateTime(1990, 1, 1),
        );

        final address = Address(
          street: '',
          city: 'Bogotá',
          department: 'Cundinamarca',
          municipality: 'Bogotá',
          country: 'Colombia',
        );

        expect(
          () => userService.addAddressToUser(user, address),
          throwsA(isA<UserServiceException>()),
        );
      });
    });

    group('updateUser', () {
      test('debe actualizar un usuario correctamente', () async {
        final user = User(
          firstName: 'Juan',
          lastName: 'Pérez',
          birthDate: DateTime(1990, 1, 1),
        );

        final updatedUser = await userService.updateUser(
          currentUser: user,
          firstName: 'Carlos',
          lastName: 'González',
        );

        expect(updatedUser.firstName, 'Carlos');
        expect(updatedUser.lastName, 'González');
        expect(updatedUser.birthDate, DateTime(1990, 1, 1));
      });
    });

    group('removeUserAddress', () {
      test('debe eliminar una dirección correctamente', () async {
        final address1 = Address(
          street: 'Calle 1',
          city: 'Ciudad 1',
          department: 'Depto 1',
          municipality: 'Mun 1',
          country: 'País 1',
        );

        final address2 = Address(
          street: 'Calle 2',
          city: 'Ciudad 2',
          department: 'Depto 2',
          municipality: 'Mun 2',
          country: 'País 2',
        );

        final user = User(
          firstName: 'Juan',
          lastName: 'Pérez',
          birthDate: DateTime(1990, 1, 1),
          addresses: [address1, address2],
        );

        final updatedUser = await userService.removeUserAddress(user, 0);

        expect(updatedUser.addresses.length, 1);
        expect(updatedUser.addresses.first.street, 'Calle 2');
      });

      test('debe lanzar excepción si el índice es inválido', () async {
        final user = User(
          firstName: 'Juan',
          lastName: 'Pérez',
          birthDate: DateTime(1990, 1, 1),
        );

        final address = Address(
          street: 'Calle 1',
          city: 'Ciudad 1',
          department: 'Depto 1',
          municipality: 'Mun 1',
          country: 'País 1',
        );

        expect(
          () => userService.removeUserAddress(user, 0),
          throwsA(isA<UserServiceException>()),
        );
      });
    });
  });
}
