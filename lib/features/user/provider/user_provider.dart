import 'package:flutter/material.dart';
import 'package:formusers/data/models/user.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService;

  List<User> _users = [];
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserProvider(this._userService);

  List<User> get users => List.unmodifiable(_users);
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  Future<void> initialize() async {
    await loadUsers();
  }

  Future<void> loadUsers() async {
    _setLoading(true);
    try {
      _users = await _userService.getAllUsers();
      _clearError();
    } catch (e) {
      _setError('Error al cargar usuarios: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void selectUser(User user) {
    _currentUser = user;
    _clearError();
    notifyListeners();
  }

  Future<void> createUser(
      String firstName, String lastName, DateTime birthDate) async {
    _setLoading(true);
    try {
      final newUser = await _userService.createUser(
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
      );
      _users.add(newUser);
      _currentUser = newUser;
      _clearError();
    } catch (e) {
      _setError('Error al crear usuario: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addAddress(Address address) async {
    if (_currentUser == null) {
      _setError('No hay usuario seleccionado');
      return;
    }

    _setLoading(true);
    try {
      final updatedUser =
          await _userService.addAddressToUser(_currentUser!, address);
      _updateCurrentUser(updatedUser);
      _clearError();
    } catch (e) {
      _setError('Error al agregar dirección: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> editUserData({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
  }) async {
    if (_currentUser == null) {
      _setError('No hay usuario seleccionado');
      return;
    }

    _setLoading(true);
    try {
      final updatedUser = await _userService.updateUser(
        currentUser: _currentUser!,
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
      );
      _updateCurrentUser(updatedUser);
      _clearError();
    } catch (e) {
      _setError('Error al actualizar usuario: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> editAddress(int index, Address updatedAddress) async {
    if (_currentUser == null) {
      _setError('No hay usuario seleccionado');
      return;
    }

    _setLoading(true);
    try {
      final updatedUser = await _userService.updateUserAddress(
        _currentUser!,
        index,
        updatedAddress,
      );
      _updateCurrentUser(updatedUser);
      _clearError();
    } catch (e) {
      _setError('Error al actualizar dirección: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeAddress(int index) async {
    if (_currentUser == null) {
      _setError('No hay usuario seleccionado');
      return;
    }

    _setLoading(true);
    try {
      final updatedUser =
          await _userService.removeUserAddress(_currentUser!, index);
      _updateCurrentUser(updatedUser);
      _clearError();
    } catch (e) {
      _setError('Error al eliminar dirección: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void _updateCurrentUser(User updated) {
    final index = _users.indexWhere((user) => user == _currentUser);
    if (index != -1) {
      _users[index] = updated;
    }
    _currentUser = updated;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
