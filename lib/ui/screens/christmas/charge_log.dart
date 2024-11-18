import 'package:flutter/material.dart';
import '../../widgets/navbar_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class ChageScreen extends StatefulWidget {
  const ChageScreen({super.key});

  @override
  _ChageScreenState createState() => _ChageScreenState();
}

class _ChageScreenState extends State<ChageScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: const TopNavBarScreen(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Reporte de Canasta entregas",
              style: GoogleFonts.raleway(
                fontSize: 18,
                letterSpacing: 0.22,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Layout con Row para los Cards y botones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarScreen(), // Usando BottomNavBarScreen
    );
  }
}