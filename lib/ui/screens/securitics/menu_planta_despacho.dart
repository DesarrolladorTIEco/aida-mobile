import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/securitics/seguritic_viewmodel.dart';

class MenuSecuriticsScreen extends StatefulWidget {
  const MenuSecuriticsScreen({Key? key}) : super(key: key);

  @override
  State<MenuSecuriticsScreen> createState() => _MenuSecuriticsState();
}

class _MenuSecuriticsState extends State<MenuSecuriticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SecuriticsViewModel>(context, listen: false).fetchRegisterZones();
    });
  }


  @override
  Widget build(BuildContext context) {

    final securiticsViewModel = Provider.of<SecuriticsViewModel>(context);
    final zones = securiticsViewModel.registerZone;

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
            Text(
              "Zona de Registro",
              style: GoogleFonts.raleway(
                fontSize: 18,
                letterSpacing: 0.22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 25),
            // Comprobar si los datos se están cargando
            securiticsViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : zones.isEmpty
                    ? const Center(child: Text('No se encontraron zonas.'))
                    : Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: zones.length,
                          itemBuilder: (context, index) {
                            final zone = zones[index];
                            final zoneName = zone['Zona'] ?? 'Sin nombre';

                            // Asignar íconos según el nombre de la zona
                            final iconsMap = {
                              'RRHH': Icons.sports_kabaddi,
                            };

                            final zoneIcon =
                                iconsMap[zoneName] ?? Icons.car_crash;

                            return GestureDetector(
                              onTap: () {
                                final selectedZoneName = zone['Zona'] ?? 'Sin nombre';
                                Navigator.pushNamed(context, '/zone-sec', arguments: selectedZoneName,);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        zoneIcon,
                                        size: 40,
                                        color: Colors.green.shade600,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        zoneName,
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
          ],
        ),
      ),
    );
  }
}
