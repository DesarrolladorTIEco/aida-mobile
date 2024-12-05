import 'package:aida/viewmodel/securitics/container_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // Importar ImagePicker
import 'package:aida/core/utils/camera_container.dart'; // Importar CameraContainer

class ContainerMenuPage extends StatefulWidget {
  const ContainerMenuPage({Key? key}) : super(key: key);

  @override
  State<ContainerMenuPage> createState() => _ContainerMenuState();
}

class _ContainerMenuState extends State<ContainerMenuPage> {
  final CameraContainer _cameraContainer = CameraContainer(); // Instancia de CameraContainer
  String container = '';

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final containerViewModel = Provider.of<ContainerViewModel>(context);

    if (arguments != null) {
      container = (arguments['container'] ?? 'Desconocido').toString();
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
                        container.toUpperCase(),
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
          const SizedBox(width: 12),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20), // Margen superior
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      const String path = '\\\\10.10.100.26\\Seguridad_Proyecto\\agropiura\\conserva\\2024\\dec\\5\\OMAR';
                      final XFile? image = await _cameraContainer.openCamera(context, path);

                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.red.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(120, 70),
                      maximumSize: const Size(120, 70),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera, size: 20, color: Colors.white),
                        SizedBox(height: 4),
                        Text(
                          'CAMARA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16), // Espacio entre botones
                  ElevatedButton(
                    onPressed: containerViewModel.isLoading ? null : () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(120, 70),
                      maximumSize: const Size(120, 70),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.picture_in_picture, size: 20, color: Colors.white),
                        SizedBox(height: 4),
                        Text(
                          'VER GALERÍA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
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
          )

        ],
      ),
    );
  }
}
