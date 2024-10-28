import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:employees/features/employess/data/datasources/employess_datasource.dart';
import 'package:employees/features/employess/data/models/employee.dart';

void main() {
  late EmployeesDataSourceImpl dataSource;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = EmployeesDataSourceImpl(fakeFirestore);
  });

  final tEmployeeModel = EmployeeModel(
    id: '1',
    firstName: 'John',
    firstSurname: 'Doe',
    secondSurname: 'Smith',
    email: 'john@example.com',
    employmentCountry: 'US',
    idType: 0,
    idNumber: '123456',
    entryDate: DateTime(2023, 1, 1),
    area: 0,
    registrationDate: DateTime(2023, 1, 1),
    photoUrl: 'http://example.com/photo.jpg',
    editionDate: DateTime(2023, 1, 1),
  );

  group('EmployeesDataSourceImpl', () {
    test('getEmployees should return EmployeeData', () async {
      await fakeFirestore.collection('employees').add(tEmployeeModel.toJson());

      final result = await dataSource.getEmployees(page: 1, limit: 10);

      expect(result.employees.length, 1);
      expect(result.page, 1);
      expect(result.totalPages, 1);
    });

    test('getEmployeesWithFilter should return filtered EmployeeData',
        () async {
      await fakeFirestore.collection('employees').add(tEmployeeModel.toJson());

      final result =
          await dataSource.getEmployeesWithFilter({'firstName': 'John'});

      expect(result.employees.length, 1);
      expect(result.employees.first.firstName, 'John');
    });

    test('addEmployee should add an employee to Firestore', () async {
      await dataSource.addEmployee(tEmployeeModel);

      final snapshot = await fakeFirestore.collection('employees').get();
      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first.data()['firstName'], 'John');
    });

    test('isEmailInUse should return true if email exists', () async {
      await fakeFirestore.collection('employees').add(tEmployeeModel.toJson());

      final result = await dataSource.isEmailInUse('john@example.com');

      expect(result, isTrue);
    });

    test('deleteEmployee should remove an employee from Firestore', () async {
      final docRef = await fakeFirestore
          .collection('employees')
          .add(tEmployeeModel.toJson());

      await dataSource.deleteEmployee(docRef.id);

      final snapshot = await fakeFirestore.collection('employees').get();
      expect(snapshot.docs.length, 0);
    });

    test('getEmployees should handle pagination correctly', () async {
      // Add 15 employees with different registration dates
      for (int i = 0; i < 15; i++) {
        await fakeFirestore
            .collection('employees')
            .doc(i.toString())
            .set(tEmployeeModel
                .copyWith(
                  id: i.toString(),
                  registrationDate: DateTime.now().subtract(Duration(days: i)),
                )
                .toJson());
      }

      final result1 = await dataSource.getEmployees(page: 1, limit: 10);
      expect(result1.employees.length, 10);
      expect(result1.page, 1);
      expect(result1.totalPages, 2);

      final result2 = await dataSource.getEmployees(page: 2, limit: 10);
      expect(result2.employees.length, 5);
      expect(result2.page, 2);
      expect(result2.totalPages, 2);

      // Verify that the employees of the second page are different from those of the first
      expect(
          result2.employees
              .every((e2) => !result1.employees.any((e1) => e1.id == e2.id)),
          isTrue);
    });
  });

  test('updateEmployee should update an employee in Firestore', () async {
    await fakeFirestore
        .collection('employees')
        .doc('1')
        .set(tEmployeeModel.toJson());

    final updatedEmployee = tEmployeeModel.copyWith(firstName: 'Juan');

    await dataSource.updateEmployee(updatedEmployee);

    final snapshot = await fakeFirestore.collection('employees').doc('1').get();
    expect(snapshot.data()?['firstName'], 'Juan');
  });

  test('isIdNumberInUse should return true if id number is in use', () async {
    await fakeFirestore.collection('employees').add(tEmployeeModel.toJson());

    final result = await dataSource.isIdNumberInUse(
      idType: 0,
      idNumber: '123456',
      excludeEmployeeId: null,
    );

    expect(result, isTrue);
  });

  test('isIdNumberInUse should return false if id number is not in use',
      () async {
    final result = await dataSource.isIdNumberInUse(
      idType: 0,
      idNumber: '123456',
      excludeEmployeeId: '1',
    );

    expect(result, isFalse);
  });
}
