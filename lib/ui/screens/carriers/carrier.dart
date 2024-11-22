import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Asegúrate de importar Provider
import '../../../viewmodel/auth_viewmodel.dart'; // Importa el AuthViewModel
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../viewmodel/carriers/carrier_viewmodel.dart';
import '../../../data/models/carriers/carrier_model.dart';
import '../../widgets/navbar_widget.dart';
import 'package:intl/intl.dart'; // Necesario para el formato de fechas
import 'package:fluttertoast/fluttertoast.dart';


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
  final TextEditingController _seatNumberController = TextEditingController();

  String? _selectedGate;
  final MobileScannerController _cameraController = MobileScannerController();
  bool _scanned = false; // Variable para determinar si se escaneó un código

  Future<void> _sendData(BuildContext context) async {
    if (!_validateFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, completa todos los campos obligatorios."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Continúa con el envío solo si todos los campos son válidos.
    final userID = Provider.of<AuthViewModel>(context, listen: false).userID;
    final carrierViewModel = Provider.of<CarrierViewModel>(context, listen: false);

    final now = DateTime.now();
    final String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now);

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
        int.parse(userID.trim()),
        int.parse(_seatNumberController.text),
      );

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
                    Navigator.of(context).pop();
                  },
                  child: const Text("Aceptar"),
                ),
              ],
            );
          },
        );

        _clearFields();
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


  bool _validateFields() {
    if (_placaController.text.isEmpty ||
        _dniController.text.isEmpty ||
        _driverController.text.isEmpty ||
        _routeController.text.isEmpty ||
        _selectedGate == null ||
        _occupantController.text.isEmpty ||
        _seatNumberController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "¡Debe completar todos los campos!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return false;
    }

    // Validar si ocupantes y cantidad de asientos son números válidos
    try {
      int.parse(_occupantController.text);
      int.parse(_seatNumberController.text);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "¡Ocupantes y asientos deben ser números válidos!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return false;
    }

    return true;
  }

  void _clearFields() {
    _placaController.clear();
    _occupantController.clear();
    _dniController.clear();
    _driverController.clear();
    _routeController.clear();
    _seatNumberController.clear();
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
            const SizedBox(height: 10),
            _buildTextField("Cantidad Asientos", _seatNumberController),
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
