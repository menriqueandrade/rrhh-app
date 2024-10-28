import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:employees/features/employess/data/models/employee.dart';
import 'package:employees/features/employess/domain/entities/employees_data.dart';

abstract class EmployeesDataSource {
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
    final totalDocs = await _firestore.collection('employees').count().get();
    final totalPages = (totalDocs.count! / limit).ceil();

    Query query = _firestore
        .collection('employees')
        .orderBy('registrationDate', descending: true);

    if (page > 1) {
      final lastDocSnapshot =
          await _getLastDocumentOfPreviousPage(page - 1, limit);
      if (lastDocSnapshot != null) {
        query = query.startAfterDocument(lastDocSnapshot);
      }
    }

    query = query.limit(limit);

    final snapshot = await query.get();
    final employees = snapshot.docs
        .map((doc) =>
            EmployeeModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    return EmployeeData(
      employees: employees,
      page: page,
      totalPages: totalPages,
      totalEmployees: totalDocs.count ?? 0,
    );
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
    Query query = _firestore.collection('employees');

    filters.forEach((key, value) {
      query = query.where(key, isEqualTo: value);
    });

    final snapshot = await query.get();

    final employees = snapshot.docs
        .map((doc) =>
            EmployeeModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    return EmployeeData(
      page: 1,
      totalPages: 1,
      totalEmployees: snapshot.docs.length,
      employees: employees,
    );
  }

  @override
  Future<void> addEmployee(EmployeeModel employee) async {
    await _firestore.collection('employees').doc(employee.id).set(
          employee.toJson(),
        );
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
    await _firestore.collection('employees').doc(employeeId).delete();
  }

  @override
  Future<void> updateEmployee(EmployeeModel employee) async {
    await _firestore.collection('employees').doc(employee.id).update(
          employee.toJson(),
        );
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
