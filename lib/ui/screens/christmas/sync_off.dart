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
                // Card Grande (60% ancho) con la misma altura que los botones
                Container(
                  height: 162, // Altura del Card (más alta que antes)
                  width: MediaQuery.of(context).size.width * 0.6, // 60% ancho
                  child: Card(
                    color: Colors.white70,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Menos redondeo en el borde
                    ),
                    child: const Center(child: Text("Card Grande")),
                  ),
                ),
                // Primer botón con ícono de nube (cloud sync) y margin-right
                Container(
                  height: 150, // Altura del botón (igual a la altura del Card)
                  width: MediaQuery.of(context).size.width * 0.15, // 15% ancho
                  margin: const EdgeInsets.only(right: 4.0), // Espacio entre los botones
                  child: ElevatedButton(
                    onPressed: () {
                      print("Botón 1 presionado");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.black54,
                      backgroundColor: Colors.white70, // Color del texto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Sin borde redondeado
                      ),
                      elevation: 2, // Elevación para sombra
                    ),
                    child: Center(
                      child: Icon(
                        Icons.cloud_sync,
                        size: 40, // Tamaño del ícono
                      ),
                    ),
                  ),
                ),
                // Segundo botón con ícono de editar
                Container(
                  height: 150, // Altura del botón (igual a la altura del Card)
                  width: MediaQuery.of(context).size.width * 0.15, // 15% ancho
                  child: ElevatedButton(
                    onPressed: () {
                      print("Botón 2 presionado");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.black54,
                      backgroundColor: Colors.white70, // Color del texto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Sin borde redondeado
                      ),
                      elevation: 2, // Elevación para sombra
                    ),
                    child: Center(
                      child: Icon(
                        Icons.edit,
                        size: 40, // Tamaño del ícono
                      ),
                    ),
                  ),
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