import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import 'user_form_screen.dart';
import 'user_summary_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: userProvider.users.isEmpty
                  ? const Center(child: Text("No hay usuarios registrados"))
                  : ListView.builder(
                      itemCount: userProvider.users.length,
                      itemBuilder: (context, index) {
                        final user = userProvider.users[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text("${user.firstName} ${user.lastName}"),
                            subtitle:
                                Text("Direcciones: ${user.addresses.length}"),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              userProvider.selectUser(user);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const UserSummaryScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Crear Usuario"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserFormScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent, // color de fondo
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      15), // 👈 aquí defines qué tan redondeado
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
