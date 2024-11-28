import 'package:aida/services/carriers/carrier_service.dart';
import 'package:flutter/material.dart';
import '../../data/models/carriers/carrier_model.dart';

class CarrierViewModel extends ChangeNotifier {
  final CarrierService _carrierService = CarrierService();

  String errorMessage = '';
  bool isLoading = false;

  List<String> _areas = [];
  List<String> get areas => _areas;

  // Metodo para manejar el insert a transportista
  Future<CarrierModel?> insert(
      String licencia,
      num occupants,
      String area,
      String driver,
      String route,
      String gate,
      String type,
      String fecha,
      num user,
      num seatNumber) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        "MbptLicensePlateNumber": licencia,
        "MbptOccupantsNumber": occupants,
        "MbptArea": area,
        "MbptDriver": driver,
        "MbptRoute": route,
        "MbptGate": gate,
        "MbptType": type,
        "MbptDate": fecha,
        "UsrCreate": user,
        "MbptNumberSeats": seatNumber,
      };

      final response = await _carrierService.insert(data);

      if (response != null) {
        if (response['original']['success'] == true) {
          final carrier =
              CarrierModel.fromJson(response['original']['carrier']);
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

  Future<void> fetchAreas() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _carrierService.get_areas();
      if (response != null && response.isNotEmpty) {
        _areas = response.map((area) => area['Area'] as String).toList();
      } else {
        throw Exception("No se encontraron áreas.");
      }
    } catch (e) {
      errorMessage = 'Error al obtener las áreas: ${e.toString()}';
      _areas = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
