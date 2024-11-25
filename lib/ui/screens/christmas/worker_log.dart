import 'package:aida/core/utils/scanner_qr.dart';
import 'package:aida/viewmodel/christmas/worker_viewmodel.dart';
import 'package:flutter/material.dart';
import '../../widgets/navbar_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class WorkerScreen extends StatefulWidget {
  const WorkerScreen({super.key});

  @override
  _WorkerScreenState createState() => _WorkerScreenState();
}

class _WorkerScreenState extends State<WorkerScreen> {
  final TextEditingController _dniController = TextEditingController();

  Future<void> _loadWorkers(WorkerViewModel workerViewModel) async {
    final dni = _dniController.text.trim(); // Get entered DNI
    if (dni.isNotEmpty && dni.length == 8) {
      try {
        await workerViewModel.fetchWorkerDni(dni);
      } catch (e) {
        print("Error: Error al obtener los trabajadores: $e");
      }
    }
  }

  Future<void> _handleQrScan(WorkerViewModel workerViewModel) async {
    await QRScanner.scanQRCode(
      context: context,
      onCodeScanned: (String code) async {
        if (code.isNotEmpty) {
          if (code.length == 8 && int.tryParse(code) != null) {
            _dniController.text = code;  // Update the DNI controller with the scanned code
            await _loadWorkers(workerViewModel);  // Load workers with the scanned DNI
          }
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workerViewModel = Provider.of<WorkerViewModel>(context, listen: false);
      workerViewModel.clearWorkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final workerViewModel = Provider.of<WorkerViewModel>(context);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: TopNavBarScreen(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reporte de Canasta entregas por Responsable",
              style: GoogleFonts.raleway(
                fontSize: 16,
                letterSpacing: 0.22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // TextField to scan or enter DNI
            TextField(
              controller: _dniController,
              decoration: InputDecoration(
                labelText: "Buscar por DNI",
                labelStyle: GoogleFonts.raleway(
                    fontSize: 14, fontWeight: FontWeight.w600),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () => _handleQrScan(workerViewModel),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 22.0, horizontal: 16.0),
              ),
              onChanged: (value) {
                if (value.length == 8) {
                  _loadWorkers(workerViewModel);
                }
              },
            ),
            const SizedBox(height: 20),

            // List of workers based on the selected date and DNI
            Expanded(
              child: ListView.builder(
                itemCount: workerViewModel.workers.length,
                itemBuilder: (context, index) {
                  final worker = workerViewModel.workers[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: const Icon(Icons.person, size: 40, color: Colors.grey),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worker['FullName'] ?? 'Sin nombre',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          // Mostrar la Planilla y FechaCreacion
                          Text(
                            'Planilla: ${worker['Planilla'] ?? 'No disponible'}',
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Fecha de entrega: ${worker['FechaCreacion'] ?? 'No disponible'}',
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Responsable: ${worker['Responsable'] ?? 'No disponible'}',
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        'DNI: ${worker['DNI']}',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
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
      bottomNavigationBar: const BottomNavBarScreen(),
    );
  }
}
