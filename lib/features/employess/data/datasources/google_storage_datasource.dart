import 'dart:convert';
import 'dart:io';
import 'package:employees/features/employess/data/app_url/app_url.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

abstract class FilesDataSource {
  Future<String> uploadImage(File imageFile);
}

class FirebaseStorageDataSourceImpl implements FilesDataSource {
  final FirebaseStorage _storage;

  FirebaseStorageDataSourceImpl(this._storage);

  @override
  Future<String> uploadImage(File imageFile) async {
    const String apiUrl = AppUrl.uploadImage;

    try {
   
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

  
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', 
          imageFile.path,
        ),
      );

      
      final response =
          await request.send().timeout(const Duration(seconds: 110));

     
      if (response.statusCode == 200) {
      
        final responseData = await response.stream.bytesToString();
       
        final Map<String, dynamic> jsonResponse = json.decode(responseData);
        final String imageUrl =
            jsonResponse['response']; 

        print('Imagen subida correctamente: $imageUrl');
        return imageUrl;
      } else {
        throw Exception('Error al subir la imagen: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }
}
