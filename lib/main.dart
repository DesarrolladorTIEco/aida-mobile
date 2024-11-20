import 'package:flutter/material.dart';
import 'ui/screens/login.dart';
import 'ui/screens/welcome.dart';
import 'ui/screens/christmas/menu.dart';
import 'ui/screens/christmas/sync_off.dart';
import 'ui/screens/christmas/xmas_log.dart';
import 'ui/screens/christmas/charge_log.dart';
import 'ui/screens/christmas/worker_log.dart';
import 'ui/screens/christmas/stock_log.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navegación',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/welcome': (context) => WelcomePage(fullName: ModalRoute.of(context)!.settings.arguments as String),
        '/menu': (context) => const MenuScreen(), // Ruta para entrega navideña
        '/xmas-menu': (context) => const XMasMenu(),
        '/charge-xmas': (context) => const ChargeScreen(),
        '/worker-xmas': (context) => const WorkerScreen(),
        '/stock-xmas': (context) => const StockScreen(),
      },
    );
  }
}
