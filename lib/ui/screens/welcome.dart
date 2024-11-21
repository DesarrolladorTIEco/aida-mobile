import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/auth_viewmodel.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener el nombre completo y los módulos desde el AuthViewModel
    final authViewModel = Provider.of<AuthViewModel>(context);
    final fullName = authViewModel.fullName;
    final modules = authViewModel.modules;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home, color: Colors.white),
        title: Text(
          'Bienvenido',
          style: GoogleFonts.raleway(color: Colors.white),
        ),
        backgroundColor: Colors.green.shade600,
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
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green.shade600,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
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

            // Cuadros anidados dinámicos
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: modules.length, // Cantidad de módulos dinámicos
                itemBuilder: (context, index) {
                  final module = modules[index];
                  final moduleName = module['Modulo'] ?? 'Sin nombre'; // Obtiene el nombre del módulo

                  // Asignar íconos según el nombre del módulo
                  final iconsMap = {
                    'Inventario': Icons.archive,
                    'Seguridad': Icons.security,
                    'Entrega de Canastas': Icons.card_giftcard,
                    'Control de Ingreso y salida de Carros': Icons.directions_car,
                    'Transporte de Personal': Icons.directions_bus,
                    'Asistencia': Icons.assignment,
                    'Tareo': Icons.group,
                  };

                  final moduleIcon = iconsMap[moduleName] ?? Icons.help; // Icono por defecto si no se encuentra

                  return GestureDetector(
                    onTap: () {
                      // Navegar según el nombre del módulo
                      if (moduleName == 'Entrega de Canastas') {
                        Navigator.pushNamed(context, '/menu');
                      } else if (moduleName == 'Transporte de Personal') {
                        Navigator.pushNamed(context, '/carrier');
                      } else if (moduleName == 'Control de Ingreso y salida de Carros') {
                        Navigator.pushNamed(context, '/carControl');
                      } else if (moduleName == 'Asistencia') {
                        Navigator.pushNamed(context, '/attendance');
                      } else if (moduleName == 'Tareo') {
                        Navigator.pushNamed(context, '/workHours');
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
                              moduleIcon,
                              size: 40,
                              color: Colors.green.shade600,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              moduleName,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.raleway(
                                fontSize: 14,
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
                  Navigator.pushReplacementNamed(context, '/login');
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
