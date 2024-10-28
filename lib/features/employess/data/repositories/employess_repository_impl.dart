import 'package:employees/features/employess/data/datasources/employess_datasource.dart';
import 'package:employees/features/employess/data/models/employee.dart';
import 'package:employees/features/employess/domain/entities/employee.dart';
import 'package:employees/features/employess/domain/entities/employees_data.dart';
import 'package:employees/features/employess/domain/repositories/employess_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

class EmployeesRepositoryImpl extends EmployeesRepository {
  final EmployeesDataSource employeesRemoteDataSource;
  final Talker talker;

  EmployeesRepositoryImpl({
    required this.employeesRemoteDataSource,
    required this.talker,
  });

  @override
  Future<EmployeeData> getEmployees({int page = 1, int limit = 10}) async {
    talker.info('Getting employees with page: $page and limit: $limit');
    return await employeesRemoteDataSource.getEmployees(
      page: page,
      limit: limit,
    );
  }

  @override
  Future<EmployeeData> getEmployeesWithFilter(
      Map<String, dynamic> filters) async {
    talker.info('Getting employees with filters: $filters');
    return await employeesRemoteDataSource.getEmployeesWithFilter(filters);
  }

  @override
  Future<void> addEmployee(Employee employee) async {
    return await employeesRemoteDataSource
        .addEmployee(EmployeeModel.fromEntity(employee));
  }

  @override
  Future<bool> isEmailInUse(String email) async {
    return await employeesRemoteDataSource.isEmailInUse(email);
  }

  @override
  Future<void> deleteEmployee(String employeeId) async {
    talker.info('Deleting employee with id: $employeeId');
    await employeesRemoteDataSource.deleteEmployee(employeeId);
  }

  @override
  Future<void> updateEmployee(Employee employee) async {
    return await employeesRemoteDataSource
        .updateEmployee(EmployeeModel.fromEntity(employee));
  }

  @override
  Future<bool> isIdNumberInUse({
    required int idType,
    required String idNumber,
    required String? excludeEmployeeId,
  }) async {
    talker.info('Checking if id number: $idNumber is in use');
    return await employeesRemoteDataSource.isIdNumberInUse(
      idType: idType,
      idNumber: idNumber,
      excludeEmployeeId: excludeEmployeeId,
    );
  }
}
