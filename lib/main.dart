import 'package:flutter/material.dart';
import 'ui/screens/login.dart';
import 'ui/screens/welcome.dart';
import 'ui/screens/christmas/menu.dart';
import 'ui/screens/christmas/sync_off.dart';
import 'ui/screens/christmas/xmas_log.dart';
import 'ui/screens/christmas/charge_log.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navegación',
      initialRoute: '/',
      routes: {
        // '/': (context) => LoginPage(),
        '/': (context) => ChageScreen(),
      },
    );
  }
}
