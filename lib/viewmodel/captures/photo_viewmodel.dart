import 'package:aida/data/models/captures/photo_model.dart';
import 'package:aida/services/captures/photo_service.dart';
import 'package:flutter/material.dart';

class PhotoViewModel extends ChangeNotifier {
  final PhotoService _photoService = PhotoService();

  String errorMessage = '';
  bool isLoading = false;

  List<Map<String, dynamic>> _photos = [];

  List<Map<String, dynamic>> get photos => _photos;

  void clearPhotos() {
    _photos.clear();
    notifyListeners();
  }

  Future<PhotoModel?> insert(num bkId, num cntId, String typePicture,
      String subTypePicture, String url, num user) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        'MbBkId': bkId,
        'MbCntId': cntId,
        'MbPcTypePicture': typePicture,
        'MbPcSubTypePicture': subTypePicture,
        'MbPcLinkDirectory': url,
        'UsrCreate': user,
      };

      final response = await _photoService.insert(data);
      print('Response body: ${response}');

      if (response['success'] == true) {
        final photo = PhotoModel.fromJson(response['photo_capture']);
        notifyListeners();

        return photo;
      } else {
        errorMessage = response['message'] ?? 'Error desconocido';
      }
    } catch (e) {
      errorMessage = '$e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }
}
