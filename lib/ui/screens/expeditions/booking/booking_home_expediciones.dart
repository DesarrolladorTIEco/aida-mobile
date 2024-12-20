import 'package:aida/viewmodel/auth_viewmodel.dart';
import 'package:aida/viewmodel/captures/booking_viewmodel.dart';
import 'package:flutter/material.dart';
import '../../../widgets/navbar_widget_securitics.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookingHomeExpedicionesPage extends StatefulWidget {
  const BookingHomeExpedicionesPage({Key? key}) : super(key: key);

  @override
  State<BookingHomeExpedicionesPage> createState() => _BookingHomeExpedicionesState();
}

class _BookingHomeExpedicionesState extends State<BookingHomeExpedicionesPage> {
  final TextEditingController _search = TextEditingController();
  final TextEditingController _date = TextEditingController();

  String zoneName = '';
  String cultive = '';
  String subTitle = '';

  String selectedOption = 'BOOKING';

  List<Map<String, dynamic>> filteredBookings = [];
  List<Map<String, dynamic>> allBookings = [];


  Future<void> _loadBooking(BookingViewModel bookingViewModel) async {
    if (zoneName.isNotEmpty && cultive.isNotEmpty) {
      try {
        final parsedDate = DateFormat('dd/MM/yyyy').parse(_date.text);
        final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

        if (selectedOption == 'BOOKING') {
          await bookingViewModel.fetchBooking(cultive, zoneName, formattedDate);
        } else if (selectedOption == 'BOOKING TERMINADO') {
          await bookingViewModel.fetchBookingTerminado(
              cultive, zoneName, formattedDate);
        }

        setState(() {
          allBookings = bookingViewModel.bookings;
          filteredBookings = List.from(allBookings);
        });
      } catch (e) {
        print("Error: error al obtener los bookings: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _date.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookingViewModel =
      Provider.of<BookingViewModel>(context, listen: false);
      _loadBooking(bookingViewModel);
    });
  }

  void _filterBookings(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredBookings = List.from(allBookings);
      } else {
        filteredBookings = allBookings.where((booking) {
          final bookingName = booking['Booking']?.toLowerCase() ?? '';
          return bookingName.contains(lowerQuery);
        }).toList();
      }
    });
  }


  Future<void> _onDateChanged() async {
    final bookingViewModel =
    Provider.of<BookingViewModel>(context, listen: false);

    if (zoneName.isNotEmpty && cultive.isNotEmpty) {
      try {
        final parsedDate = DateFormat('dd/MM/yyyy').parse(_date.text);
        final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

        if (selectedOption == 'BOOKING') {
          await bookingViewModel.fetchBooking(cultive, zoneName, formattedDate);
        } else if (selectedOption == 'BOOKING TERMINADO') {
          await bookingViewModel.fetchBookingTerminado(
              cultive, zoneName, formattedDate);
        }

        setState(() {
          allBookings = bookingViewModel.bookings;
          filteredBookings = List.from(allBookings);
        });
      } catch (e) {
        print("Error: error al cargar datos tras cambiar la fecha: $e");
      }
    } else {
      print("Zona o cultivo vacío: no se puede cargar datos.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>?;

    final bookingViewModel = Provider.of<BookingViewModel>(context);

    if (arguments != null) {
      cultive = (arguments['cultive'] ?? 'Desconocido').toString();
      zoneName = (arguments['zone'] ?? 'Desconocido').toString();
      subTitle = (arguments['subtitle'] ?? 'Expediciones').toString();
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
                        subTitle.toUpperCase(),
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white70,
                          letterSpacing: 0.51,
                        ),
                      ),
                      Text(
                        "${zoneName.toUpperCase()} [ ${cultive
                            .toUpperCase()} ]",
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
          const SizedBox(height: 12),

          SizedBox(
            width: 400,
            child: TextField(
              controller: _date,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: const Icon(
                  Icons.calendar_today, // Calendar icon
                  color: Colors.grey, // You can customize the color
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 12.0,
                ),
                hintText: "Seleccione una fecha...",
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
              keyboardType: TextInputType.none,
              onTap: () async {
                DateTime initialDate = DateFormat('dd/MM/yyyy').parse(
                    _date.text.isEmpty ? DateFormat('dd/MM/yyyy').format(
                        DateTime.now()) : _date.text);

                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (selectedDate != null) {
                  _date.text = DateFormat('dd/MM/yyyy').format(selectedDate);

                  await _onDateChanged();
                }
              },
            ),
          ),


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
              onChanged: (value) => _filterBookings(value),

            ),
          ),


          const SizedBox(height: 12),


          Container(
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                // Opción BOOKING
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = 'BOOKING';
                      });
                      print('BOOKING seleccionado');
                      _loadBooking(
                          bookingViewModel); // Carga los datos después de seleccionar
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedOption == 'BOOKING'
                            ? Colors.red // Fondo rojo si está seleccionado
                            : Colors.transparent,

                        // Fondo transparente si no está seleccionado
                        borderRadius: BorderRadius.circular(
                            4.0), // Opcional: redondea esquinas
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          'BOOKING',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            fontWeight: selectedOption == 'BOOKING'
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: selectedOption == 'BOOKING'
                                ? Colors
                                .white // Texto blanco si está seleccionado
                                : Colors.grey[
                            700], // Texto gris si no está seleccionado
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Opción BOOKING TERMINADO
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = 'BOOKING TERMINADO';
                      });
                      print('BOOKING TERMINADO seleccionado');
                      _loadBooking(
                          bookingViewModel); // Carga los datos después de seleccionar
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedOption == 'BOOKING TERMINADO'
                            ? Colors.red // Fondo rojo si está seleccionado
                            : Colors.transparent,
                        // Fondo transparente si no está seleccionado
                        borderRadius: BorderRadius.circular(
                            4.0), // Opcional: redondea esquinas
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          'BOOKING TERMINADO',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            fontWeight: selectedOption == 'BOOKING TERMINADO'
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: selectedOption == 'BOOKING TERMINADO'
                                ? Colors
                                .white // Texto blanco si está seleccionado
                                : Colors.grey[
                            700], // Texto gris si no está seleccionado
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1.0, thickness: 1.0), // Línea divisora
          const SizedBox(height: 6),

          Expanded(
            child: ListView.builder(
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                final booking = filteredBookings[index];
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: InkWell(
                    onTap: () {
                      final arguments = {
                        'cultive': cultive,
                        'zone': zoneName,
                        'bkId': booking["bkId"],
                        'booking': booking["Booking"],
                      };

                      Navigator.pushNamed(context, '/container-home',
                          arguments: arguments);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon and text column
                        Expanded(
                          flex: 3,
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
                                const SizedBox(height: 4.0),
                                Text(
                                  'Linea de Negocio: ${booking["Cultivo"] ??
                                      "Sin Nombre"}',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Circles and labels column
                        // Circles and labels column
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 12.0),
                                    // Mueve todo el contenido hacia abajo
                                    child: Column(
                                      children: [
                                        Text(
                                          'S.P',
                                          style: GoogleFonts.raleway(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        // Espacio entre texto y círculo
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: booking[
                                            'IsSeguridadPatrimonial'] ==
                                                "1"
                                                ? Colors.green // Verde si es 1
                                                : Colors.red, // Rojo si es 0
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 12.0),
                                    // Mueve todo el contenido hacia abajo
                                    child: Column(
                                      children: [
                                        Text(
                                          'EXP',
                                          style: GoogleFonts.raleway(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        // Espacio entre texto y círculo
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: booking['IsExpediciones'] ==
                                                "1"
                                                ? Colors.green // Verde si es 1
                                                : Colors.red, // Rojo si es 0
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
