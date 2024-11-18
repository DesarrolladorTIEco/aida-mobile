import 'package:flutter/material.dart';
import '../../widgets/navbar_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
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
              "Sincronizar-Offline",
              style: GoogleFonts.raleway(
                fontSize: 24,
                letterSpacing: 0.51,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Layout con Row para los Cards y botones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Card Grande (70% ancho)
                Container(
                  height: 70, // Altura del Card
                  width: MediaQuery.of(context).size.width * 0.7, // 70% ancho
                  child: Card(
                    color: Colors.blue.shade100,
                    elevation: 4,
                    child: const Center(child: Text("Card Grande")),
                  ),
                ),
                // Espacio entre el Card grande y los botones pequeños
                const SizedBox(width: 10),
                // Columna para los dos botones pequeños
                Column(
                  children: [
                    // Primer botón pequeño (15% ancho)
                    Container(
                      height: 70, // Altura del botón
                      width: MediaQuery.of(context).size.width * 0.15, // 15% ancho
                      margin: const EdgeInsets.only(bottom: 10), // Margen entre los botones
                      child: ElevatedButton(
                        onPressed: () {
                          print("Botón 1 presionado");
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.amber.shade800, // Color del texto
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Borde del botón
                          ),
                        ),
                        child: const Text("Botón 1"),
                      ),
                    ),
                    // Segundo botón pequeño (15% ancho)
                    Container(
                      height: 70, // Altura del botón
                      width: MediaQuery.of(context).size.width * 0.15, // 15% ancho
                      child: ElevatedButton(
                        onPressed: () {
                          print("Botón 2 presionado");
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.green.shade800, // Color del texto
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Borde del botón
                          ),
                        ),
                        child: const Text("Botón 2"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarScreen(), // Usando BottomNavBarScreen
    );
  }
}
