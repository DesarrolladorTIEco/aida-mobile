import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/securitics/securitic_viewmodel.dart';

class ZonePage extends StatefulWidget {
  const ZonePage({Key? key}) : super(key: key);

  @override
  State<ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<ZonePage> {
  String zoneName = '';

  @override
  void initState() {
    super.initState();
    // Llama a la función para cargar las zonas
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<SecuriticsViewModel>(context, listen: false)
          .fetchCultives();
    });
  }

  @override
  Widget build(BuildContext context) {
    zoneName = ModalRoute.of(context)!.settings.arguments as String;

    final securiticsViewModel = Provider.of<SecuriticsViewModel>(context);
    final cultive = securiticsViewModel.cultive;

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
              zoneName,  //titulo del menu
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
                : cultive.isEmpty
                ? const Center(child: Text('No se encontraron zonas.'))
                : Expanded(
              child: GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: cultive.length,
                itemBuilder: (context, index) {
                  final x = cultive[index];
                  final cultiveName = x['Cultivo'] ?? 'Sin nombre';

                  final iconsMap = {};

                  final icon =
                      iconsMap[cultiveName] ?? Icons.apartment;

                  return GestureDetector(
                    onTap: () {
                      final selectedCultive = x['Cultivo'] ?? '';

                      final arguments = {
                        'cultive': selectedCultive,
                        'zone': zoneName,
                      };

                      Navigator.pushNamed(context, '/booking-home', arguments: arguments);
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
                              icon,
                              size: 40,
                              color: Colors.green.shade600,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              cultiveName,
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
