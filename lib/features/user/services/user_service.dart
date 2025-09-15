import 'package:formusers/data/models/user.dart';
import 'package:formusers/data/repositories/user_repository.dart';

class UserService {
  final UserRepository _repository;

  UserService(this._repository);

  Future<List<User>> getAllUsers() async {
    try {
      return await _repository.getAllUsers();
    } catch (e) {
      throw UserServiceException('Error al obtener usuarios: ${e.toString()}');
    }
  }

  Future<User> createUser({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
  }) async {
    try {
      _validateUserData(firstName, lastName, birthDate);

      final user = User(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        birthDate: birthDate,
      );

      await _repository.saveUser(user);
      return user;
    } catch (e) {
      if (e is UserServiceException) rethrow;
      throw UserServiceException('Error al crear usuario: ${e.toString()}');
    }
  }

  Future<User> updateUser({
    required User currentUser,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
  }) async {
    try {
      final updatedUser = currentUser.copyWith(
        firstName: firstName?.trim(),
        lastName: lastName?.trim(),
        birthDate: birthDate,
      );

      _validateUserData(
          updatedUser.firstName, updatedUser.lastName, updatedUser.birthDate);

      await _repository.updateUser(updatedUser);
      return updatedUser;
    } catch (e) {
      if (e is UserServiceException) rethrow;
      throw UserServiceException(
          'Error al actualizar usuario: ${e.toString()}');
    }
  }

  Future<User> addAddressToUser(User user, Address address) async {
    try {
      _validateAddress(address);

      final updatedUser = user.copyWith(
        addresses: [...user.addresses, address],
      );

      await _repository.updateUser(updatedUser);
      return updatedUser;
    } catch (e) {
      if (e is UserServiceException) rethrow;
      throw UserServiceException('Error al agregar dirección: ${e.toString()}');
    }
  }

  Future<User> updateUserAddress(
      User user, int addressIndex, Address address) async {
    try {
      _validateAddress(address);

      if (addressIndex < 0 || addressIndex >= user.addresses.length) {
        throw UserServiceException('Índice de dirección inválido');
      }

      final updatedAddresses = List<Address>.from(user.addresses);
      updatedAddresses[addressIndex] = address;

      final updatedUser = user.copyWith(addresses: updatedAddresses);
      await _repository.updateUser(updatedUser);
      return updatedUser;
    } catch (e) {
      if (e is UserServiceException) rethrow;
      throw UserServiceException(
          'Error al actualizar dirección: ${e.toString()}');
    }
  }

  Future<User> removeUserAddress(User user, int addressIndex) async {
    try {
      if (addressIndex < 0 || addressIndex >= user.addresses.length) {
        throw UserServiceException('Índice de dirección inválido');
      }

      final updatedAddresses = List<Address>.from(user.addresses);
      updatedAddresses.removeAt(addressIndex);

      final updatedUser = user.copyWith(addresses: updatedAddresses);
      await _repository.updateUser(updatedUser);
      return updatedUser;
    } catch (e) {
      if (e is UserServiceException) rethrow;
      throw UserServiceException(
          'Error al eliminar dirección: ${e.toString()}');
    }
  }

  void _validateUserData(
      String firstName, String lastName, DateTime birthDate) {
    if (firstName.trim().isEmpty) {
      throw UserServiceException('El nombre es requerido');
    }
    if (lastName.trim().isEmpty) {
      throw UserServiceException('El apellido es requerido');
    }
    if (birthDate.isAfter(DateTime.now())) {
      throw UserServiceException('La fecha de nacimiento no puede ser futura');
    }

    final age = DateTime.now().year - birthDate.year;
    if (age < 0 || age > 150) {
      throw UserServiceException('La edad debe estar entre 0 y 150 años');
    }
  }

  void _validateAddress(Address address) {
    if (address.street.trim().isEmpty) {
      throw UserServiceException('La calle es requerida');
    }
    if (address.city.trim().isEmpty) {
      throw UserServiceException('La ciudad es requerida');
    }
    if (address.department.trim().isEmpty) {
      throw UserServiceException('El departamento es requerido');
    }
    if (address.municipality.trim().isEmpty) {
      throw UserServiceException('El municipio es requerido');
    }
    if (address.country.trim().isEmpty) {
      throw UserServiceException('El país es requerido');
    }
  }
}

class UserServiceException implements Exception {
  final String message;
  UserServiceException(this.message);

  @override
  String toString() => 'UserServiceException: $message';
}
