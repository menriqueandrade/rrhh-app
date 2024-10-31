import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees/features/employess/data/app_exceptions.dart';
import 'package:employees/features/employess/data/app_url/app_url.dart';

import 'package:employees/features/employess/data/models/employee.dart';
import 'package:employees/features/employess/domain/entities/employees_data.dart';
import 'package:http/http.dart' as http;

abstract class EmployeesDataSource {
  Future<EmployeeData> getEmployeesRest();
  Future<EmployeeData> getEmployees({required int page, required int limit});
  Future<EmployeeData> getEmployeesWithFilter(Map<String, dynamic> filters);
  Future<void> addEmployee(EmployeeModel employee);
  Future<bool> isEmailInUse(String email);
  Future<void> deleteEmployee(String employeeId);
  Future<void> updateEmployee(EmployeeModel employee);
  Future<bool> isIdNumberInUse({
    required int idType,
    required String idNumber,
    required String? excludeEmployeeId,
  });
}

class EmployeesDataSourceImpl implements EmployeesDataSource {
  final FirebaseFirestore _firestore;

  EmployeesDataSourceImpl(this._firestore);

  @override
  Future<EmployeeData> getEmployees({
    required int page,
    required int limit,
  }) async {
    return getEmployeesRest();
  }

  @override
  Future<EmployeeData> getEmployeesRest() async {
    print('Iniciando la obtención de empleados...');

    try {
      final response = await http.get(
        Uri.parse(AppUrl.getEmployee),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 110));
      // Verifica si la respuesta fue exitosa
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body); // Decodificar el JSON
        final List<dynamic> responseData = jsonResponse['response'];

       
        final List<EmployeeModel> employees = responseData.map((employeeJson) {
          final id = employeeJson['id'].toString(); // Obtiene el id como String
          return EmployeeModel.fromJson(employeeJson, id);
        }).toList();

        
        return EmployeeData(
          employees: employees,
          page: 1,
          totalPages: 1,
          totalEmployees: employees.length,
        );
      } else {
        throw Exception('Error en la respuesta: ${response.statusCode}');
      }
    } on SocketException {
      print('Error de conexión a Internet');
      throw InternetException('No hay conexión a Internet');
    } on TimeoutException {
      print('Tiempo de espera agotado');
      throw RequestTimeOut('Tiempo de espera agotado');
    } catch (e) {
      print('Error desconocido: $e');
      throw Exception('Error desconocido: $e');
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      default:
        throw FetchDataException(
            'Error accoured while communicating with server ' +
                response.statusCode.toString());
    }
  }

  Future<DocumentSnapshot?> _getLastDocumentOfPreviousPage(
      int page, int limit) async {
    final query = _firestore
        .collection('employees')
        .orderBy('registrationDate', descending: true)
        .limit(page * limit);

    final snapshot = await query.get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
  }

  @override
  Future<EmployeeData> getEmployeesWithFilter(
      Map<String, dynamic> filters) async {
       // final employeeJson = employee.toJson();
    const String apiUrl =AppUrl.getEmployeesWithFilter;
    print('Iniciando la obtención de empleados...');
    final employeeJson = filters; 
    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(
                employeeJson), 
          )
          .timeout(const Duration(seconds: 110));

      print('Respuesta recibida: ${response.statusCode}');

      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body); 
        final List<dynamic> responseData = jsonResponse['response'];

       
        final List<EmployeeModel> employees = responseData.map((employeeJson) {
          final id = employeeJson['id'].toString(); 
          return EmployeeModel.fromJson(employeeJson, id);
        }).toList();

        
        return EmployeeData(
          employees: employees,
          page: 1, 
          totalPages: 1, 
          totalEmployees: employees.length,
        );
      } else {
        throw Exception('Error en la respuesta: ${response.statusCode}');
      }
    } on SocketException {
      print('Error de conexión a Internet');
      throw InternetException('No hay conexión a Internet');
    } on TimeoutException {
      print('Tiempo de espera agotado');
      throw RequestTimeOut('Tiempo de espera agotado');
    } catch (e) {
      print('Error desconocido: $e');
      throw Exception('Error desconocido: $e');
    }
  }

  Future<void> addEmployee(EmployeeModel employee) async {
    final employeeJson = employee.toJson()..['id'] = null;
    const String apiUrl =
        AppUrl.addEmployee; 

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(
                employeeJson), 
          )
          .timeout(const Duration(seconds: 110));

      if (response.statusCode == 200) {
        print('Empleado guardado correctamente: ${response.body}');
      } else {
        throw Exception('Error al guardar el empleado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }

  @override
  Future<bool> isEmailInUse(String email) async {
    final result = await _firestore
        .collection('employees')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }


  @override
  Future<void> deleteEmployee(String employeeId) async {
    const String apiUrl =
        AppUrl.deleteEmployee;

    try {
      final Map<String, dynamic> data = {
        'id': int.parse(employeeId),
      };

      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 110));

      if (response.statusCode == 200) {
        print('Empleado eliminado correctamente: ${response.body}');
      } else {
        throw Exception(
            'Error al eliminar el empleado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }

  @override
  Future<void> updateEmployee(EmployeeModel employee) async {
    final employeeJson = employee.toJson();
    const String apiUrl =
        AppUrl.updateEmployee; // URL de tu API para guardar empleados

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(
                employeeJson), 
          )
          .timeout(const Duration(seconds: 110));

      if (response.statusCode == 200) {
  
      } else {
        print(
            'Error al Actualizar el empleado: ${response.statusCode} - ${response.body}');
        throw Exception('Error al guardar el empleado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
      throw Exception('Error al realizar la solicitud: $e');
    }
  }

  @override
  Future<bool> isIdNumberInUse({
    required int idType,
    required String idNumber,
    required String? excludeEmployeeId,
  }) async {
    Query query = _firestore
        .collection('employees')
        .where('idType', isEqualTo: idType)
        .where('idNumber', isEqualTo: idNumber);

    if (excludeEmployeeId != null) {
      query =
          query.where(FieldPath.documentId, isNotEqualTo: excludeEmployeeId);
    }

    final result = await query.get();
    return result.docs.isNotEmpty;
  }
}
