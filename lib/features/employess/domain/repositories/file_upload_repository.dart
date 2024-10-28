import 'dart:io';

abstract class FilesRepository {
  Future<String> uploadImage(File imageFile);
}
