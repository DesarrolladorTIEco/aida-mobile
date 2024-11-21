import 'dart:convert';

import 'package:aida/services/carriers/carrier_service.dart';
import 'package:flutter/material.dart';
import '../../data/models/carriers/carrier_model.dart';

class CarrierViewModel extends ChangeNotifier {
  final CarrierService _carrierService = CarrierService();

  String errorMessage = '';
  bool isLoading = false;

  // Metodo para manejar el insert a transportista
  Future<CarrierModel?> insert(
      String licencia,
      num occupants,
      String dni,
      String driver,
      String route,
      String gate,
      String type,
      String fecha,
      num user) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        "MbptLicensePlateNumber": licencia,
        "MbptOccupantsNumber": occupants,
        "MbptDniDriver": dni,
        "MbptDriver": driver,
        "MbptRoute": route,
        "MbptGate": gate,
        "MbptType": type,
        "MbptDate": fecha,
        "UsrCreate": user
      };

      final response = await _carrierService.insert(data);

      if (response != null) {
        print("Response received: ${jsonEncode(response)}");

        if (response['original']['success'] == true){
          print("fdsafdsafdsafdsafdsa");

          final carrier = CarrierModel.fromJson(response['original']['carrier']);
          print("CarrierModel retornado: ${carrier.toString()}");


          // print("CarrierModel retornado: ${carrier.toString()}");

          notifyListeners();
          return carrier;
        } else {
          errorMessage =
              "Hubo un error: ${response['original']['message'] ?? 'Error desconocido'}";
          notifyListeners();
          return null;
        }
      } else {
        errorMessage = "No se recibió respuesta del servidor.";
        notifyListeners();
        return null;
      }
    } catch (e) {
      errorMessage = 'Hubo un error: ${e.toString()}';
      print("Error: ${e.toString()}");
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
