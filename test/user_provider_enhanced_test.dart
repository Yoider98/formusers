import 'package:flutter_test/flutter_test.dart';
import 'package:formusers/data/models/user.dart';
import 'package:formusers/features/user/provider/user_provider.dart';
import 'package:formusers/features/user/services/user_service.dart';

class MockUserService implements UserService {
  final List<User> _users = [];
  bool _shouldThrowError = false;
  String? _lastError;

  void setShouldThrowError(bool shouldThrow, {String? error}) {
    _shouldThrowError = shouldThrow;
    _lastError = error;
  }

  @override
  Future<List<User>> getAllUsers() async {
    if (_shouldThrowError) {
      throw UserServiceException(_lastError ?? 'Error de red');
    }
    await Future.delayed(const Duration(milliseconds: 10));
    return List.unmodifiable(_users);
  }

  @override
  Future<User> createUser({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
  }) async {
    if (_shouldThrowError) {
      throw UserServiceException(_lastError ?? 'Error al crear usuario');
    }
    await Future.delayed(const Duration(milliseconds: 10));
    final user = User(
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
    );
    _users.add(user);
    return user;
  }

  @override
  Future<User> updateUser({
    required User currentUser,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
  }) async {
    if (_shouldThrowError) {
      throw UserServiceException(_lastError ?? 'Error al actualizar usuario');
    }
    await Future.delayed(const Duration(milliseconds: 10));
    return currentUser.copyWith(
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
    );
  }

  @override
  Future<User> addAddressToUser(User user, Address address) async {
    if (_shouldThrowError) {
      throw UserServiceException(_lastError ?? 'Error al agregar dirección');
    }
    await Future.delayed(const Duration(milliseconds: 10));
    return user.copyWith(
      addresses: [...user.addresses, address],
    );
  }

  @override
  Future<User> updateUserAddress(
      User user, int addressIndex, Address address) async {
    if (_shouldThrowError) {
      throw UserServiceException(_lastError ?? 'Error al actualizar dirección');
    }
    await Future.delayed(const Duration(milliseconds: 10));
    final updatedAddresses = List<Address>.from(user.addresses);
    updatedAddresses[addressIndex] = address;
    return user.copyWith(addresses: updatedAddresses);
  }

  @override
  Future<User> removeUserAddress(User user, int addressIndex) async {
    if (_shouldThrowError) {
      throw UserServiceException(_lastError ?? 'Error al eliminar dirección');
    }
    await Future.delayed(const Duration(milliseconds: 10));
    final updatedAddresses = List<Address>.from(user.addresses);
    updatedAddresses.removeAt(addressIndex);
    return user.copyWith(addresses: updatedAddresses);
  }
}

