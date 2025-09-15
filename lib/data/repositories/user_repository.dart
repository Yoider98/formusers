import '../models/user.dart';

abstract class UserRepository {
  Future<List<User>> getAllUsers();
  Future<User?> getUserById(String id);
  Future<void> saveUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String id);
  Future<void> addAddressToUser(String userId, Address address);
  Future<void> updateUserAddress(
      String userId, int addressIndex, Address address);
  Future<void> removeUserAddress(String userId, int addressIndex);
}

class UserRepositoryImpl implements UserRepository {
  final List<User> _users = [];

  @override
  Future<List<User>> getAllUsers() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_users);
  }

  @override
  Future<User?> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      final index = int.parse(id);
      if (index >= 0 && index < _users.length) {
        return _users[index];
      }
    } catch (e) {}
    return null;
  }

  @override
  Future<void> saveUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _users.add(user);
  }

  @override
  Future<void> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 150));
  }

  @override
  Future<void> deleteUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
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
    await Future.delayed(const Duration(milliseconds: 100));
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
    await Future.delayed(const Duration(milliseconds: 100));
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
    await Future.delayed(const Duration(milliseconds: 100));
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
