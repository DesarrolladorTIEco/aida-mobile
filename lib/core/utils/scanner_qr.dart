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
                final String code = barcode.barcodes.first.rawValue ?? '';
                if (code.isNotEmpty) {
                  onCodeScanned(code);
                  Navigator.pop(context);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
