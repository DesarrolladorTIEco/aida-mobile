import 'dart:convert';
import 'package:aida/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

class ImageGalleryPage extends StatefulWidget {
  const ImageGalleryPage({super.key});

  @override
  _ImageGalleryPageState createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  final ApiService _apiService = ApiService();

  List<String> _imagePaths = [];
  String path = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (arguments != null) {
        path = (arguments['url'] ?? '').toString();
        _loadImagesFromAPI();
      }
    });
  }

  Future<void> _loadImagesFromAPI() async {
    final url = Uri.parse('${_apiService.baseUrl}securitic/get-images');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'path': path}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final imageUrls = List<String>.from(jsonResponse['images']);


        setState(() {
          _imagePaths = imageUrls.map((url) {
            url = url.replaceAll(RegExp(r'/{2,}'), '/');
            String oldPart = dotenv.get('OLD_PATH', fallback: 'Ruta no disponible');

            if (url.contains(oldPart)) {
              url = url.replaceAll(oldPart, '//');
            }

            if (url.startsWith('http://') || url.startsWith('https://')) {
              return url;
            } else if (url.startsWith('http:/') || url.startsWith('https:/')) {
              return url.replaceFirst('http:/', 'http://').replaceFirst('https:/', 'https://');
            } else {
              return 'http://$url'; // Cambia a 'https://' si es necesario
            }
          }).toList();
        });

      } else {
        _showSnackBar('Error al obtener imágenes: ${response.body}');
      }
    } catch (e) {
      print('Error al acceder a la API: $e');
      _showSnackBar('Error al acceder a la API: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _openImageFullScreen(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Vista de Imagen')),
          body: PhotoView(
            imageProvider: NetworkImage(imagePath),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galería de Imágenes')),
      body: _imagePaths.isNotEmpty
          ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _imagePaths.length,
        itemBuilder: (context, index) {
          final imagePath = _imagePaths[index];
          return GestureDetector(
            onTap: () => _openImageFullScreen(context, imagePath),
            child: GridTile(
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
          );
        },
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

