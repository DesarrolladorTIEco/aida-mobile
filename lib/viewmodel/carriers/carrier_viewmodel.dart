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
      DateTime fecha,
      num user) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        "licencia": licencia,
        "occupants": occupants,
        "dni": dni,
        "drive": driver,
        "route": route,
        "gate": gate,
        "type": type,
        "fecha": fecha,
        "user": user
      };

      final response = await _carrierService.insert(data);

      if (response['original']['message'] ==
          "Registro insertado exitosamente") {
        notifyListeners();
        return CarrierModel.fromJson(response['original']['message']);
      } else {
        errorMessage = "Hubo un error";
        notifyListeners();
        return null;
      }
    } catch (e) {
      errorMessage = 'Hubo un error: ${e.toString()}';
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
