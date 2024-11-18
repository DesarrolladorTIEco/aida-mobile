import 'package:flutter/material.dart';
import 'ui/screens/login.dart';
import 'ui/screens/welcome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navegación',
      initialRoute: '/',
      routes: {
        '/': (context) => Pantalla1(),
        '/pantalla2': (context) => Pantalla2(),
      },
    );
  }
}
