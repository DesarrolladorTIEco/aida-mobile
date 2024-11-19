import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.fullName});
  final String fullName; // Recibe el nombre completo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home, color: Colors.white),
        title: Text(
          'Bienvenido',
          style: GoogleFonts.raleway(color: Colors.white),
        ),
        backgroundColor: Colors.amber.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cuadro de información de usuario
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Logo del usuario
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.amber.shade800,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    // Nombre del usuario
                    Text(
                        fullName,
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Cuadros anidados
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Dos columnas
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 6, // Seis elementos de menú
                itemBuilder: (context, index) {
                  // Lista de elementos de menú
                  final menuItems = ['Inventario', 'Seguridad', 'Entrega Navideña', 'Packing', 'Tareo', 'PCP'];
                  // Lista de iconos correspondientes
                  final menuIcons = [
                    Icons.archive, // Inventario (Caja)
                    Icons.security, // Seguridad (Tuerca o algo relacionado)
                    Icons.card_giftcard, // Entrega Navideña (Regalo)
                    Icons.bento, // Packing (Caja)
                    Icons.group, // Tareo (Usuarios)
                    Icons.grain, // PCP (Uva)
                  ];

                  return GestureDetector(
                    onTap: () {
                      if (menuItems[index] == 'Entrega Navideña') {
                        // Redirigir a menu.dart
                        Navigator.pushNamed(context, '/menu');
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              menuIcons[index],
                              size: 40,
                              color: Colors.amber.shade800,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              menuItems[index],
                              style: GoogleFonts.raleway(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Botón de Cerrar Sesión
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navegar al Login
                  Navigator.pushReplacementNamed(context, '/login'); // Asegúrate de tener la ruta configurada
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.red.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text(
                  'Cerrar Sesión',
                  style: GoogleFonts.raleway(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
