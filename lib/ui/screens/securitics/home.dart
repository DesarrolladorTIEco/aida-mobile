import 'package:aida/viewmodel/auth_viewmodel.dart';
import 'package:aida/viewmodel/securitics/container_viewmodel.dart';
import 'package:flutter/material.dart';
import '../../widgets/navbar_widget_securitics.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSecuriticPage extends StatefulWidget {
  const HomeSecuriticPage({Key? key}) : super(key: key);

  @override
  State<HomeSecuriticPage> createState() => _HomeSecuriticsState();
}

class _HomeSecuriticsState extends State<HomeSecuriticPage> {
  final TextEditingController _search = TextEditingController();

  String zoneName = '';
  String cultive = '';

  Future<void> _loadContainers(ContainerViewModel containerViewModel) async
  {
    if(zoneName.isNotEmpty && cultive.isNotEmpty) {
      try {
        await containerViewModel.fetchContainer(cultive, zoneName);
      } catch (e) {
        print("Error: error al obtener los contenedores: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final containerViewModel =
      Provider.of<ContainerViewModel>(context, listen: false);
      containerViewModel.clearContainer();
      _loadContainers(containerViewModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final containerViewModel = Provider.of<ContainerViewModel>(context);

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

                      Navigator.pushNamed(context, '/new-container', arguments: arguments);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                        SizedBox(height: 4), // Espacio entre el icono y el texto
                        Text(
                          'CONTENEDOR',
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
                      // Acción del botón sync
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      backgroundColor: Colors.grey, // Color del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Borde redondeado mínimo
                      ),
                      minimumSize: const Size(100, 60),
                      maximumSize: const Size(100, 60),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sync, size: 16, color: Colors.white),
                        SizedBox(height: 4), // Espacio entre el icono y el texto
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
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
                hintText: "Busqueda avanzada...", // Añadido hintText para guía de entrada
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
                print("Nombre del Contenedor: $value"); // Para verificar si captura el valor
              },
            ),
          ),


          const SizedBox(height: 12),


          Expanded(
            child: ListView.builder(
              itemCount: containerViewModel.containers.length,
              itemBuilder: (context, index) {
                final container = containerViewModel.containers[index];
                return  Card(
                  elevation: 1,
                  margin: EdgeInsets.symmetric(vertical: 4.0),
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
                          container['Contenedor'] ?? 'Sin Nombre',
                          style:  GoogleFonts.raleway(
                            fontSize: 18,
                            letterSpacing: 0.65,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 0.2),
                        Text(
                          'Linea de Negocio: ${container["Cultivo"] ?? "Sin Nombre"}',
                          style:  GoogleFonts.raleway(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios, // Icono que quieres mostrar
                      size: 20,
                      color: Colors.grey,
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
