import 'package:aida/viewmodel/carriers/carrier_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/auth_viewmodel.dart';
import 'ui/screens/login.dart';
import 'ui/screens/welcome.dart';
import 'ui/screens/carriers/carrier.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => CarrierViewModel()), // Agrega el CarrierViewModel aquí
      ],
      child: MaterialApp(
        title: 'Mi Aplicación',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/welcome': (context) => const WelcomePage(),

          //christmas
          '/menu': (context) => const MenuScreen(),
          '/xmas-menu': (context) => const XMasMenu(),
          '/charge-xmas': (context) => const ChargeScreen(),
          '/worker-xmas': (context) => const WorkerScreen(),
          '/stock-xmas': (context) => const StockScreen(),

          //carrier
          '/carrier': (context) => CarrierScreen(),
        },
      ),
    );
  }
}
