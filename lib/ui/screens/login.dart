import 'package:flutter/material.dart';

class Pantalla1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla 1'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/pantalla2');
          },
          child: Text('Ir a Pantalla 2'),
        ),
      ),
    );
  }
}
