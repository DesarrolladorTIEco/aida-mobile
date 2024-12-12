import 'package:aida/data/models/captures/booking_model.dart';
import 'package:aida/viewmodel/auth_viewmodel.dart';
import 'package:aida/viewmodel/captures/booking_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../widgets/navbar_widget_securitics.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewBookingPage extends StatefulWidget {
  const NewBookingPage({Key? key}) : super(key: key);

  @override
  State<NewBookingPage> createState() => _NewBookingState();
}

class _NewBookingState extends State<NewBookingPage> {
  final TextEditingController _lineaNegocio = TextEditingController();
  final TextEditingController _today = TextEditingController();
  final TextEditingController _newBooking = TextEditingController();

  String zoneName = '';
  String cultive = '';

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
    final int parsedUserID =
        int.tryParse(userID.trim()) ?? 0;

    final bookingViewModel =
        Provider.of<BookingViewModel>(context, listen: false);

    final now = DateTime.now();
    final String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now);


    bookingViewModel.isLoading = true;
    bookingViewModel.notifyListeners();

    try {
      BookingModel? response = await bookingViewModel.insert(
          _newBooking.text,
          cultive,
          zoneName,
          formattedDate,
          parsedUserID
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
                      final arguments = {
                        'cultive': cultive,
                        'zone': zoneName,
                      };

                      Navigator.pushReplacementNamed(context, '/booking-home',
                          arguments: arguments);
                    },
                    child: const Text("Aceptar"),
                  ),
                ],
              );
            });
        _clearFields();
      } else {
        throw Exception(bookingViewModel.errorMessage);
      }
    } catch (e) {
      print("Error en _sendData: $e"); // Depura cualquier error aquí
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      bookingViewModel.isLoading = false;
      bookingViewModel.notifyListeners();
    }
  }

  void _clearFields() {
    _newBooking.clear();
  }

  bool _validateFields() {
    if (cultive.isEmpty || zoneName.isEmpty || _newBooking.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "¡Debe completar todos los campos!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return false;
    } else if (_newBooking.text.length > 10) {
      Fluttertoast.showToast(
        msg: "El booking no debe tener más de 10 carácteres",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    final bookingViewModel = Provider.of<BookingViewModel>(context);
    _today.text = formattedDate;

    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Información del Booking",
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                      letterSpacing: 0.51,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Espacio entre el título y el primer TextField

                  // Primer TextField
                  SizedBox(
                    width: 400,
                    child: TextField(
                      controller: _lineaNegocio,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.raleway(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.error_outline),
                          onPressed: () => print("test"),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 12.0),
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 38.0),
                              child: Text(
                                "Linea Negocio",
                                style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Text(
                                cultive.toUpperCase(),
                                style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  // Segundo TextField
                  SizedBox(
                    width: 400,
                    child: TextField(
                      controller: _today, // Controlador añadido aquí
                      readOnly: true,
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.raleway(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.error_outline),
                          onPressed: () => print("test"),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 12.0),
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 38.0),
                              child: Text(
                                "Fecha Actual",
                                style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Text(
                                formattedDate,
                                style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: 400,
                    child: TextField(
                      controller: _newBooking,
                      // Controlador para escribir el nombre del booking
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.fire_truck_outlined),
                          onPressed: () => print("test"),
                          color: Colors.red.shade800,
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 12.0),
                        hintText: "Nombre Booking",
                        // Añadido hintText para guía de entrada
                        hintStyle: GoogleFonts.raleway(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        print(
                            "Nombre del Booking: $value"); // Para verificar si captura el valor
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: bookingViewModel.isLoading
                        ? null
                        : () => _sendData(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      backgroundColor: Colors.orange.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(400, 60),
                      maximumSize: const Size(400, 60),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Centra el contenido
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        const Icon(Icons.add, size: 25, color: Colors.white),
                        const SizedBox(width: 8),
                        // Espacio entre el icono y el texto
                        Text(
                          'AGREGAR BOOKING',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
