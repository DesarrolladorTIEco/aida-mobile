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
  final TextEditingController _gateController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _userController = TextEditingController();

  CarrierScreen({super.key});

  Future<void> _sendData(BuildContext context) async {
    final carrierViewModel = Provider.of<CarrierViewModel>(context, listen: false);

    carrierViewModel.isLoading = true;
    carrierViewModel.notifyListeners();

    try {
      DateTime date = DateTime.parse(_dateController.text); // Asegúrate del formato aquí

      print("Placa: ${_placaController.text}");
      print("Ocupantes: ${_occupantController.text}");
      print("DNI: ${_dniController.text}");
      print("Conductor: ${_driverController.text}");
      print("Ruta: ${_routeController.text}");
      print("Puerta: ${_gateController.text}");
      print("Tipo: ${_typeController.text}");
      print("Fecha: ${_dateController.text}"); // Este es el texto que el usuario ha ingresado
      print("Usuario: ${_userController.text}");

      // Imprime el objeto DateTime para verificar que se está convirtiendo correctamente
      print("Fecha convertida: $date");

      CarrierModel? response = await carrierViewModel.insert(
        _placaController.text,
        int.parse(_occupantController.text),
        _dniController.text,
        _driverController.text,
        _routeController.text,
        _gateController.text,
        _typeController.text,
        _dateController.text,
        int.parse(_userController.text),
      );

      print("response: ${jsonEncode(response)}");

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
    _gateController.clear();
    _typeController.clear();
    _dateController.clear();
    _userController.clear();
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
        child: SingleChildScrollView(
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
              _buildTextField("Placa", _placaController),
              const SizedBox(height: 20),
              _buildTextField("Número de pasajeros", _occupantController),
              const SizedBox(height: 20),
              _buildTextField("DNI", _dniController),
              const SizedBox(height: 20),
              _buildTextField("Nombre del Conductor", _driverController),
              const SizedBox(height: 20),
              _buildTextField("Ruta", _routeController),
              const SizedBox(height: 20),
              _buildTextField("Puerta", _gateController),
              const SizedBox(height: 20),
              _buildTextField("Tipo", _typeController),
              const SizedBox(height: 20),
              _buildTextField("Fecha (dd/mm/yyyy)", _dateController),
              const SizedBox(height: 20),
              _buildTextField("Usuario", _userController),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: carrierViewModel.isLoading ? null : () => _sendData(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: carrierViewModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Enviar",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      ),
    );
  }
}
