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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => userProvider.loadUsers(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (userProvider.hasError)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        userProvider.error ?? "Error desconocido",
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ),
                    TextButton(
                      onPressed: () => userProvider.clearError(),
                      child: const Text("Cerrar"),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: userProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : userProvider.users.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people_outline,
                                  size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                "No hay usuarios registrados",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: userProvider.users.length,
                          itemBuilder: (context, index) {
                            final user = userProvider.users[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(user.fullName),
                                subtitle: Text(
                                    "Edad: ${user.age} años • Direcciones: ${user.addresses.length}"),
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
                primary: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
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