void main() {
  group('UserProvider Enhanced Tests', () {
    late UserProvider userProvider;
    late MockUserService mockService;

    setUp(() {
      mockService = MockUserService();
      userProvider = UserProvider(mockService);
    });

    group('Estados de carga', () {
      test('debe mostrar estado de carga durante createUser', () async {
        expect(userProvider.isLoading, false);

        final future =
            userProvider.createUser('Juan', 'Pérez', DateTime(1990, 1, 1));
        expect(userProvider.isLoading, true);
        await future;
        expect(userProvider.isLoading, false);
      });

      test('debe mostrar estado de carga durante loadUsers', () async {
        expect(userProvider.isLoading, false);
        final future = userProvider.loadUsers();
        expect(userProvider.isLoading, true);
        await future;
        expect(userProvider.isLoading, false);
      });
    });

    group('Manejo de errores', () {
      test('debe manejar errores en createUser', () async {
        mockService.setShouldThrowError(true, error: 'Error de conexión');

        await userProvider.createUser('Juan', 'Pérez', DateTime(1990, 1, 1));

        expect(userProvider.hasError, true);
        expect(userProvider.error, contains('Error de conexión'));
      });

      test('debe limpiar errores correctamente', () async {
        mockService.setShouldThrowError(true);
        await userProvider.createUser('Juan', 'Pérez', DateTime(1990, 1, 1));

        expect(userProvider.hasError, true);

        userProvider.clearError();
        expect(userProvider.hasError, false);
        expect(userProvider.error, null);
      });

      test('debe manejar errores en addAddress', () async {
        await userProvider.createUser('Juan', 'Pérez', DateTime(1990, 1, 1));

        mockService.setShouldThrowError(true,
            error: 'Error al agregar dirección');

        final address = Address(
          street: 'Calle 123',
          city: 'Bogotá',
          department: 'Cundinamarca',
          municipality: 'Bogotá',
          country: 'Colombia',
        );

        await userProvider.addAddress(address);

        expect(userProvider.hasError, true);
        expect(userProvider.error, contains('Error al agregar dirección'));
      });
    });

    group('Operaciones de usuario', () {
      test('debe crear usuario correctamente', () async {
        await userProvider.createUser('Juan', 'Pérez', DateTime(1990, 1, 1));

        expect(userProvider.users.length, 1);
        expect(userProvider.currentUser?.firstName, 'Juan');
        expect(userProvider.currentUser?.lastName, 'Pérez');
        expect(userProvider.hasError, false);
      });

      test('debe seleccionar usuario correctamente', () {
        final user = User(
          firstName: 'Ana',
          lastName: 'López',
          birthDate: DateTime(1985, 5, 15),
        );

        userProvider.selectUser(user);

        expect(userProvider.currentUser, user);
        expect(userProvider.hasError, false);
      });

      test('debe actualizar datos del usuario', () async {
        await userProvider.createUser('Juan', 'Pérez', DateTime(1990, 1, 1));

        await userProvider.editUserData(
          firstName: 'Carlos',
          lastName: 'González',
        );

        expect(userProvider.currentUser?.firstName, 'Carlos');
        expect(userProvider.currentUser?.lastName, 'González');
        expect(userProvider.hasError, false);
      });
    });

    group('Operaciones de direcciones', () {
      test('debe agregar dirección correctamente', () async {
        await userProvider.createUser('Juan', 'Pérez', DateTime(1990, 1, 1));

        final address = Address(
          street: 'Calle 123',
          city: 'Bogotá',
          department: 'Cundinamarca',
          municipality: 'Bogotá',
          country: 'Colombia',
        );

        await userProvider.addAddress(address);

        expect(userProvider.currentUser?.addresses.length, 1);
        expect(userProvider.currentUser?.addresses.first.street, 'Calle 123');
        expect(userProvider.hasError, false);
      });

      test('debe actualizar dirección correctamente', () async {
        await userProvider.createUser('Juan', 'Pérez', DateTime(1990, 1, 1));

        final address1 = Address(
          street: 'Calle 1',
          city: 'Ciudad 1',
          department: 'Depto 1',
          municipality: 'Mun 1',
          country: 'País 1',
        );

        await userProvider.addAddress(address1);

        final address2 = Address(
          street: 'Calle 2',
          city: 'Ciudad 2',
          department: 'Depto 2',
          municipality: 'Mun 2',
          country: 'País 2',
        );

        await userProvider.editAddress(0, address2);

        expect(userProvider.currentUser?.addresses.length, 1);
        expect(userProvider.currentUser?.addresses.first.street, 'Calle 2');
        expect(userProvider.hasError, false);
      });

      test('debe eliminar dirección correctamente', () async {
        await userProvider.createUser('Juan', 'Pérez', DateTime(1990, 1, 1));

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

        await userProvider.addAddress(address1);
        await userProvider.addAddress(address2);

        expect(userProvider.currentUser?.addresses.length, 2);

        await userProvider.removeAddress(0);

        expect(userProvider.currentUser?.addresses.length, 1);
        expect(userProvider.currentUser?.addresses.first.street, 'Calle 2');
        expect(userProvider.hasError, false);
      });

      test('debe manejar error al agregar dirección sin usuario seleccionado',
          () async {
        final address = Address(
          street: 'Calle 123',
          city: 'Bogotá',
          department: 'Cundinamarca',
          municipality: 'Bogotá',
          country: 'Colombia',
        );

        await userProvider.addAddress(address);

        expect(userProvider.hasError, true);
        expect(userProvider.error, 'No hay usuario seleccionado');
      });
    });

    group('Inmutabilidad', () {
      test('users debe retornar lista inmutable', () async {
        await userProvider.createUser('Juan', 'Pérez', DateTime(1990, 1, 1));

        final users = userProvider.users;

        expect(
            () => users.add(User(
                  firstName: 'Test',
                  lastName: 'User',
                  birthDate: DateTime(1990, 1, 1),
                )),
            throwsA(isA<UnsupportedError>()));
      });
    });
  });
}
