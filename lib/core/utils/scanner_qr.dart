import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner {
  static Future<void> scanQRCode({
    required BuildContext context,
    required Function(String) onCodeScanned,
  }) async {
    final MobileScannerController cameraController = MobileScannerController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 300,
            width: 300,
            child: MobileScanner(
              controller: cameraController,
              onDetect: (BarcodeCapture barcode) {
                // Detecta el valor del código (QR o Barra)
                final String code = barcode.barcodes.first.rawValue ?? '';
                if (code.isNotEmpty) {
                  onCodeScanned(code); // Llama al callback con el código escaneado
                  Navigator.pop(context); // Cierra el diálogo
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class QRScannerCarrier {
  static Future<void> scanQRCode({
    required BuildContext context,
    required Function(String, String, String, String) onDataExtracted,
  }) async {
    final MobileScannerController cameraController = MobileScannerController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 300,
            width: 300,
            child: MobileScanner(
              controller: cameraController,
              onDetect: (BarcodeCapture barcode) {
                final String code = barcode.barcodes.first.rawValue ?? '';
                if (code.isNotEmpty) {
                  List<String> extractedData = code.split(' / ');
                  if (extractedData.length == 4) {
                    String placa = extractedData[0].trim();
                    String transportista = extractedData[1].trim();
                    String ruta = extractedData[2].trim();
                    String cantidadAsientos = extractedData[3].trim();

                    onDataExtracted(placa, transportista, ruta, cantidadAsientos);
                    Navigator.pop(context); // Cierra el diálogo
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('QR no válido. El formato esperado es incorrecto.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    Navigator.pop(context); // Cierra el diálogo
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }
}

