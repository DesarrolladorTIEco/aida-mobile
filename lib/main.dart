import 'package:aida/ui/screens/securitics/container-home.dart';
import 'package:aida/ui/screens/securitics/gallery_container.dart';
import 'package:aida/ui/screens/securitics/new_container.dart';
import 'package:aida/viewmodel/securitics/booking_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:aida/ui/screens/christmas/charge_max_date.dart';
import 'package:aida/ui/screens/securitics/menu_container.dart';
import 'package:aida/ui/screens/securitics/new_booking.dart';
import 'package:aida/ui/screens/securitics/booking_home.dart';
import 'package:aida/ui/screens/securitics/menu_planta_despacho.dart';
import 'package:aida/ui/screens/securitics/zone.dart';
import 'package:aida/viewmodel/carriers/carrier_viewmodel.dart';
import 'package:aida/viewmodel/christmas/worker_viewmodel.dart';
import 'package:aida/viewmodel/securitics/container_viewmodel.dart';
import 'package:aida/viewmodel/securitics/securitic_viewmodel.dart';
import 'package:aida/viewmodel/auth_viewmodel.dart';
import 'package:aida/ui/screens/login.dart';
import 'package:aida/ui/screens/welcome.dart';
import 'package:aida/ui/screens/carriers/carrier.dart';
import 'package:aida/ui/screens/christmas/menu.dart';
import 'package:aida/ui/screens/christmas/stock_log.dart';
import 'package:aida/ui/screens/christmas/charge_log.dart';
import 'package:aida/ui/screens/christmas/worker_log.dart';
import 'package:aida/ui/screens/christmas/xmas_log.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => CarrierViewModel()),
        ChangeNotifierProvider(create: (context) => WorkerViewModel()),
        ChangeNotifierProvider(create: (context) => SecuriticsViewModel()),
        ChangeNotifierProvider(create: (context) => ContainerViewModel()),
        ChangeNotifierProvider(create: (context) => BookingViewModel())
      ],
      child: MaterialApp(
        title: 'AIDA+',
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
          '/charge-xmas-date': (context) => const ChargeDateScreen(),
          '/worker-xmas': (context) => const WorkerScreen(),
          '/stock-xmas': (context) => const StockScreen(),

          //carrier
          '/carrier': (context) => const CarrierScreen(),

          //securitics
          '/menu-sec' :(context) => const MenuSecuriticsScreen(),
          '/zone-sec' :(context) => const ZonePage(),
          '/booking-home' : (context) =>  const BookingHomePage(),
          '/container-home' : (context) => const ContainerHomePage(),
          '/new-booking' : (context) => const NewBookingPage(),
          '/new-container' : (context) => const NewContainerPage(),
          '/menu-container' : (context) => const ContainerMenuPage(),
          '/gallery-container' : (context) => const ImageGalleryPage()

        },
      ),
    );
  }
}
