import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importar para usar los inputFormatters
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/auth_viewmodel.dart';
import 'package:aida/core/utils/scanner_qr.dart';
import '../../../viewmodel/carriers/carrier_viewmodel.dart';
import '../../../data/models/carriers/carrier_model.dart';
import '../../widgets/navbar_widget.dart';
import 'package:intl/intl.dart';
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
  bool _scanned = false;
  String? _initialScannedValue;

  @override
  void initState() {
    super.initState();
    _placaController.addListener(_handlePlacaChange);
  }

  @override
  void dispose() {
    _placaController.removeListener(_handlePlacaChange);
    _placaController.dispose();
    _dniController.dispose();
    _occupantController.dispose();
    _driverController.dispose();
    _routeController.dispose();
    _seatNumberController.dispose();
    super.dispose();
  }

  void _handlePlacaChange() {
    if (_scanned && _initialScannedValue != _placaController.text) {
      setState(() {
        _scanned = false; // Cambiar a RM
      });
    }
  }

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

    return true;
  }

  void _clearFields() {
    _placaController.clear();
    _occupantController.clear();
    _dniController.clear();
    _driverController.clear();
    _routeController.clear();
    _seatNumberController.clear();
    _scanned = false;
  }

  void _scanQRCode(BuildContext context) {
    QRScanner.scanQRCode(
      context: context,
      onCodeScanned: (String code) {
        setState(() {
          _placaController.text = code;
          _scanned = true;
          _initialScannedValue = code; // Guardar el valor escaneado
        });
      },
    );
  }


  Widget _buildTextField(String label, TextEditingController controller,
      {Widget? suffixIcon, TextInputType? keyboardType, List<TextInputFormatter>? inputFormatters, int? maxLength}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
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
            const SizedBox(height: 20),
            _buildTextField(
              "DNI",
              _dniController,
              maxLength: 8,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              "Conductor",
              _driverController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              "Ocupantes",
              _occupantController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              "Cantidad Asientos",
              _seatNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton.icon(
                  onPressed: carrierViewModel.isLoading ? null : () => _sendData(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.save),
                  label: Text(
                    "Registrar Transportista",
                    style: GoogleFonts.raleway(
                      color: Colors.white,  // Puedes cambiar el color si lo deseas
                      fontSize: 16,          // Ajusta el tamaño del texto si es necesario
                      fontWeight: FontWeight.bold,  // Puedes ajustar el peso de la fuente
                    ),
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
