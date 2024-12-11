import 'package:aida/viewmodel/auth_viewmodel.dart';
import 'package:aida/viewmodel/securitics/booking_viewmodel.dart';
import 'package:flutter/material.dart';
import '../../widgets/navbar_widget_securitics.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingHomePage extends StatefulWidget {
  const BookingHomePage({Key? key}) : super(key: key);

  @override
  State<BookingHomePage> createState() => _BookingHomeState();
}

class _BookingHomeState extends State<BookingHomePage> {
  final TextEditingController _search = TextEditingController();

  String zoneName = '';
  String cultive = '';

  List<Map<String, dynamic>> filteredBookings = [];

  Future<void> _loadBooking(BookingViewModel bookingViewModel) async {
    if (zoneName.isNotEmpty && cultive.isNotEmpty) {
      try {
        await bookingViewModel.fetchBooking(cultive, zoneName);
        setState(() {
          filteredBookings = bookingViewModel.bookings;
        });
      } catch (e) {
        print("Error: error al obtener los bookings: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookingViewModel =
          Provider.of<BookingViewModel>(context, listen: false);
      _loadBooking(bookingViewModel);
    });

    _search.addListener(_filterBookings);
  }

  void _filterBookings() {
    final bookingViewModel =
        Provider.of<BookingViewModel>(context, listen: false);
    final query = _search.text.trim().toLowerCase();

    setState(() {
      filteredBookings = bookingViewModel.bookings.where((booking) {
        final bookingName =
            (booking['Booking'] ?? 'Sin Nombre').toLowerCase().trim();

        if (bookingName == query) {
          return true;
        }

        final normalizedQuery = _normalizeString(query);
        final normalizedBookingName = _normalizeString(bookingName);

        return normalizedBookingName.contains(normalizedQuery);
      }).toList();

      filteredBookings.sort((a, b) {
        final bookingA = (a['Booking'] ?? '').toLowerCase().trim();
        final bookingB = (b['Booking'] ?? '').toLowerCase().trim();

        if (bookingA == query) return -1;
        if (bookingB == query) return 1;
        return bookingA.compareTo(bookingB);
      });
    });
  }

// Normaliza una cadena eliminando acentos y caracteres especiales
  String _normalizeString(String input) {
    return input
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll(RegExp(r'[ñ]'), 'n')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final bookingViewModel = Provider.of<BookingViewModel>(context);

    if (arguments != null) {
      cultive = (arguments['cultive'] ?? 'Desconocido').toString();
      zoneName = (arguments['zone'] ?? 'Desconocido').toString();
    }

    final authViewModel = Provider.of<AuthViewModel>(context);
    final fullName = authViewModel.fullName ?? 'Usuario';

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: TopNavBarScreen(),
      ),
      bottomNavigationBar: const BottomNavBarScreen(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade800,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName.toUpperCase(),
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white,
                          letterSpacing: 0.51,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "SEGURIDAD PATRIMONIAL",
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white70,
                          letterSpacing: 0.51,
                        ),
                      ),
                      Text(
                        "${zoneName.toUpperCase()} [ ${cultive.toUpperCase()} ]",
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                          letterSpacing: 0.51,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20), // Margen superior
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final arguments = {
                        'cultive': cultive,
                        'zone': zoneName,
                      };

                      Navigator.pushNamed(context, '/new-booking',
                          arguments: arguments);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(110, 60),
                      maximumSize: const Size(110, 60),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16, color: Colors.white),
                        SizedBox(height: 4),
                        Text(
                          'BOOKING',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8), // Espacio entre botones
                  ElevatedButton(
                    onPressed: () {
                      if (!bookingViewModel.isLoading) {
                        _loadBooking(bookingViewModel);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      backgroundColor: Colors.grey,
                      // Color del botón
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Borde redondeado mínimo
                      ),
                      minimumSize: const Size(100, 60),
                      maximumSize: const Size(100, 60),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sync, size: 16, color: Colors.white),
                        SizedBox(height: 4),
                        // Espacio entre el icono y el texto
                        Text(
                          'SYNC',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 400,
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),

                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 12.0),
                hintText: "Busqueda avanzada...",
                // Añadido hintText para guía de entrada
                hintStyle: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.grey,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                print("Nombre del Contenedor: $value");
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                final booking = bookingViewModel.bookings[index];

                return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: InkWell(
                      onTap: () {
                        final arguments = {
                          'cultive': cultive,
                          'zone': zoneName,
                        };

                        Navigator.pushNamed(context, '/container-home',
                            arguments: arguments);
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.fire_truck_outlined,
                          size: 25,
                          color: Colors.red,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking['Booking'] ?? 'Sin Nombre',
                              style: GoogleFonts.raleway(
                                fontSize: 18,
                                letterSpacing: 0.65,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 0.2),
                            Text(
                              'Linea de Negocio: ${booking["Cultivo"] ?? "Sin Nombre"}',
                              style: GoogleFonts.raleway(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
