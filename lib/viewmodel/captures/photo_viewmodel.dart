import 'package:aida/data/models/captures/photo_model.dart';
import 'package:aida/services/captures/photo_service.dart';
import 'package:flutter/material.dart';

class PhotoViewModel extends ChangeNotifier {
  final PhotoService _photoService = PhotoService();

  String errorMessage = '';
  bool isLoading = false;

  List <Map<String, dynamic>> _photos = [];
  List <Map<String, dynamic>> get photos => _photos;


}