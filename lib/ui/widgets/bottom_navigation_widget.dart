import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Text("Selected Index: $_selectedIndex"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber.shade800, // Color del AppBar
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,  // Asegúrate de usar este tipo para más ítems
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
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
        selectedItemColor: Colors.black54,

        unselectedLabelStyle: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),

        unselectedItemColor: Colors.white,

      ),
    );
  }
}
