class Address {
  final String street;
  final String city;
  final String department;
  final String municipality;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.department,
    required this.municipality,
    required this.country,
  });

  Address copyWith({
    String? street,
    String? city,
    String? department,
    String? municipality,
    String? country,
  }) {
    return Address(
      street: street ?? this.street,
      city: city ?? this.city,
      department: department ?? this.department,
      municipality: municipality ?? this.municipality,
      country: country ?? this.country,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address &&
        other.street == street &&
        other.city == city &&
        other.department == department &&
        other.municipality == municipality &&
        other.country == country;
  }

  @override
  int get hashCode {
    return street.hashCode ^
        city.hashCode ^
        department.hashCode ^
        municipality.hashCode ^
        country.hashCode;
  }

  @override
  String toString() {
    return 'Address(street: $street, city: $city, department: $department, municipality: $municipality, country: $country)';
  }
}

class User {
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final List<Address> addresses;

  User({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.addresses = const [],
  }) {
    _validateUser();
  }

  void _validateUser() {
    if (firstName.trim().isEmpty) {
      throw ArgumentError('El nombre no puede estar vacío');
    }
    if (lastName.trim().isEmpty) {
      throw ArgumentError('El apellido no puede estar vacío');
    }
    if (birthDate.isAfter(DateTime.now())) {
      throw ArgumentError('La fecha de nacimiento no puede ser futura');
    }
    final age = DateTime.now().year - birthDate.year;
    if (age < 0 || age > 150) {
      throw ArgumentError('La edad debe estar entre 0 y 150 años');
    }
  }

  User copyWith({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    List<Address>? addresses,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      addresses: addresses ?? this.addresses,
    );
  }

  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String get fullName => '$firstName $lastName';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.birthDate == birthDate &&
        other.addresses.length == addresses.length &&
        _listEquals(other.addresses, addresses);
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        birthDate.hashCode ^
        addresses.hashCode;
  }

  @override
  String toString() {
    return 'User(firstName: $firstName, lastName: $lastName, birthDate: $birthDate, addresses: $addresses)';
  }

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
