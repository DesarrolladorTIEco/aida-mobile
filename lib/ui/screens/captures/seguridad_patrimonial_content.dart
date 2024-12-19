import 'package:aida/viewmodel/auth_viewmodel.dart';
import 'package:aida/viewmodel/captures/container_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aida/core/utils/camera_container.dart';
import 'package:aida/viewmodel/captures/booking_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SeguridadPatrimonialContenidoMenu extends StatefulWidget {
  const SeguridadPatrimonialContenidoMenu({Key? key}) : super(key: key);

  @override
  State<SeguridadPatrimonialContenidoMenu> createState() =>
      _SeguridadPatrimonialMenuState();
}

class _SeguridadPatrimonialMenuState
    extends State<SeguridadPatrimonialContenidoMenu> {
  final CameraContainer _cameraContainer = CameraContainer();
  String container = '';
  String booking = '';

  String title = '';
  String zoneName = '';
  String cultive = '';

  String path = '';
  String utilPath = '';

  num bkId = 0;
  num cntId = 0;


  Future<void> _getPath(BuildContext context) async {
    final now = DateTime.now();

    final String formattedZoneName =
        zoneName.toLowerCase().replaceAll(' ', '_');
    final String formattedCultive = cultive.toLowerCase();

    final String year = now.year.toString();
    final String month =
        DateFormat('MMM').format(now).toLowerCase();
    final String day = now.day.toString();

    final String bookingFormatted = booking.replaceAll("N° ", "").toLowerCase();

    final String titleFormatted = title.toLowerCase().replaceAll(' ', '_');

    setState(() {
      path =
          '${dotenv.get('MY_PATH', fallback: 'Ruta no disponible')}$formattedZoneName\\\\$formattedCultive\\\\$year\\\\$month\\\\$day\\\\$bookingFormatted\\\\$container\\\\$titleFormatted';
    });
  }

  Future<void> _save(BuildContext context) async {
    final bookingViewModel =
        Provider.of<BookingViewModel>(context, listen: false);

    final userID = Provider.of<AuthViewModel>(context, listen: false).userID;
    final int parsedUserID =
        int.tryParse(userID.trim()) ?? 0;


    final now = DateTime.now();
    final String formattedZoneName =
        zoneName.toLowerCase().replaceAll(' ', '_');
    final String formattedCultive = cultive.toLowerCase();
    final String year = now.year.toString();
    final String month = DateFormat('MMM').format(now).toLowerCase();
    final String day = now.day.toString();
    final String bookingFormatted = booking.replaceAll("N° ", "").toLowerCase();

    setState(() {
      path =
          '${dotenv.get('MY_PATH', fallback: 'Ruta no disponible')}$formattedZoneName\\\\$formattedCultive\\\\$year\\\\$month\\\\$day\\\\$bookingFormatted\\\\$container'
              .replaceAll('\\\\', '\\')
              .trim();
    });

    print(bkId);
    print(cntId);
    print(parsedUserID);
    print(path);

    try {
      bookingViewModel.isLoading = true;
      bookingViewModel.notifyListeners();

      String? response = await bookingViewModel.saveCaptures(bkId, cntId, parsedUserID, path);

      print(response);

      if (response != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Alerta"),
              content: Text(response),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cerrar"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error  $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Error: ${e.toString()}"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cerrar"),
              ),
            ],
          );
        },
      );
    } finally {
      // Restablecer el estado de carga
      bookingViewModel.isLoading = false;
      bookingViewModel.notifyListeners();
    }
  }

  Future<void> _loadUtils(ContainerViewModel containerViewModel) async {
    try {
      await containerViewModel.checkPhotoCountAll(bkId, cntId, utilPath.replaceAll('\\\\', '\\').trim());

      var apiResponse = containerViewModel.partStatus;
      print(apiResponse);

      if(apiResponse != null && apiResponse.isNotEmpty) {
      }

    } catch (e) {
      print("Error: error al obtener los contenedores: $e");
    }
  }

  String _formatPartName(String part) {
    switch (part) {
      case 'inspeccion_externa':
        return 'Inspección Externa';
      case 'precintos':
        return 'Precintos';
      default:
        return part; // Si no hay un formato específico, retorna el nombre tal cual
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final containerViewModel =
      Provider.of<ContainerViewModel>(context, listen: false);
      _loadUtils(containerViewModel);
    });
  }


  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      cultive = (arguments['cultive'] ?? 'Desconocido').toString();
      zoneName = (arguments['zone'] ?? 'Desconocido').toString();

      booking = (arguments['booking'] ?? 'Desconocido').toString();

      container = (arguments['container'] ?? 'Desconocido').toString();

      utilPath = (arguments['utilPath'] ?? 'Desconocido').toString();


      var bkIdValue = arguments['bkId'];
      bkId =
          (bkIdValue is String) ? num.tryParse(bkIdValue) ?? 0 : bkIdValue ?? 0;

      var cntIdValue = arguments['cntId'];
      cntId = (cntIdValue is String)
          ? num.tryParse(cntIdValue) ?? 0
          : cntIdValue ?? 0;
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 50, left: 12, right: 12, bottom: 20),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'CONTENEDOR: ${container.toUpperCase()}',
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                          letterSpacing: 0.51,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.white70, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            "seleccionar opción",
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.white70,
                              letterSpacing: 0.51,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: InkWell(
                    onTap: () {
                      print("booking $booking");

                      final arguments = {
                        'container': container,
                        'bkId': bkId,
                        'cntId': cntId,
                        'zone': zoneName,
                        'cultive': cultive,
                        'booking': booking,
                        'utilPath' : utilPath
                      };

                      print(arguments);
                      if (index == 0) {
                        Navigator.pushNamed(context, '/seguridad-inspeccion',
                            arguments: arguments);
                      } else if (index == 1) {
                        Navigator.pushNamed(context, '/seguridad-precintos',
                            arguments: arguments);
                      }
                    },
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                index == 0 ? 'Inspección Externa' : 'Precintos',
                                style: GoogleFonts.raleway(
                                  fontSize: 18,
                                  letterSpacing: 0.65,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (index == 0) {
                                title = 'INSPECCION EXTERNA';
                              } else if (index == 1) {
                                title = 'PRECINTOS';
                              }

                              await _getPath(context);


                              final arguments = {
                                'url': path,
                              };

                              Navigator.pushNamed(
                                context,
                                '/general-gallery',
                                arguments: arguments,
                              );
                            },
                            child: Icon(
                              Icons.photo_library_outlined,
                              size: 25,
                              color: Colors.red.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _save(context);
        },
        backgroundColor: Colors.red.shade800,
        icon: const Icon(Icons.save, color: Colors.white),
        label: Text(
          "GUARDAR",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
