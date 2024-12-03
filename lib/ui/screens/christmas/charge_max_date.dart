import 'package:aida/core/utils/scanner_qr.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../widgets/navbar_widget.dart';
import 'package:aida/viewmodel/christmas/worker_viewmodel.dart'; // Worker ViewModel

class ChargeDateScreen extends StatefulWidget {
  const ChargeDateScreen({super.key});

  @override
  _ChargeDateScreenState createState() => _ChargeDateScreenState();
}

class _ChargeDateScreenState extends State<ChargeDateScreen> {
  final TextEditingController _dniController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  // Fetch workers based on the selected DNI and date
  Future<void> _loadWorkers(WorkerViewModel workerViewModel) async {
    final dni = _dniController.text.trim(); // Get entered DNI
    if (dni.isNotEmpty && dni.length == 8 && _startDate != null && _endDate != null) {
      final startDate = _startDate!
          .toIso8601String()
          .split('T')
          .first;

      final endDate = _endDate!
          .toIso8601String()
          .split('T')
          .first;
      try {
        await workerViewModel.fetchWorkersByRange(dni, startDate, endDate);
      } catch (e) {
        print("Error: Error al obtener los trabajadores: $e");
      }
    }
  }

  // Handle QR scan
  Future<void> _handleQrScan(WorkerViewModel workerViewModel) async {
    await QRScanner.scanQRCode(
      context: context,
      onCodeScanned: (String code) async {
        if (code.isNotEmpty) {
          _dniController.text = code;
          await _loadWorkers(workerViewModel);
        }
      },
    );
  }
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _dniController.clear();
        final workerViewModel = Provider.of<WorkerViewModel>(context, listen: false);
        workerViewModel.clearWorkers();
      });
    }
  }

  // Function to select end date
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _dniController.clear();
        final workerViewModel = Provider.of<WorkerViewModel>(context, listen: false);
        workerViewModel.clearWorkers();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workerViewModel = Provider.of<WorkerViewModel>(
          context, listen: false);
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

            GestureDetector(
              onTap: () => _selectStartDate(context),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _startDate == null
                          ? "Seleccionar Fecha"
                          : "${_startDate!.year}-${_startDate!.month
                          .toString().padLeft(2, '0')}-${_startDate!.day
                          .toString().padLeft(2, '0')}",
                      style: GoogleFonts.raleway(fontSize: 14),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),

              ),
            ),

            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectEndDate(context),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _endDate == null
                          ? "Seleccionar Fecha"
                          : "${_endDate!.year}-${_endDate!.month
                          .toString().padLeft(2, '0')}-${_endDate!.day
                          .toString().padLeft(2, '0')}",
                      style: GoogleFonts.raleway(fontSize: 14),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),

              ),
            ),

            const SizedBox(height: 20),

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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Entregados: ${workerViewModel.workers.length}",
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: workerViewModel.workers.length,
                itemBuilder: (context, index) {
                  final worker = workerViewModel.workers[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: const Icon(
                          Icons.person, size: 40, color: Colors.grey),
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
                            'Planilla: ${worker['Planilla'] ??
                                'No disponible'}',
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Fecha de Creación: ${worker['FechaCreacion'] ??
                                'No disponible'}',
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