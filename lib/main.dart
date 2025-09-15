import 'package:flutter/material.dart';
import 'package:formusers/features/user/view/home_screen.dart';
import 'package:provider/provider.dart';
import 'features/user/provider/user_provider.dart';
import 'features/user/services/user_service.dart';
import 'data/repositories/user_repository.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<UserRepository>(
          create: (_) => UserRepositoryImpl(),
        ),
        Provider<UserService>(
          create: (context) => UserService(context.read<UserRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(context.read<UserService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prueba Técnica Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
