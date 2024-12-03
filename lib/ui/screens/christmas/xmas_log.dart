import 'package:flutter/material.dart';
import '../../widgets/navbar_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class XMasMenu extends StatefulWidget {
  const XMasMenu({super.key}); // Agregado punto y coma aquí

  @override
  _XMasMenuState createState() => _XMasMenuState();
}

class _XMasMenuState extends State<XMasMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(60.0),
      //   child: const TopNavBarScreen(),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 65),

          // Layout con Row para los botones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Primer botón: Reporte por Responsables
                Container(
                  height: 85, // Altura del botón
                  width: MediaQuery.of(context).size.width * 0.92, // 92% ancho
                  margin: const EdgeInsets.only(bottom: 8.0), // Espacio entre botones
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/charge-xmas');

                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.black54,
                      backgroundColor: Colors.white70, // Color del texto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Sin borde redondeado
                      ),
                      elevation: 4, // Elevación para sombra
                    ),
                    child: Center(
                      child: Text(
                        "Reporte por Responsables",
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),


                //BOTON AÑADIDO POST PRUEBAS
                Container(
                  height: 85, // Altura del botón
                  width: MediaQuery.of(context).size.width * 0.92, // 92% ancho
                  margin: const EdgeInsets.only(bottom: 8.0), // Espacio entre botones
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/charge-xmas-date');

                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.black54,
                      backgroundColor: Colors.white70, // Color del texto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Sin borde redondeado
                      ),
                      elevation: 4, // Elevación para sombra
                    ),
                    child: Center(
                      child: Text(
                        "Reporte Responsables por Rango de Fechas",
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),


                // Segundo botón: Reporte por Trabajador
                Container(
                  height: 85, // Altura del botón
                  width: MediaQuery.of(context).size.width * 0.92, // 92% ancho
                  margin: const EdgeInsets.only(bottom: 8.0), // Espacio entre botones
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/worker-xmas');

                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.black54,
                      backgroundColor: Colors.white70, // Color del texto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      elevation: 4, // Elevación para sombra
                    ),
                    child: Center(
                      child: Text(
                        "Reporte por Trabajador",
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                // Tercer botón: Reporte de Stock
                Container(
                  height: 85, // Altura del botón
                  width: MediaQuery.of(context).size.width * 0.92, // 92% ancho
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/stock-xmas');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.black54,
                      backgroundColor: Colors.white70, // Color del texto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Sin borde redondeado
                      ),
                      elevation: 4, // Elevación para sombra
                    ),
                    child: Center(
                      child: Text(
                        "Reporte de Stock",
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBarScreen(), // Usando BottomNavBarScreen
    );
  }
}