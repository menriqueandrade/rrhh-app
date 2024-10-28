import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees/core/di.dart';
import 'package:employees/features/employess/data/datasources/employess_datasource.dart';
import 'package:employees/features/employess/data/datasources/firebase_storage_datasource.dart';
import 'package:employees/features/employess/data/repositories/employess_repository_impl.dart';
import 'package:employees/features/employess/data/repositories/files_repository.dart';
import 'package:employees/features/employess/domain/repositories/employess_repository.dart';
import 'package:employees/features/employess/domain/repositories/file_upload_repository.dart';
import 'package:employees/features/employess/domain/usecases/generate_employee_email.dart';
import 'package:employees/features/employess/presentation/bloc/form/employee_form_bloc.dart';
import 'package:employees/features/employess/presentation/bloc/list/employees_bloc.dart';
import 'package:employees/main.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EmployeesDI implements DI {
  @override
  Future<void> setup() async {
    final firestoreDb = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;
    getIt.registerLazySingleton<EmployeesDataSource>(
      () => EmployeesDataSourceImpl(firestoreDb),
    );
    getIt.registerLazySingleton<FilesDataSource>(
      () => FirebaseStorageDataSourceImpl(storage),
    );
    getIt.registerLazySingleton<FilesRepository>(
      () => FileRepositoryImpl(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<EmployeesRepository>(
      () => EmployeesRepositoryImpl(
        employeesRemoteDataSource: getIt(),
        talker: getIt(),
      ),
    );
    getIt.registerLazySingleton<EmployeesBloc>(
      () => EmployeesBloc(
        employeesRepository: getIt(),
      ),
    );
    getIt.registerLazySingleton<GenerateEmployeeEmail>(
      () => GenerateEmployeeEmail(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<EmployeeFormBloc>(
      () => EmployeeFormBloc(
        employeesRepository: getIt(),
        fileUploadRepository: getIt(),
        generateEmployeeEmail: getIt(),
      ),
    );
  }
}
