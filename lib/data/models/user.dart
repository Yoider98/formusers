class Address {
  final String street;
  final String city;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.country,
  });
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
  });

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
}
