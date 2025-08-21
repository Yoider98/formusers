import 'package:flutter/material.dart';
import 'package:formusers/features/user/view/home_screen.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import '../../../data/models/user.dart';

class UserSummaryScreen extends StatelessWidget {
  const UserSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "No hay información de usuario",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resumen del Usuario"),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              final updatedUser = await _showEditUserDialog(context, user);
              if (updatedUser != null) {
                userProvider.editUserData(
                  firstName: updatedUser.firstName,
                  lastName: updatedUser.lastName,
                  birthDate: updatedUser.birthDate,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 📌 Card con info de usuario
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Información del Usuario",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blueAccent),
                        const SizedBox(width: 10),
                        Text("Nombre: ${user.firstName}",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.badge, color: Colors.blueAccent),
                        const SizedBox(width: 10),
                        Text("Apellido: ${user.lastName}",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.cake, color: Colors.blueAccent),
                        const SizedBox(width: 10),
                        Text(
                          "Nacimiento: ${user.birthDate.day}/${user.birthDate.month}/${user.birthDate.year}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Direcciones registradas",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: user.addresses.length,
                      itemBuilder: (context, index) {
                        final address = user.addresses[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.home,
                                color: Colors.blueAccent),
                            title: Text("${address.street}, ${address.city}"),
                            subtitle: Text(address.country),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blueAccent),
                                  onPressed: () async {
                                    final updatedAddress =
                                        await _showEditAddressDialog(
                                            context, address);
                                    if (updatedAddress != null) {
                                      userProvider.editAddress(
                                          index, updatedAddress);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () {
                                    userProvider.removeAddress(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final newAddress = await _showAddAddressDialog(context);
                  if (newAddress != null) {
                    userProvider.addAddress(newAddress);
                  }
                },
                icon: const Icon(Icons.add_location_alt, color: Colors.white),
                label: const Text("Agregar Dirección"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<User?> _showEditUserDialog(BuildContext context, User user) {
    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    DateTime birthDate = user.birthDate;

    return showDialog<User>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Editar Usuario"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: "Apellido",
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "${birthDate.day}/${birthDate.month}/${birthDate.year}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: birthDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        birthDate = picked;
                      }
                    },
                    child: const Text("Cambiar Fecha"),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  User(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    birthDate: birthDate,
                    addresses: user.addresses,
                  ),
                );
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  Future<Address?> _showEditAddressDialog(
      BuildContext context, Address address) {
    final streetController = TextEditingController(text: address.street);
    final cityController = TextEditingController(text: address.city);
    final countryController = TextEditingController(text: address.country);

    return showDialog<Address>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Editar Dirección"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: streetController,
                decoration: const InputDecoration(
                  labelText: "Calle",
                  prefixIcon: Icon(Icons.signpost),
                ),
              ),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: "Ciudad",
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),
              TextField(
                controller: countryController,
                decoration: const InputDecoration(
                  labelText: "País",
                  prefixIcon: Icon(Icons.flag),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                final updated = Address(
                  street: streetController.text,
                  city: cityController.text,
                  country: countryController.text,
                );
                Navigator.pop(context, updated);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  Future<Address?> _showAddAddressDialog(BuildContext context) {
    final streetController = TextEditingController();
    final cityController = TextEditingController();
    final countryController = TextEditingController();

    return showDialog<Address>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Nueva Dirección"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: streetController,
                decoration: const InputDecoration(
                  labelText: "Calle",
                  prefixIcon: Icon(Icons.signpost),
                ),
              ),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: "Ciudad",
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),
              TextField(
                controller: countryController,
                decoration: const InputDecoration(
                  labelText: "País",
                  prefixIcon: Icon(Icons.flag),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                final newAddress = Address(
                  street: streetController.text,
                  city: cityController.text,
                  country: countryController.text,
                );
                Navigator.pop(context, newAddress);
              },
              child: const Text("Agregar"),
            ),
          ],
        );
      },
    );
  }
}
