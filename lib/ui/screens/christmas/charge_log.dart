import 'package:flutter/material.dart';
import '../../widgets/navbar_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class ChageScreen extends StatefulWidget {
  const ChageScreen({super.key});

  @override
  _ChageScreenState createState() => _ChageScreenState();
}

class _ChageScreenState extends State<ChageScreen> {
  // Lista de objetos que contienen nombres y DNIs
  final List<Map<String, String>> _people = [
    {"name": "Joys Navarro Adanaque", "dni": "12345678"},
    {"name": "Jhon Soto Navarro", "dni": "23456789"},
    {"name": "Jackson Alfaro Correa", "dni": "34567890"},
    {"name": "Marlon Chira Correa", "dni": "45678901"},
    {"name": "María Pérez Gonzales", "dni": "56789012"},
    {"name": "Marco Soto Gonzales", "dni": "67890123"},
    {"name": "Carlos Ramírez Salas", "dni": "78901234"},
  ];

  DateTime? _selectedDate;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: const TopNavBarScreen(),
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

            // DatePicker como combobox
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
                          : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                      style: GoogleFonts.raleway(fontSize: 14),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // TextField para escanear código QR
            TextField(
              decoration: InputDecoration(
                labelText: "Buscar por DNI",
                labelStyle: GoogleFonts.raleway(
                    fontSize: 14, fontWeight: FontWeight.w600),
                prefixIcon: const Icon(Icons.qr_code_scanner),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 22.0, horizontal: 16.0),
              ),
            ),

            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Entregados: 40",
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Saldo: 20",
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
                padding: const EdgeInsets.only(top: 0),
                itemCount: _people.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: const Icon(Icons.person,
                          size: 40, color: Colors.grey),
                      title: Text(
                        _people[index]["name"]!,
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        _people[index]["dni"]!,
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
