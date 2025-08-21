import 'package:flutter_test/flutter_test.dart';
import 'package:formusers/data/models/user.dart';

void main() {
  group('Address model', () {
    test('Debe crear un Address correctamente', () {
      final address = Address(
        street: 'Calle 123',
        city: 'Santa Marta',
        country: 'Colombia',
      );

      expect(address.street, 'Calle 123');
      expect(address.city, 'Santa Marta');
      expect(address.country, 'Colombia');
    });
  });

  group('User model', () {
    test('Debe crear un User correctamente', () {
      final user = User(
        firstName: 'Yoider',
        lastName: 'Yancy',
        birthDate: DateTime(2000, 5, 10),
      );

      expect(user.firstName, 'Yoider');
      expect(user.lastName, 'Yancy');
      expect(user.birthDate, DateTime(2000, 5, 10));
      expect(user.addresses, isEmpty);
    });

    test('Debe crear un User con direcciones', () {
      final address = Address(
        street: 'Calle 45',
        city: 'Bogotá',
        country: 'Colombia',
      );

      final user = User(
        firstName: 'Ana',
        lastName: 'López',
        birthDate: DateTime(1995, 3, 20),
        addresses: [address],
      );

      expect(user.addresses.length, 1);
      expect(user.addresses.first.city, 'Bogotá');
    });

    test('copyWith debe actualizar campos correctamente', () {
      final user = User(
        firstName: 'Carlos',
        lastName: 'Martínez',
        birthDate: DateTime(1990, 1, 1),
      );

      final updatedUser = user.copyWith(
        firstName: 'Juan',
        addresses: [
          Address(
              street: 'Av. Siempre Viva', city: 'Springfield', country: 'USA')
        ],
      );

      expect(updatedUser.firstName, 'Juan');
      expect(updatedUser.lastName, 'Martínez'); // Se mantiene igual
      expect(updatedUser.addresses.first.street, 'Av. Siempre Viva');
    });

    test(
        'copyWith sin parámetros debe retornar el mismo objeto con valores iguales',
        () {
      final user = User(
        firstName: 'Laura',
        lastName: 'Gómez',
        birthDate: DateTime(1998, 7, 15),
      );

      final sameUser = user.copyWith();

      expect(sameUser.firstName, user.firstName);
      expect(sameUser.lastName, user.lastName);
      expect(sameUser.birthDate, user.birthDate);
      expect(sameUser.addresses, user.addresses);
    });
  });
}
