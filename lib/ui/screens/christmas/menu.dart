import 'package:flutter/material.dart';
import '../../widgets/navbar_widget.dart'; // Asegúrate de importar correctamente el archivo
import 'package:google_fonts/google_fonts.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
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
        preferredSize: const Size.fromHeight(60.0), // Ajusta la altura del AppBar
        child: const TopNavBarScreen(), // Usando TopNavBarScreen
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alineación de los elementos a la izquierda
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Entrega de Canastas",
              style: GoogleFonts.raleway(
                fontSize: 24,
                letterSpacing: 0.51,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          // Input para escanear código QR con el ícono dentro del input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Escanear código",
                labelStyle: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w600),
                prefixIcon: const Icon(Icons.qr_code_scanner),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16.0), // Ajuste para centrar el texto
              ),
            ),
          ),
          // Espaciado antes del botón
          const SizedBox(height: 220),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center( // Centra el botón dentro del espacio disponible
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5, // Ajusta el tamaño del botón
                child: ElevatedButton(
                  onPressed: () {
                    print("Visualizando entregas");
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.amber.shade800,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    "Visualizar Entregas",
                    style: GoogleFonts.raleway( // Cambia la tipografía del botón
                      fontSize: 16, // Tamaño de fuente
                      fontWeight: FontWeight.w600, // Peso de la fuente
                      color: Colors.white, // Color del texto
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarScreen(), // Usando BottomNavBarScreen
    );
  }
}
