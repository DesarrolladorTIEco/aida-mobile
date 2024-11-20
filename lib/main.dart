import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/auth_viewmodel.dart';
import 'ui/screens/login.dart';
import 'ui/screens/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthViewModel(),  // Proveemos el AuthViewModel
      child: MaterialApp(
        title: 'Mi Aplicación',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/welcome': (context) => const WelcomePage(), // Asegúrate de tener esta ruta
        },
      ),
    );
  }
}
