import 'dart:convert';
import 'package:flutter/material.dart';
import '../../widgets/navbar_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/carriers/carrier_viewmodel.dart';
import '../../../data/models/carriers/carrier_model.dart';

class CarrierScreen extends StatelessWidget {
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _occupantController = TextEditingController();
  final TextEditingController _driverController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _selectedGate;

  CarrierScreen({super.key});

  Future<void> _sendData(BuildContext context) async {
    final carrierViewModel = Provider.of<CarrierViewModel>(context, listen: false);

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
        "RM",
        "2024-11-14T12:20:37",
        1,
      );

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registro insertado exitosamente"),
            backgroundColor: Colors.green,
          ),
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

  void _clearFields() {
    _placaController.clear();
    _occupantController.clear();
    _dniController.clear();
    _driverController.clear();
    _routeController.clear();
    _typeController.clear();
    _dateController.clear();
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

            // Dropdown para Puerta
            DropdownButtonFormField<String>(
              value: _selectedGate,
              hint: const Text('Seleccionar Puerta'),
              onChanged: (value) {
                _selectedGate = value;
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

            // TextField para Ruta
            _buildTextField("Ruta", _routeController),
            const SizedBox(height: 20),

            // TextField para Placa con ícono de QR
            TextField(
              controller: _placaController,
              decoration: InputDecoration(
                labelText: "Placa",
                labelStyle: GoogleFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                suffixIcon: Icon(Icons.qr_code_scanner),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green.shade600, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Otros campos de texto
            _buildTextField("DNI", _dniController),
            const SizedBox(height: 8),
            _buildTextField("Nombre y Apellido Conductor", _driverController),
            const SizedBox(height: 8),
            _buildTextField("Número de Ocupantes", _occupantController),
            const SizedBox(height: 8),

            // Añadir un Expanded para que el contenido ocupe todo el espacio disponible
            Expanded(child: Container()),

            //boton de enviar
            Align(
              alignment: Alignment.bottomCenter,
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

  Widget _buildTextField(String label, TextEditingController controller) {
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
      ),
    );
  }
}
