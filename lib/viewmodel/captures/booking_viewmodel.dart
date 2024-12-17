import 'package:aida/data/models/captures/booking_model.dart';
import 'package:aida/services/captures/booking_service.dart';
import 'package:flutter/material.dart';

class BookingViewModel extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  String errorMessage = '';
  bool isLoading = false;

  List<Map<String, dynamic>> _bookings = [];

  List<Map<String, dynamic>> get bookings => _bookings;

  void clearBooking() {
    _bookings.clear();
    notifyListeners();
  }

  Future<void> fetchBooking(String cultive, String zone, String date) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        'MbBkCultive': cultive,
        'MbBkZone': zone,
        'SecDateCreate': date
      };

      final response = await _bookingService.get_booking(data);
      print('Respuesta de la API: $response');

      if (response.isNotEmpty) {
        _bookings = List<Map<String, dynamic>>.from(response);
        notifyListeners();
      } else {
        _bookings = [];
      }
    } catch (e) {
      errorMessage = 'Error al obtener los contenedores: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookingTerminado(String cultive, String zone,
      String date) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        'MbBkCultive': cultive,
        'MbBkZone': zone,
        'SecDateCreate': date
      };

      final response = await _bookingService.get_booking_terminado(data);
      print('Respuesta de la API: $response');

      if (response.isNotEmpty) {
        _bookings = List<Map<String, dynamic>>.from(response);
        notifyListeners();
      } else {
        _bookings = [];
      }
    } catch (e) {
      errorMessage = 'Error al obtener los contenedores: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<BookingModel?> insert(String name, String cultive, String zone,
      String date, num user) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        'MbBkName': 'N° $name',
        'MbBkCultive': cultive,
        'MbBkZone': zone,
        'SecDateCreate': date,
        'UsrCreate': user,
      };

      final response = await _bookingService.insert(data);

      if (response['original']['success'] == true) {
        final booking = BookingModel.fromJson(response['original']['booking']);
        notifyListeners();
        return booking;
      } else {
        errorMessage = response['original']['error'] ?? 'Error desconocido';
      }
    } catch (e) {
      errorMessage = '$e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<String?> saveCaptures(num bkId, num cntId, num user, String link) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        'MbBkId': bkId,
        'UsrUpdate': user,
        'MbPcLinkDirectory': link,
        'MbCntId': cntId
      };

      final response = await _bookingService.saveCaptures(data);

      if (response['original']['success'] == true) {
        return response['original']['message'];
      } else {
        errorMessage = response['message'] ?? 'Error desconocido';
        return errorMessage;
      }
    } catch (e) {
      errorMessage = e.toString();
      return errorMessage;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
