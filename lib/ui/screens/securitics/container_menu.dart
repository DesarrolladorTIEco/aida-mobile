import 'package:aida/viewmodel/securitics/container_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ContainerMenuPage extends StatefulWidget {
  const ContainerMenuPage({Key? key}) : super(key: key);

  @override
  State<ContainerMenuPage> createState() => _ContainerMenuState();
}

class _ContainerMenuState extends State<ContainerMenuPage> {
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
                          // Espacio entre el icono y el texto
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

          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 20), // Margen superior
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           "Información del Contenedor",
          //           style: GoogleFonts.raleway(
          //             fontWeight: FontWeight.w500,
          //             fontSize: 14,
          //             color: Colors.black,
          //             letterSpacing: 0.51,
          //           ),
          //         ),
          //         const SizedBox(height: 10),
          //         // Espacio entre el título y el primer TextField
          //
          //         // Primer TextField
          //         SizedBox(
          //           width: 400,
          //           child: TextField(
          //             controller: _lineaNegocio,
          //             readOnly: true,
          //             decoration: InputDecoration(
          //               labelStyle: GoogleFonts.raleway(
          //                   fontSize: 14, fontWeight: FontWeight.w600),
          //               prefixIcon: IconButton(
          //                 icon: const Icon(Icons.error_outline),
          //                 onPressed: () => print("test"),
          //               ),
          //               prefixIconConstraints: const BoxConstraints(
          //                 minWidth: 40,
          //                 minHeight: 40,
          //               ),
          //               border: const OutlineInputBorder(),
          //               contentPadding: const EdgeInsets.symmetric(
          //                   vertical: 15.0, horizontal: 12.0),
          //               suffixIcon: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.only(left: 38.0),
          //                     child: Text(
          //                       "Linea Negocio",
          //                       style: GoogleFonts.raleway(
          //                         fontWeight: FontWeight.w600,
          //                         fontSize: 15,
          //                         color: Colors.grey,
          //                       ),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.only(right: 12.0),
          //                     child: Text(
          //                       cultive.toUpperCase(),
          //                       style: GoogleFonts.raleway(
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: 18,
          //                         color: Colors.black,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             keyboardType: TextInputType.number,
          //           ),
          //         ),
          //
          //         // Segundo TextField
          //         SizedBox(
          //           width: 400,
          //           child: TextField(
          //             controller: _today, // Controlador añadido aquí
          //             readOnly: true,
          //             decoration: InputDecoration(
          //               labelStyle: GoogleFonts.raleway(
          //                   fontSize: 14, fontWeight: FontWeight.w600),
          //               prefixIcon: IconButton(
          //                 icon: const Icon(Icons.error_outline),
          //                 onPressed: () => print("test"),
          //               ),
          //               prefixIconConstraints: const BoxConstraints(
          //                 minWidth: 40,
          //                 minHeight: 40,
          //               ),
          //               border: const OutlineInputBorder(),
          //               contentPadding: const EdgeInsets.symmetric(
          //                   vertical: 15.0, horizontal: 12.0),
          //               suffixIcon: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.only(left: 38.0),
          //                     child: Text(
          //                       "Fecha Actual",
          //                       style: GoogleFonts.raleway(
          //                         fontWeight: FontWeight.w600,
          //                         fontSize: 15,
          //                         color: Colors.grey,
          //                       ),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.only(right: 12.0),
          //                     child: Text(
          //                       formattedDate,
          //                       style: GoogleFonts.raleway(
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: 17,
          //                         color: Colors.black,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             keyboardType: TextInputType.number,
          //           ),
          //         ),
          //
          //         const SizedBox(height: 20),
          //         SizedBox(
          //           width: 400,
          //           child: TextField(
          //             controller: _newContainer,
          //             // Controlador para escribir el nombre del contenedor
          //             decoration: InputDecoration(
          //               labelStyle: GoogleFonts.raleway(
          //                 fontSize: 14,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //               prefixIcon: IconButton(
          //                 icon: const Icon(Icons.fire_truck_outlined),
          //                 onPressed: () => print("test"),
          //                 color: Colors.red.shade800,
          //               ),
          //               prefixIconConstraints: const BoxConstraints(
          //                 minWidth: 40,
          //                 minHeight: 40,
          //               ),
          //               border: const OutlineInputBorder(),
          //               contentPadding: const EdgeInsets.symmetric(
          //                   vertical: 15.0, horizontal: 12.0),
          //               hintText: "Nombre Contenedor",
          //               // Añadido hintText para guía de entrada
          //               hintStyle: GoogleFonts.raleway(
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 15,
          //                 color: Colors.grey,
          //               ),
          //             ),
          //             keyboardType: TextInputType.text,
          //             onChanged: (value) {
          //               print(
          //                   "Nombre del Contenedor: $value"); // Para verificar si captura el valor
          //             },
          //           ),
          //         ),
          //
          //         const SizedBox(height: 20),
          //
          //         ElevatedButton(
          //           onPressed: containerViewModel.isLoading
          //               ? null
          //               : () => _sendData(context),
          //           style: ElevatedButton.styleFrom(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 15, vertical: 10),
          //             backgroundColor: Colors.orange.shade800,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //             minimumSize: const Size(400, 60),
          //             maximumSize: const Size(400, 60),
          //           ),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             // Centra el contenido
          //             mainAxisSize: MainAxisSize.min,
          //
          //             children: [
          //               const Icon(Icons.add, size: 25, color: Colors.white),
          //               const SizedBox(width: 8),
          //               // Espacio entre el icono y el texto
          //               Text(
          //                 'AGREGAR CONTENEDOR',
          //                 textAlign: TextAlign.center,
          //                 style: GoogleFonts.raleway(
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.bold,
          //                   color: Colors.white,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         const SizedBox(height: 20),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
