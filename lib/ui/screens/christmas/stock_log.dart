import 'package:flutter/material.dart';
import '../../widgets/navbar_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final List<Map<String, String>> _people = [
    {
      "name": "Joys Navarro Adanaque",
      "dni": "12345678",
      "entregadas": "40",
      "saldo": "35"
    },
    {
      "name": "Jhon Soto Navarro",
      "dni": "23456789",
      "entregadas": "77",
      "saldo": "115"
    },
    {
      "name": "Jackson Alfaro Correa",
      "dni": "34567890",
      "entregadas": "124",
      "saldo": "53"
    },
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
              "Lista responsable stock",
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
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _people[index]["name"] as String,
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "DNI: ${_people[index]["dni"]}",
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Entregadas: ${_people[index]["entregadas"]}",
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Saldo: ${_people[index]["saldo"]}",
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
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
