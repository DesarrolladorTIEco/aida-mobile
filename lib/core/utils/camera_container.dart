import 'package:aida/services/service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class CameraContainer {
  final ApiService _apiService = ApiService();

  final ImagePicker _picker = ImagePicker();

  Future<XFile?> openCamera(BuildContext context, String path) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        await _uploadImageToServer(context, File(image.path), path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se capturó ninguna imagen')),
        );
      }
      return image;
    } catch (e) {
      print("Error al abrir la cámara: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al abrir la cámara')),
      );
      return null;
    }
  }


  Future<void> _uploadImageToServer(BuildContext context, File imageFile, String path) async {
    final String url = '${_apiService.baseUrl}securitic/add-container';
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['path'] = path
        ..files.add(await http.MultipartFile.fromPath('photo', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagen subida exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al subir la imagen')),
        );
      }
    } catch (e) {
      print("Error al subir la imagen: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al subir la imagen')),
      );
    }
  }

}
