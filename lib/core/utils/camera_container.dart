import 'package:aida/services/service.dart';
import 'package:aida/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'dart:math';


import 'package:provider/provider.dart';

class CameraContainer {
  final ApiService _apiService = ApiService();

  final ImagePicker _picker = ImagePicker();

  String generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<XFile?> openCamera(BuildContext context, String path) async {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final fullName = authViewModel.fullName ?? 'Usuario';

      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        String dynamicFilename = "${fullName}_${DateTime.now().day.toString().padLeft(2, '0')}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().year}${DateTime.now().hour.toString().padLeft(2, '0')}${DateTime.now().minute.toString().padLeft(2, '0')}_${generateRandomString(5)}";

        await _uploadImageToServer(context, File(image.path), path, dynamicFilename);
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


  Future<void> _uploadImageToServer(BuildContext context, File imageFile, String path, String filename) async {
    final String url = '${_apiService.baseUrl}securitic/pic-upload';
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['path'] = path
        ..fields['filename'] = filename
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
