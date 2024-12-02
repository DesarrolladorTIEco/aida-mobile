import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Top Navigation Bar Widget
class TopNavBarScreen extends StatelessWidget {
  const TopNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red.shade800,
      automaticallyImplyLeading: false, // Oculta el botón de retroceso
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacio entre los elementos
        children: [
          Text(
            "Bienvenido", // Título del menú
            style: GoogleFonts.raleway(
              fontSize: 26,
              letterSpacing: 0.22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.home),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/menu-sec');
            },
          ),
        ],
      ),
    );
  }
}


// Bottom Navigation Bar Widget
class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white24,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Alinear al extremo derecho
        children: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.black,
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}