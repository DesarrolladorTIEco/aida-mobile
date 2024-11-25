import 'package:aida/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../widgets/navbar_widget.dart'; // Navbar
import 'package:aida/core/utils/scanner_qr.dart'; // QR scanner
import 'package:aida/viewmodel/christmas/worker_viewmodel.dart'; // ViewModel

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _dniController = TextEditingController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleQrScan(WorkerViewModel workerViewModel) async {
    await QRScanner.scanQRCode(
      context: context,
      onCodeScanned: (String code) async {
        if (code.isNotEmpty) {
          if (code.length == 8 && int.tryParse(code) != null) {
            await _saveData(workerViewModel, dni: code);
          } else {
            await _saveData(workerViewModel, qrCode: code);
          }
        }
      },
    );
  }

  Future<void> _saveData(WorkerViewModel workerViewModel,
      {String? dni, String? qrCode}) async {
    final userID = Provider.of<AuthViewModel>(context, listen: false).userID;
    final userDni = Provider.of<AuthViewModel>(context, listen: false).userDni;

    String resultMessage;

    if (dni != null) {
      resultMessage = await workerViewModel.save(dni, userDni, int.parse(userID.trim()));
    } else if (qrCode != null) {
      resultMessage = await workerViewModel.save(qrCode, userDni, int.parse(userID.trim()));
    } else {
      resultMessage = "Código no válido.";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            resultMessage == 'success' ? 'Éxito' : 'Error',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: resultMessage == 'success' ? Colors.green : Colors.red,
            ),
          ),
          content: Text(
            resultMessage == 'success'
                ? 'Entrega registrada exitosamente.'
                : resultMessage,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWorkers();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWorkers();
    });

    _dniController.addListener(() async {
      final dni = _dniController.text.trim();
      if (dni.length == 8 && int.tryParse(dni) != null) {
        final workerViewModel = Provider.of<WorkerViewModel>(context, listen: false);
        await _saveData(workerViewModel, dni: dni);
        _dniController.clear();
      }
    });
  }

  void _loadWorkers() async {
    final workerViewModel = Provider.of<WorkerViewModel>(context, listen: false);
    final userDni = Provider.of<AuthViewModel>(context, listen: false).userDni;

    String date = DateTime.now().toIso8601String().split('T').first;

    await workerViewModel.fetchWorkers(userDni, date);
  }

  @override
  Widget build(BuildContext context) {
    final workerViewModel = Provider.of<WorkerViewModel>(context);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: TopNavBarScreen(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _dniController,
              decoration: InputDecoration(
                labelText: "Escanear código o escribir DNI",
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
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Entregas del Día", // Aquí es donde se agrega el título pequeño
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 16), // Espacio entre el título y el Expanded
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
                          'Fecha de Creación: ${worker['FechaCreacion'] ?? 'No disponible'}',
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
      bottomNavigationBar: const BottomNavBarScreen(),
    );
  }
}
