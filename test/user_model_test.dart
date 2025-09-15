import 'package:flutter_test/flutter_test.dart';
import 'package:formusers/data/models/user.dart';

void main() {
  group('Address model', () {
    test('Debe crear un Address correctamente', () {
      final address = Address(
        street: 'Calle 123',
        city: 'Santa Marta',
        department: 'Magdalena',
        municipality: 'Santa Marta',
        country: 'Colombia',
      );

      expect(address.street, 'Calle 123');
      expect(address.city, 'Santa Marta');
      expect(address.department, 'Magdalena');
      expect(address.municipality, 'Santa Marta');
      expect(address.country, 'Colombia');
    });

    test('copyWith debe actualizar campos correctamente', () {
      final address = Address(
        street: 'Calle 45',
        city: 'Bogotá',
        department: 'Cundinamarca',
        municipality: 'Bogotá',
        country: 'Colombia',
      );

      final updatedAddress = address.copyWith(
        street: 'Carrera 7',
        department: 'Antioquia',
      );

      expect(updatedAddress.street, 'Carrera 7');
      expect(updatedAddress.city, 'Bogotá');
      expect(updatedAddress.department, 'Antioquia');
      expect(updatedAddress.municipality, 'Bogotá');
      expect(updatedAddress.country, 'Colombia');
    });

    test('operador == debe comparar correctamente', () {
      final address1 = Address(
        street: 'Calle 1',
        city: 'Ciudad 1',
        department: 'Depto 1',
        municipality: 'Mun 1',
        country: 'País 1',
      );

      final address2 = Address(
        street: 'Calle 1',
        city: 'Ciudad 1',
        department: 'Depto 1',
        municipality: 'Mun 1',
        country: 'País 1',
      );

      final address3 = Address(
        street: 'Calle 2',
        city: 'Ciudad 1',
        department: 'Depto 1',
        municipality: 'Mun 1',
        country: 'País 1',
      );

      expect(address1, equals(address2));
      expect(address1, isNot(equals(address3)));
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
        department: 'Cundinamarca',
        municipality: 'Bogotá',
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
      expect(user.addresses.first.department, 'Cundinamarca');
    });

    test('Debe calcular la edad correctamente', () {
      final user = User(
        firstName: 'Test',
        lastName: 'User',
        birthDate: DateTime(2000, 1, 1),
      );

      expect(user.age, greaterThan(20));
      expect(user.age, lessThan(30));
    });

    test('fullName debe concatenar nombre y apellido', () {
      final user = User(
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
      );

      expect(user.fullName, 'Juan Pérez');
    });

    test('Debe validar datos del usuario', () {
      expect(
          () => User(
                firstName: '',
                lastName: 'Test',
                birthDate: DateTime(1990, 1, 1),
              ),
          throwsA(isA<ArgumentError>()));

      expect(
          () => User(
                firstName: 'Test',
                lastName: '',
                birthDate: DateTime(1990, 1, 1),
              ),
          throwsA(isA<ArgumentError>()));

      expect(
          () => User(
                firstName: 'Test',
                lastName: 'User',
                birthDate: DateTime(2030, 1, 1),
              ),
          throwsA(isA<ArgumentError>()));
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
              street: 'Av. Siempre Viva',
              city: 'Springfield',
              country: 'USA',
              department: 'Illinois',
              municipality: 'Springfield')
        ],
      );

      expect(updatedUser.firstName, 'Juan');
      expect(updatedUser.lastName, 'Martínez');
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
