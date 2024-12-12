import 'package:aida/viewmodel/christmas/worker_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/navbar_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  DateTime? _selectedDate;

  Future<void> _loadWorkers(WorkerViewModel workerViewModel) async {
    if (_selectedDate != null) {
      final date = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      try {
        await workerViewModel.fetchStock(date);
      } catch (e) {
        print("Error al obtener los trabajadores: $e");
      }
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
    final workerViewModel =
    Provider.of<WorkerViewModel>(context, listen: false);
    await _loadWorkers(workerViewModel);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workerViewModel =
      Provider.of<WorkerViewModel>(context, listen: false);
      workerViewModel.clearWorkers();
    });
  }

  /// Nueva función para calcular la suma total de 'Entregados'
  int _calculateTotalEntregados(List<Map<String, dynamic>> workers) {
    return workers.fold<int>(
      0,
          (sum, worker) => sum + (int.tryParse(worker['Entregados']?.toString() ?? '0') ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workerViewModel = Provider.of<WorkerViewModel>(context);

    // Calcular la suma total de "Entregados"
    final totalEntregados = _calculateTotalEntregados(workerViewModel.workers);

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
              "Lista responsable stock",
              style: GoogleFonts.raleway(
                fontSize: 16,
                letterSpacing: 0.22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),


            GestureDetector(
              onTap: () => _selectDate(context),
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
                      _selectedDate == null
                          ? "Seleccionar Fecha"
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      style: GoogleFonts.raleway(fontSize: 14),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),




            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Entregados: $totalEntregados",
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: workerViewModel.workers.length,
                itemBuilder: (context, index) {
                  final worker = workerViewModel.workers[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: const Icon(Icons.person,
                          size: 40, color: Colors.grey),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worker['Responsable'] ?? 'Sin nombre',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Entregados: ${worker['Entregados'] ?? 'No disponible'}',
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Saldo: ${worker['Saldo'] ?? 'No disponible'}',
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        'DNI: ${worker['Dni']}',
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
