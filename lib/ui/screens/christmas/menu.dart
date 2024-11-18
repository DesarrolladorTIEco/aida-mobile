import 'package:flutter/material.dart';
import '../../widgets/navbar_widget.dart'; // Asegúrate de importar correctamente el archivo

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
      // Top Navigation Bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), // Ajusta la altura del AppBar
        child: const TopNavBarScreen(), // Usando TopNavBarScreen
      ),
      body: Column(
        children: [
          // Título "Entrega de Canastas"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Entrega de Canastas",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          // Input para escanear código QR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Escanear código",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    // Lógica para escanear el código QR
                    print("Escanear QR");
                  },
                ),
              ),
            ),
          ),
          // Espaciado antes del botón
          const SizedBox(height: 20),
          // Botón para visualizar entregas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Acción para visualizar las entregas
                print("Visualizando entregas");
              },
              child: const Text("Visualizar Entregas"),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: const BottomNavBarScreen(), // Usando BottomNavBarScreen
    );
  }
}
