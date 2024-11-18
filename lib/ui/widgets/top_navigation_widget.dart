import 'package:flutter/material.dart';

class TopNavBarScreen extends StatelessWidget {
  const TopNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Christmas Menu"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Vuelve al menú anterior
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert), // Tres puntos
            onPressed: () {
              // Acción para los tres puntos (más opciones)
              print("Más opciones");
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Contenido de la pantalla principal"),
      ),
    );
  }
}
