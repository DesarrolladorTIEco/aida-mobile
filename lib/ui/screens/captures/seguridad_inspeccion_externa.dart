import 'package:aida/data/models/captures/photo_model.dart';
import 'package:aida/viewmodel/auth_viewmodel.dart';
import 'package:aida/viewmodel/captures/photo_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aida/core/utils/camera_container.dart';
import 'package:provider/provider.dart';

class SeguridadInspeccionExternaMenu extends StatefulWidget {
  const SeguridadInspeccionExternaMenu({Key? key}) : super(key: key);

  @override
  State<SeguridadInspeccionExternaMenu> createState() =>
      _SeguridadInspeccionExternaState();
}

class _SeguridadInspeccionExternaState extends State<SeguridadInspeccionExternaMenu> {
  final CameraContainer _cameraContainer =  CameraContainer();

  //DECLARAMOS VARIABLES
  String container = '';
  String title = 'INSPECCIÓN EXTERNA';
  num bkId = 0;
  num cntId = 0;


  final titles = [
    'Interchange (EIR)',
    'Panorámica',
    'Parte Delantera Contenedor',
    'Parte Posterior Contenedor',
    'Placa Contenedor',
    'Lado Derecho Contenedor',
    'Lado Izquierdo Contenedor',
    'Parches'
  ];

  Future<void> _sendData(BuildContext context, String dynamicTitle) async {
    final userID = Provider.of<AuthViewModel>(context, listen: false).userID;
    final int parsedUserID = int.tryParse(userID.trim()) ?? 0;
    final photoViewModel = Provider.of<PhotoViewModel>(context, listen: false);

    photoViewModel.isLoading = true;

    String path =
        r'\\10.10.100.26\Seguridad_Proyecto\medlog\conserva\2024\dec\13\N°111111\{$container}\inspeccion_externa\panorámica\';

    try {

      // await _cameraContainer.openCamera(context, path);
      print(bkId);
      PhotoModel? response =
      await photoViewModel.insert(bkId, cntId, title.toLowerCase(), dynamicTitle.toLowerCase(), path, parsedUserID);

    } catch (e) {
      print("Error en _sendData: $e"); // Depura cualquier error aquí
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      photoViewModel.isLoading = false;
      photoViewModel.notifyListeners();
    }
  }

  List<bool> isChecked = List.generate(8, (index) => false);
  bool isListEnabled = false;

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      container = (arguments['container'] ?? 'Desconocido').toString();

      var bkIdValue = arguments['bkId'];
      bkId = (bkIdValue is String) ? num.tryParse(bkIdValue) ?? 0 : bkIdValue ?? 0;

      var cntIdValue = arguments['cntId'];
      cntId = (cntIdValue is String) ? num.tryParse(cntIdValue) ?? 0 : cntIdValue ?? 0;
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
                        title,
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
                          const Icon(
                            Icons.warning_amber_rounded, // Icono de advertencia
                            color: Colors.white70, // Color del icono
                            size: 20, // Tamaño del icono
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "tomar fotos del contenedor",
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
              itemCount: titles.length,
              itemBuilder: (context, index) {
                bool isParches = titles[index] == 'Parches';

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
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
                              titles[index],
                              style: GoogleFonts.raleway(
                                fontSize: 16.8,
                                letterSpacing: 0.65,
                                fontWeight: FontWeight.w600,
                                color: isParches && !isChecked[index]
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                String dynamicTitle = titles[index];
                                await _sendData(context, dynamicTitle);
                              },
                              child: Icon(
                                Icons.photo_camera,
                                size: 25,
                                color: isParches && !isChecked[index]
                                    ? Colors.grey // Icono desactivado
                                    : Colors.red.shade800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/gallery-container');
                              },
                              child: Icon(
                                Icons.photo_library_outlined,
                                size: 25,
                                color: isParches && !isChecked[index]
                                    ? Colors.grey // Icono desactivado
                                    : Colors.red.shade800,
                              ),
                            ),
                            if (isParches) ...[
                              Checkbox(
                                value: isChecked[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked[index] = value ?? false;
                                  });
                                },
                                activeColor: Colors.red.shade800,
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                              ),
                            ],
                          ],
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
    );
  }
}
