import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Top Navigation Bar Widget
class TopNavBarScreen extends StatelessWidget {
  const TopNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      actions: [
        // Aquí estamos usando un Row para distribuir los íconos
        Expanded(
          child: Row(
            children: const [
              const Padding(
                padding: EdgeInsets.only(right: 20), // Asegura que haya espacio en el extremo derecho
              ),
              // Los íconos a la izquierda (pero con espacio entre ellos)
            ],
          ),
        ),
        // Los íconos que permanecen en su lugar
        const Padding(
          padding: EdgeInsets.only(right: 20), // Asegura que haya espacio en el extremo derecho
          child: Icon(Icons.notifications),
        ),
        const SizedBox(width: 20),
        const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.more_vert),
        ),
      ],
    );}
}

// Bottom Navigation Bar Widget
class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.red.shade800,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Reportes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      selectedLabelStyle: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.w600),
      selectedItemColor: Colors.white70,
      unselectedLabelStyle: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedItemColor: Colors.white,
    );
  }
}
