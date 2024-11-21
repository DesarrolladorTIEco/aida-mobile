import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../viewmodel/carriers/carrier_viewmodel.dart';
import '../../../data/models/carriers/carrier_model.dart';
import '../../widgets/navbar_widget.dart';
import 'package:intl/intl.dart'; // Necesario para el formato de fechas

class CarrierScreen extends StatefulWidget {
  const CarrierScreen({super.key});

  @override
  _CarrierScreenState createState() => _CarrierScreenState();
}

class _CarrierScreenState extends State<CarrierScreen> {
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _occupantController = TextEditingController();
  final TextEditingController _driverController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();

  String? _selectedGate;
  final MobileScannerController _cameraController = MobileScannerController();
  bool _scanned = false; // Variable para determinar si se escaneó un código

  Future<void> _sendData(BuildContext context) async {
    final carrierViewModel = Provider.of<CarrierViewModel>(context, listen: false);

    // Capturar la fecha actual
    final now = DateTime.now();
    final String formattedDate = _scanned
        ? DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now) // Fecha y hora si se escaneó
        : DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now); // Solo fecha si no se escaneó

    // Determinar el tipo según si se escaneó o no
    final String type = _scanned ? "RA" : "RM";

    carrierViewModel.isLoading = true;
    carrierViewModel.notifyListeners();

    try {
      CarrierModel? response = await carrierViewModel.insert(
        _placaController.text,
        int.parse(_occupantController.text),
        _dniController.text,
        _driverController.text,
        _routeController.text,
        _selectedGate ?? '',
        type,
        formattedDate,
        1, //usuario
      );

      print("response "+ jsonEncode(response));

      if (response != null) {
        // Mostrar popup de éxito
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Éxito"),
              content: const Text("Registro insertado exitosamente."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el popup
                  },
                  child: const Text("Aceptar"),
                ),
              ],
            );
          },
        );

        _clearFields(); // Limpiar los campos
      } else {
        throw Exception(carrierViewModel.errorMessage);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      carrierViewModel.isLoading = false;
      carrierViewModel.notifyListeners();
    }
  }


  void _clearFields() {
    _placaController.clear();
    _occupantController.clear();
    _dniController.clear();
    _driverController.clear();
    _routeController.clear();
    _scanned = false; // Reiniciar la variable de escaneo
  }

  void _scanQRCode(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 300,
            width: 300,
            child: MobileScanner(
              controller: _cameraController,
              onDetect: (BarcodeCapture barcode) {
                final String code = barcode.barcodes.first.rawValue ?? '';
                if (code.isNotEmpty) {
                  setState(() {
                    _placaController.text = code;
                    _scanned = true; // Marcar como escaneado
                  });
                }
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {Widget? suffixIcon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade600, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        suffixIcon: suffixIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carrierViewModel = Provider.of<CarrierViewModel>(context);

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
              "Registro de Transportista",
              style: GoogleFonts.raleway(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedGate,
              hint: const Text('Seleccionar Puerta'),
              onChanged: (value) {
                setState(() {
                  _selectedGate = value;
                });
              },
              items: [
                'Tranquera 01',
                'Tranquera 02',
                'Tranquera 03',
                'Tranquera Marquez'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Puerta',
                labelStyle: GoogleFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green.shade600, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField("Ruta", _routeController),
            const SizedBox(height: 20),
            _buildTextField(
              "Placa",
              _placaController,
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner, color: Colors.black54),
                onPressed: () => _scanQRCode(context),
              ),
            ),
            const SizedBox(height: 60),
            _buildTextField("DNI", _dniController),
            const SizedBox(height: 10),
            _buildTextField("Conductor", _driverController),
            const SizedBox(height: 10),
            _buildTextField("Ocupantes", _occupantController),
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton.icon(
                  onPressed: carrierViewModel.isLoading ? null : () => _sendData(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.red.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    'Enviar',
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarScreen(),
    );
  }
}
