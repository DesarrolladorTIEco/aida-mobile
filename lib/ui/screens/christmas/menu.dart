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
  final TextEditingController _dniController = TextEditingController(); // Controller for TextField
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Método para manejar el escaneo del código QR o de barras
  Future<void> _handleQrScan(WorkerViewModel workerViewModel) async {
    await QRScanner.scanQRCode(
      context: context,
      onCodeScanned: (String code) async {
        if (code.isNotEmpty) {
          // Determina si el código es DNI o QR por longitud o formato
          if (code.length == 8 && int.tryParse(code) != null) {
            // Es un DNI válido (longitud 8 y numérico)
            await _saveData(workerViewModel, dni: code);
          } else {
            // Es un código QR u otro tipo de barra
            await _saveData(workerViewModel, qrCode: code);
          }
        }
      },
    );
  }

  // Guardar los datos en base al DNI o QR
  Future<void> _saveData(WorkerViewModel workerViewModel, {String? dni, String? qrCode}) async {
    final userID = Provider.of<AuthViewModel>(context, listen: false).userID;
    final userDni = Provider.of<AuthViewModel>(context, listen: false).userDni;

    String message;
    if (dni != null) {
      // Inserta usando DNI
      message = (await workerViewModel.save(dni, userDni, int.parse(userID.trim()))) as String;
    } else if (qrCode != null) {
      // Inserta usando QR
      message = (await workerViewModel.save(qrCode, userDni, int.parse(userID.trim()))) as String;
    } else {
      message = "Código no válido.";
    }

    // Mostrar un snackbar con el resultado
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();

    // Listener para cuando se escriban 8 dígitos
    _dniController.addListener(() async {
      final dni = _dniController.text.trim();
      if (dni.length == 8 && int.tryParse(dni) != null) {
        final workerViewModel = Provider.of<WorkerViewModel>(context, listen: false);
        await _saveData(workerViewModel, dni: dni);
        _dniController.clear(); // Limpia el campo después de insertar
      }
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
          // Input para escanear código QR o escribir manualmente
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _dniController, // Bind controller
              decoration: InputDecoration(
                labelText: "Escanear código o escribir DNI",
                labelStyle: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w600),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () => _handleQrScan(workerViewModel), // Escanear QR
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16.0),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 220),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/xmas-menu');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    "Visualizar Entregas",
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarScreen(),
    );
  }
}
