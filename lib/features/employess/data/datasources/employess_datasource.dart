import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees/features/employess/data/app_exceptions.dart';

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
    // final totalDocs = await _firestore.collection('employees').count().get();
    // final totalPages = (totalDocs.count! / limit).ceil();

    // Query query = _firestore
    //     .collection('employees')
    //     .orderBy('registrationDate', descending: true);

    // if (page > 1) {
    //   final lastDocSnapshot =
    //       await _getLastDocumentOfPreviousPage(page - 1, limit);
    //   if (lastDocSnapshot != null) {
    //     query = query.startAfterDocument(lastDocSnapshot);
    //   }
    // }

    // query = query.limit(limit);

    // final snapshot = await query.get();
    // final employees = snapshot.docs
    //     .map((doc) =>
    //         EmployeeModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
    //     .toList();

    // return EmployeeData(
    //   employees: employees,
    //   page: page,
    //   totalPages: totalPages,
    //   totalEmployees: totalDocs.count ?? 0,
    // );
    return getEmployeesRest();
  }

  @override
  Future<EmployeeData> getEmployeesRest() async {
    print('Iniciando la obtención de empleados...');

    try {
      final response = await http.get(
        Uri.parse("http://192.168.0.11:8080/mscore/v1/get/getEmployee"),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 110));

      print('Respuesta recibida: ${response.statusCode}');

      // Verifica si la respuesta fue exitosa
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body); // Decodificar el JSON
        final List<dynamic> responseData = jsonResponse['response'];

        // Mapear los empleados desde la respuesta usando tu modelo
        final List<EmployeeModel> employees = responseData.map((employeeJson) {
          final id = employeeJson['id'].toString(); // Obtiene el id como String
          return EmployeeModel.fromJson(employeeJson, id);
        }).toList();

        // Aquí podrías crear el objeto EmployeeData si lo necesitas
        return EmployeeData(
          employees: employees,
          page: 1, // Cambia esto según tu lógica de paginación
          totalPages: 1, // Cambia esto según tu lógica de paginación
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

  // @override
  // Future<EmployeeData> getEmployeesWithFilter(
  //     Map<String, dynamic> filters) async {
  //   Query query = _firestore.collection('employees');

  //   filters.forEach((key, value) {
  //     query = query.where(key, isEqualTo: value);
  //   });

  //   final snapshot = await query.get();

  //   final employees = snapshot.docs
  //       .map((doc) =>
  //           EmployeeModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
  //       .toList();

  //   return EmployeeData(
  //     page: 1,
  //     totalPages: 1,
  //     totalEmployees: snapshot.docs.length,
  //     employees: employees,
  //   );
  // }

  @override
  Future<EmployeeData> getEmployeesWithFilter(
      Map<String, dynamic> filters) async {
       // final employeeJson = employee.toJson();
    const String apiUrl ="http://192.168.0.11:8080/mscore/v1/post/getEmployeesWithFilter";
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
                employeeJson), // Convierte el objeto EmployeeModel a JSON
          )
          .timeout(const Duration(seconds: 110));

      print('Respuesta recibida: ${response.statusCode}');

      // Verifica si la respuesta fue exitosa
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body); // Decodificar el JSON
        final List<dynamic> responseData = jsonResponse['response'];

        // Mapear los empleados desde la respuesta usando tu modelo
        final List<EmployeeModel> employees = responseData.map((employeeJson) {
          final id = employeeJson['id'].toString(); // Obtiene el id como String
          return EmployeeModel.fromJson(employeeJson, id);
        }).toList();

        // Aquí podrías crear el objeto EmployeeData si lo necesitas
        return EmployeeData(
          employees: employees,
          page: 1, // Cambia esto según tu lógica de paginación
          totalPages: 1, // Cambia esto según tu lógica de paginación
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

  // @override
  // Future<void> addEmployee(EmployeeModel employee) async {
  //   await _firestore.collection('employees').doc(employee.id).set(
  //         employee.toJson(),
  //       );
  // }

  Future<void> addEmployee(EmployeeModel employee) async {
    final employeeJson = employee.toJson()..['id'] = null;
    const String apiUrl =
        "http://192.168.0.11:8080/mscore/v1/post/addEmployee"; // URL de tu API para guardar empleados

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(
                employeeJson), // Convierte el objeto EmployeeModel a JSON
          )
          .timeout(const Duration(seconds: 110));

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa, puedes manejarlo aquí
        print('Empleado guardado correctamente: ${response.body}');
      } else {
        // Manejo de errores según el código de estado
        print(
            'Error al guardar el empleado: ${response.statusCode} - ${response.body}');
        throw Exception('Error al guardar el empleado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
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

  // @override
  // Future<void> deleteEmployee(String employeeId) async {
  //   await _firestore.collection('employees').doc(employeeId).delete();
  // }

  @override
  Future<void> deleteEmployee(String employeeId) async {
    const String apiUrl =
        "http://192.168.0.11:8080/mscore/v1/post/deleteEmployee";

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
        print(
            'Error al eliminar el empleado: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Error al eliminar el empleado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
      throw Exception('Error al realizar la solicitud: $e');
    }
  }

  // @override
  // Future<void> updateEmployee(EmployeeModel employee) async {
  //   await _firestore.collection('employees').doc(employee.id).update(
  //         employee.toJson(),
  //       );
  // }

  @override
  Future<void> updateEmployee(EmployeeModel employee) async {
    final employeeJson = employee.toJson();
    const String apiUrl =
        "http://192.168.0.11:8080/mscore/v1/post/updateEmployee"; // URL de tu API para guardar empleados

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(
                employeeJson), // Convierte el objeto EmployeeModel a JSON
          )
          .timeout(const Duration(seconds: 110));

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa, puedes manejarlo aquí
        print('Empleado Actualizado correctamente: ${response.body}');
      } else {
        // Manejo de errores según el código de estado
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
