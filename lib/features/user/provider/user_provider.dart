import 'package:flutter/material.dart';
import 'package:formusers/data/models/user.dart';

class UserProvider extends ChangeNotifier {
  final List<User> _users = [];
  User? _currentUser;

  List<User> get users => _users;
  User? get currentUser => _currentUser;

  void selectUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void createUser(String firstName, String lastName, DateTime birthDate) {
    final newUser = User(
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
    );
    _users.add(newUser);
    _currentUser = newUser;
    notifyListeners();
  }

  void addAddress(Address address) {
    if (_currentUser != null) {
      final updated = _currentUser!.copyWith(
        addresses: [..._currentUser!.addresses, address],
      );
      _updateCurrentUser(updated);
    }
  }

  void editUserData({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
  }) {
    if (_currentUser != null) {
      final updated = _currentUser!.copyWith(
        firstName: firstName ?? _currentUser!.firstName,
        lastName: lastName ?? _currentUser!.lastName,
        birthDate: birthDate ?? _currentUser!.birthDate,
      );
      updateUser(updated);
    }
  }

  void editAddress(int index, Address updatedAddress) {
    if (_currentUser != null &&
        index >= 0 &&
        index < _currentUser!.addresses.length) {
      final updatedList = List<Address>.from(_currentUser!.addresses);
      updatedList[index] = updatedAddress;
      final updated = _currentUser!.copyWith(addresses: updatedList);
      _updateCurrentUser(updated);
    }
  }

  void removeAddress(int index) {
    if (_currentUser != null &&
        index >= 0 &&
        index < _currentUser!.addresses.length) {
      final updatedList = List<Address>.from(_currentUser!.addresses)
        ..removeAt(index);
      final updated = _currentUser!.copyWith(addresses: updatedList);
      _updateCurrentUser(updated);
    }
  }

  void _updateCurrentUser(User updated) {
    final index = _users.indexOf(_currentUser!);
    _users[index] = updated;
    _currentUser = updated;
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    if (_currentUser != null) {
      _updateCurrentUser(updatedUser);
    }
  }
}
