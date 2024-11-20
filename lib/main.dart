import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/auth_viewmodel.dart';
import 'ui/screens/login.dart';
import 'ui/screens/welcome.dart';
import 'ui/screens/christmas/menu.dart';
import 'ui/screens/christmas/stock_log.dart';
import 'ui/screens/christmas/charge_log.dart';
import 'ui/screens/christmas/worker_log.dart';
import 'ui/screens/christmas/xmas_log.dart';

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
          '/menu' :(context) => const MenuScreen(),
          '/xmas-menu' :(context) => const XMasMenu(),
          '/charge-xmas' :(context) => const ChargeScreen(),
          '/worker-xmas' :(context) => const WorkerScreen(),
          '/stock-xmas' :(context) => const StockScreen(),
        },
      ),
    );
  }
}
