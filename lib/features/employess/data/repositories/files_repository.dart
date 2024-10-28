import 'dart:io';

import 'package:employees/features/employess/data/datasources/firebase_storage_datasource.dart';
import 'package:employees/features/employess/domain/repositories/file_upload_repository.dart';

class FileRepositoryImpl implements FilesRepository {
  final FilesDataSource _filesDataSource;

  FileRepositoryImpl(this._filesDataSource);

  @override
  Future<String> uploadImage(File imageFile) async {
    return await _filesDataSource.uploadImage(imageFile);
  }
}
