import 'package:employees/features/employess/domain/entities/employee_filter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:employees/features/employess/domain/repositories/employess_repository.dart';
import 'package:employees/features/employess/presentation/bloc/list/employees_bloc.dart';
import 'package:employees/features/employess/domain/entities/employees_data.dart';
import 'package:employees/features/employess/domain/entities/employee.dart';

class MockEmployeesRepository extends Mock implements EmployeesRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(Employee(
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
    ));
  });

  late EmployeesBloc employeesBloc;
  late MockEmployeesRepository mockRepository;

  setUp(() {
    mockRepository = MockEmployeesRepository();
    employeesBloc = EmployeesBloc(employeesRepository: mockRepository);
  });

  tearDown(() {
    employeesBloc.close();
  });

  group('EmployeesBloc', () {
    final tEmployeeData = EmployeeData(
      page: 1,
      totalPages: 1,
      totalEmployees: 1,
      employees: [
        Employee(
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
        ),
      ],
    );

    blocTest<EmployeesBloc, EmployeesState>(
      'emits [EmployeesLoading, EmployeesLoaded] when LoadEmployees is added',
      build: () {
        when(() => mockRepository.getEmployees(page: 1, limit: 10))
            .thenAnswer((_) async => tEmployeeData);
        return employeesBloc;
      },
      act: (bloc) => bloc.add(const LoadEmployees()),
      expect: () => [
        isA<EmployeesLoading>(),
        isA<EmployeesLoaded>(),
      ],
    );

    blocTest<EmployeesBloc, EmployeesState>(
      'emits [EmployeesLoading, EmployeesError] when LoadEmployees fails',
      build: () {
        when(() => mockRepository.getEmployees(page: 1, limit: 10))
            .thenThrow(Exception('Error loading employees'));
        return employeesBloc;
      },
      act: (bloc) => bloc.add(const LoadEmployees()),
      expect: () => [
        isA<EmployeesLoading>(),
        isA<EmployeesError>(),
      ],
    );

    blocTest<EmployeesBloc, EmployeesState>(
      'emits [EmployeesLoadingMore, EmployeesLoaded] when LoadMoreEmployees is added',
      build: () {
        when(() => mockRepository.getEmployees(page: 1, limit: 10))
            .thenAnswer((_) async => tEmployeeData);
        when(() => mockRepository.getEmployees(page: 2, limit: 10))
            .thenAnswer((_) async => tEmployeeData.copyWith(page: 2));
        return employeesBloc;
      },
      seed: () => EmployeesLoaded(
          employeeData: tEmployeeData.copyWith(totalPages: 2),
          filter: const EmployeeFilter()),
      act: (bloc) => bloc.add(LoadMoreEmployees()),
      expect: () => [
        isA<EmployeesLoadingMore>(),
        isA<EmployeesLoaded>(),
      ],
    );

    blocTest<EmployeesBloc, EmployeesState>(
      'emits [EmployeesLoaded] with updated filter when UpdateFilter is added',
      build: () => employeesBloc,
      seed: () => EmployeesLoaded(
          employeeData: tEmployeeData, filter: const EmployeeFilter()),
      act: (bloc) =>
          bloc.add(const UpdateFilter(EmployeeFilter(firstName: 'John'))),
      expect: () => [
        isA<EmployeesLoaded>().having(
            (state) => state.filter.firstName, 'filter firstName', 'John'),
      ],
    );

    blocTest<EmployeesBloc, EmployeesState>(
      'emits [EmployeesLoading, EmployeesLoadedWithFilter] when ApplyFilter is added',
      build: () {
        when(() => mockRepository.getEmployeesWithFilter(any()))
            .thenAnswer((_) async => tEmployeeData);
        return employeesBloc;
      },
      seed: () => EmployeesLoaded(
          employeeData: tEmployeeData,
          filter: const EmployeeFilter(firstName: 'John')),
      act: (bloc) => bloc.add(ApplyFilter()),
      expect: () => [
        isA<EmployeesLoading>(),
        isA<EmployeesLoadedWithFilter>(),
      ],
    );

    blocTest<EmployeesBloc, EmployeesState>(
      'emits [EmployeesInitial, EmployeesLoading, EmployeesLoaded] when ResetFilter is added',
      build: () {
        when(() => mockRepository.getEmployees(page: 1, limit: 10))
            .thenAnswer((_) async => tEmployeeData);
        return employeesBloc;
      },
      seed: () => EmployeesLoaded(
          employeeData: tEmployeeData,
          filter: const EmployeeFilter(firstName: 'John')),
      act: (bloc) => bloc.add(ResetFilter()),
      expect: () => [
        isA<EmployeesInitial>(),
        isA<EmployeesLoading>(),
        isA<EmployeesLoaded>(),
      ],
    );

    blocTest<EmployeesBloc, EmployeesState>(
      'emits [EmployeesLoaded] with added employee when EmployeeAdded is added',
      build: () => employeesBloc,
      seed: () => EmployeesLoaded(
          employeeData: tEmployeeData, filter: const EmployeeFilter()),
      act: (bloc) => bloc.add(EmployeeAdded(Employee(
        id: '2',
        firstName: 'Jane',
        firstSurname: 'Doe',
        secondSurname: 'Smith',
        email: 'jane@example.com',
        employmentCountry: 'UK',
        idType: 1,
        idNumber: '654321',
        entryDate: DateTime(2023, 2, 1),
        area: 1,
        registrationDate: DateTime(2023, 2, 1),
        photoUrl: 'http://example.com/jane.jpg',
      ))),
      expect: () => [
        isA<EmployeesLoaded>().having(
          (state) => state.employeeData.employees.length,
          'employees length',
          2,
        ),
      ],
    );

    blocTest<EmployeesBloc, EmployeesState>(
      'emits [EmployeesDeletedSuccess] when EmployeeDeleted is added successfully',
      build: () {
        when(() => mockRepository.deleteEmployee(any()))
            .thenAnswer((_) async => {});
        return employeesBloc;
      },
      seed: () => EmployeesLoaded(
          employeeData: tEmployeeData, filter: const EmployeeFilter()),
      act: (bloc) => bloc.add(EmployeeDeleted(tEmployeeData.employees.first)),
      expect: () => [
        isA<EmployeesDeletedSuccess>().having(
          (state) => state.employeeData.employees.length,
          'employees length',
          0,
        ),
      ],
    );

    blocTest<EmployeesBloc, EmployeesState>(
      'emits [EmployeesDeletedFailed] when EmployeeDeleted fails',
      build: () {
        when(() => mockRepository.deleteEmployee(any()))
            .thenThrow(Exception('Error deleting employee'));
        return employeesBloc;
      },
      seed: () => EmployeesLoaded(
          employeeData: tEmployeeData, filter: const EmployeeFilter()),
      act: (bloc) => bloc.add(EmployeeDeleted(tEmployeeData.employees.first)),
      expect: () => [
        isA<EmployeesDeletedFailed>(),
      ],
    );
  });
}
