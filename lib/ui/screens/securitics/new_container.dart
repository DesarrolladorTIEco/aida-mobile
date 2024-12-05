import 'package:aida/data/models/securitics/container_model.dart';
import 'package:aida/viewmodel/auth_viewmodel.dart';
import 'package:aida/viewmodel/securitics/container_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widgets/navbar_widget_securitics.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewContainerPage extends StatefulWidget {
  const NewContainerPage({Key? key}) : super(key: key);

  @override
  State<NewContainerPage> createState() => _NewContainerState();
}

class _NewContainerState extends State<NewContainerPage> {
  final TextEditingController _lineaNegocio = TextEditingController();
  final TextEditingController _today = TextEditingController();
  final TextEditingController _newContainer = TextEditingController();

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

    final containerViewModel =
        Provider.of<ContainerViewModel>(context, listen: false);

    final now = DateTime.now();
    final String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now);

    final String formattedZoneName = zoneName.toLowerCase().replaceAll(' ', '_');
    final String formattedCultive = cultive.toLowerCase();

    final String year = now.year.toString();
    final String month = DateFormat('MMM').format(now).toLowerCase(); // Formato de 3 letras
    final String day = now.day.toString();

    final String container = _newContainer.text;

    final String path =
        '${dotenv.get('MY_PATH', fallback: 'Ruta no disponible')}$formattedZoneName\\$formattedCultive\\$year\\$month\\$day\\$container';

    containerViewModel.isLoading = true;
    containerViewModel.notifyListeners();

    try {
      ContainerModel? response = await containerViewModel.insert(
          _newContainer.text,
          cultive,
          zoneName,
          formattedDate,
          parsedUserID,
          path);
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

                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, '/home-sec',
                          arguments: arguments); // Redirige a /home-sec
                    },
                    child: const Text("Aceptar"),
                  ),
                ],
              );
            });
        _clearFields();
      } else {
        throw Exception(containerViewModel.errorMessage);
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
      containerViewModel.isLoading = false;
      containerViewModel.notifyListeners();
    }
  }

  void _clearFields() {
    _newContainer.clear();
  }

  bool _validateFields() {
    if (cultive.isEmpty || zoneName.isEmpty || _newContainer.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "¡Debe completar todos los campos!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return false;
    } else if (_newContainer.text.length > 11) {
      Fluttertoast.showToast(
        msg: "El contenedor no debe tener más de 11 carácteres",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    final containerViewModel = Provider.of<ContainerViewModel>(context);
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
                    "Información del Contenedor",
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
                      controller: _newContainer,
                      // Controlador para escribir el nombre del contenedor
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
                        hintText: "Nombre Contenedor",
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
                            "Nombre del Contenedor: $value"); // Para verificar si captura el valor
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: containerViewModel.isLoading
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
                          'AGREGAR CONTENEDOR',
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
