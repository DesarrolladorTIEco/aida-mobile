import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aida/core/utils/camera_container.dart';

class SeguridadPrecintoMenu extends StatefulWidget {
  const SeguridadPrecintoMenu({Key? key}) : super(key: key);

  @override
  State<SeguridadPrecintoMenu> createState() => _SeguridadPrecintoState();
}

class _SeguridadPrecintoState extends State<SeguridadPrecintoMenu> {
  final CameraContainer _cameraContainer = CameraContainer();
  String container = '';
  String url = '';

  final titles = [
    'Precinto Aduana',
    'Precinto Linea 01',
    'Precinto Senasa',
    'Precinto Linea 02',
    'Precinto Ecosac',
    'Cinta Seguridad',
    'Contenedor precintado',
  ];

  final List<String> checkableTitles = [
    'Precinto Senasa',
    'Precinto Linea 02',
    'Precinto Ecosac',
    'Cinta Seguridad',
  ];

  List<bool> isChecked = List.generate(8, (index) => false);
  bool isListEnabled = false;

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      container = (arguments['container'] ?? 'Desconocido').toString();
      url = (arguments['url'] ?? 'Desconocido').toString();
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
                        'PRECINTOS',
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
              itemCount: 7, // Mostrando los 8 elementos
              itemBuilder: (context, index) {
                bool isCheckbox = checkableTitles.contains(titles[index]);

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: InkWell(
                    onTap: () {
                      print("Item seleccionado: ${titles[index]}");
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                  color: isCheckbox && !isChecked[index]
                                      ? Colors.grey // Texto desactivado
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.photo_camera,
                                size: 25,
                                color: isCheckbox && !isChecked[index]
                                    ? Colors.grey // Icono desactivado
                                    : Colors.red.shade800,
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.photo_library_outlined,
                                size: 25,
                                color: isCheckbox && !isChecked[index]
                                    ? Colors.grey // Icono desactivado
                                    : Colors.red.shade800,
                              ),
                              if (isCheckbox) ...[
                                Checkbox(
                                  value: isChecked[index],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked[index] = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.red.shade800, // Color rojo cuando está activado
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ],
                            ],
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
    );
  }
}
