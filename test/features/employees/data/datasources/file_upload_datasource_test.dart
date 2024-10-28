import 'dart:io';
import 'package:employees/features/employess/data/datasources/firebase_storage_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';

void main() {
  late FilesDataSource dataSource;
  late MockFirebaseStorage mockStorage;

  setUp(() {
    mockStorage = MockFirebaseStorage();
    dataSource = FirebaseStorageDataSourceImpl(mockStorage);
  });

  group('FileUploadDataSourceImpl', () {
    test('uploadImage should upload file and return download URL', () async {
      final file = File('assets/test_image.png');

      final result = await dataSource.uploadImage(file);

      expect(result, isA<String>());
      expect(result, contains('https://firebasestorage.googleapis.com'));
    });
  });
}
