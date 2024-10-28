import 'package:employees/features/employess/domain/usecases/generate_employee_email.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:employees/features/employess/domain/repositories/employess_repository.dart';
import 'package:employees/features/employess/domain/repositories/file_upload_repository.dart';
import 'package:employees/features/employess/presentation/bloc/form/employee_form_bloc.dart';
import 'package:employees/features/employess/domain/entities/employee.dart';
import 'dart:io';

class MockEmployeesRepository extends Mock implements EmployeesRepository {}

class MockFilesRepository extends Mock implements FilesRepository {}

class MockFile extends Mock implements File {}

final employee = Employee(
  id: '1',
  firstName: 'Juan',
  firstSurname: 'Perez',
  secondSurname: 'Gomez',
  email: 'juan.perez@tuarmi.com.co',
  employmentCountry: 'CO',
  idType: 0,
  idNumber: '123456',
  entryDate: DateTime(2023, 1, 1),
  area: 0,
  registrationDate: DateTime(2023, 1, 1),
  photoUrl: 'http://example.com/photo.jpg',
);
void main() {
  setUpAll(() {
    registerFallbackValue(MockFile());
    registerFallbackValue(employee);
  });

  late EmployeeFormBloc employeeFormBloc;
  late MockEmployeesRepository mockEmployeesRepository;
  late MockFilesRepository mockFilesRepository;
  late GenerateEmployeeEmail mockGenerateEmployeeEmail;
  setUp(() {
    mockEmployeesRepository = MockEmployeesRepository();
    mockFilesRepository = MockFilesRepository();
    mockGenerateEmployeeEmail = GenerateEmployeeEmail(mockEmployeesRepository);

    employeeFormBloc = EmployeeFormBloc(
      employeesRepository: mockEmployeesRepository,
      fileUploadRepository: mockFilesRepository,
      generateEmployeeEmail: mockGenerateEmployeeEmail,
    );
  });

  tearDown(() {
    employeeFormBloc.close();
  });

  group('EmployeeFormBloc', () {
    test('initial state is EmployeeFormInitial', () {
      expect(employeeFormBloc.state, isA<EmployeeFormInitial>());
    });

    blocTest<EmployeeFormBloc, EmployeeFormState>(
      'emits [DataUpdatedState] when EmploymentCountryChanged is added',
      build: () => employeeFormBloc,
      act: (bloc) => bloc.add(const EmploymentCountryChanged('CO')),
      expect: () => [
        isA<DataUpdatedState>().having((state) => state.data?.employmentCountry,
            'employmentCountry', 'CO'),
      ],
    );

    blocTest<EmployeeFormBloc, EmployeeFormState>(
      'emits [DataUpdatedState] when IdTypeChanged is added',
      build: () => employeeFormBloc,
      act: (bloc) => bloc.add(const IdTypeChanged(1)),
      expect: () => [
        isA<DataUpdatedState>()
            .having((state) => state.data?.idType, 'idType', 1),
      ],
    );

    blocTest<EmployeeFormBloc, EmployeeFormState>(
      'emits [DataUpdatedState] when AreaChanged is added',
      build: () => employeeFormBloc,
      act: (bloc) => bloc.add(const AreaChanged(2)),
      expect: () => [
        isA<DataUpdatedState>().having((state) => state.data?.area, 'area', 2),
      ],
    );

    blocTest<EmployeeFormBloc, EmployeeFormState>(
      'emits [DataUpdatedState] when EntryDateChanged is added',
      build: () => employeeFormBloc,
      act: (bloc) => bloc.add(EntryDateChanged(DateTime(2023, 1, 1))),
      expect: () => [
        isA<DataUpdatedState>().having((state) => state.data?.entryDate,
            'entryDate', DateTime(2023, 1, 1)),
      ],
    );

    blocTest<EmployeeFormBloc, EmployeeFormState>(
      'emits [DataUpdatedState] when PhotoTaken is added',
      build: () => employeeFormBloc,
      act: (bloc) => bloc.add(PhotoTaken(MockFile())),
      expect: () => [
        isA<DataUpdatedState>().having(
            (state) => state.data?.photoFile, 'photoFile', isA<MockFile>()),
      ],
    );

    blocTest<EmployeeFormBloc, EmployeeFormState>(
      'emits [DataUpdatedState] with null photoFile when PhotoRemoved is added',
      build: () => employeeFormBloc,
      seed: () => DataUpdatedState(data: Data(photoFile: MockFile())),
      act: (bloc) => bloc.add(const PhotoRemoved()),
      expect: () => [
        isA<DataUpdatedState>()
            .having((state) => state.data?.photoFile, 'photoFile', isNull),
      ],
    );

    blocTest<EmployeeFormBloc, EmployeeFormState>(
      'emits [EmployeeFormSubmitting, EmployeeFormSubmissionSuccess] when SubmitForm is added and successful',
      build: () {
        when(() => mockEmployeesRepository.isEmailInUse(any()))
            .thenAnswer((_) async => false);
        when(() => mockEmployeesRepository.isIdNumberInUse(
                idType: any(named: 'idType'),
                idNumber: any(named: 'idNumber'),
                excludeEmployeeId: any(named: 'excludeEmployeeId')))
            .thenAnswer((_) async => false);
        when(() => mockFilesRepository.uploadImage(any()))
            .thenAnswer((_) async => 'http://example.com/photo.jpg');
        when(() => mockEmployeesRepository.addEmployee(any()))
            .thenAnswer((_) async => {});
        return employeeFormBloc;
      },
      seed: () => DataUpdatedState(
          data: Data(
        employmentCountry: 'CO',
        idType: 1,
        area: 2,
        entryDate: DateTime(2023, 1, 1),
        photoFile: MockFile(),
      )),
      act: (bloc) {
        bloc.add(SubmitForm(
          employee: employee,
        ));
      },
      expect: () => [
        isA<EmployeeFormSubmitting>(),
        isA<EmployeeFormSubmissionSuccess>(),
      ],
      verify: (_) {
        verify(() => mockEmployeesRepository.addEmployee(any())).called(1);
      },
    );

    blocTest<EmployeeFormBloc, EmployeeFormState>(
      'emits [EmployeeFormSubmitting, ImageUploadFailure] when SubmitForm is added and image upload fails',
      build: () {
        when(() => mockEmployeesRepository.isEmailInUse(any()))
            .thenAnswer((_) async => false);
        when(() => mockEmployeesRepository.isIdNumberInUse(
                idType: any(named: 'idType'),
                idNumber: any(named: 'idNumber'),
                excludeEmployeeId: any(named: 'excludeEmployeeId')))
            .thenAnswer((_) async => false);
        when(() => mockFilesRepository.uploadImage(any()))
            .thenThrow(Exception('Upload failed'));
        return employeeFormBloc;
      },
      seed: () => DataUpdatedState(
          data: Data(
        employmentCountry: 'CO',
        idType: 1,
        area: 2,
        entryDate: DateTime(2023, 1, 1),
        photoFile: MockFile(),
      )),
      act: (bloc) => bloc.add(SubmitForm(employee: employee)),
      expect: () => [
        isA<EmployeeFormSubmitting>(),
        isA<ImageUploadFailure>(),
      ],
    );

    blocTest<EmployeeFormBloc, EmployeeFormState>(
      'emits [EmployeeFormSubmitting, EmployeeFormSubmissionFailure] when SubmitForm is added and addEmployee fails',
      build: () {
        when(() => mockEmployeesRepository.isEmailInUse(any()))
            .thenAnswer((_) async => false);
        when(() => mockEmployeesRepository.isIdNumberInUse(
                idType: any(named: 'idType'),
                idNumber: any(named: 'idNumber'),
                excludeEmployeeId: any(named: 'excludeEmployeeId')))
            .thenAnswer((_) async => false);
        when(() => mockFilesRepository.uploadImage(any()))
            .thenAnswer((_) async => 'http://example.com/photo.jpg');
        when(() => mockEmployeesRepository.addEmployee(any()))
            .thenThrow(Exception('Add employee failed'));
        return employeeFormBloc;
      },
      seed: () => DataUpdatedState(
          data: Data(
        employmentCountry: 'CO',
        idType: 1,
        area: 2,
        entryDate: DateTime(2023, 1, 1),
        photoFile: MockFile(),
      )),
      act: (bloc) => bloc.add(SubmitForm(employee: employee)),
      expect: () => [
        isA<EmployeeFormSubmitting>(),
        isA<EmployeeFormSubmissionFailure>(),
      ],
    );

    blocTest<EmployeeFormBloc, EmployeeFormState>(
      'emits [EmployeeFormSubmitting, EmployeeFormSubmissionSuccess] when updateEmployee is successful',
      build: () {
        when(() => mockEmployeesRepository.isEmailInUse(any()))
            .thenAnswer((_) async => false);
        when(() => mockEmployeesRepository.isIdNumberInUse(
                idType: any(named: 'idType'),
                idNumber: any(named: 'idNumber'),
                excludeEmployeeId: any(named: 'excludeEmployeeId')))
            .thenAnswer((_) async => false);
        when(() => mockEmployeesRepository.updateEmployee(any()))
            .thenAnswer((_) async => {});
        return employeeFormBloc;
      },
      seed: () => DataUpdatedState(
          data: Data(
        employmentCountry: 'CO',
        idType: 1,
        area: 2,
        entryDate: DateTime(2023, 1, 1),
      )),
      act: (bloc) {
        bloc.add(SubmitForm(
          isEditing: true,
          oldEmployee: employee,
          employee: employee.copyWith(
            employmentCountry: 'CO',
            idType: 1,
            area: 2,
            entryDate: DateTime(2023, 1, 1),
          ),
        ));
      },
      expect: () => [
        isA<EmployeeFormSubmitting>(),
        isA<EmployeeFormSubmissionSuccess>(),
      ],
      errors: () => [],
      verify: (_) {
        verify(() => mockEmployeesRepository.updateEmployee(any())).called(1);
      },
    );

    blocTest<EmployeeFormBloc, EmployeeFormState>(
      'emits [EmployeeFormSubmitting, ImageUploadFailure] when image upload fails during update',
      build: () {
        when(() => mockEmployeesRepository.isEmailInUse(any()))
            .thenAnswer((_) async => false);
        when(() => mockEmployeesRepository.isIdNumberInUse(
                idType: any(named: 'idType'),
                idNumber: any(named: 'idNumber'),
                excludeEmployeeId: any(named: 'excludeEmployeeId')))
            .thenAnswer((_) async => false);
        when(() => mockFilesRepository.uploadImage(any()))
            .thenThrow(Exception('Upload failed'));
        return employeeFormBloc;
      },
      seed: () => DataUpdatedState(
          data: Data(
        employmentCountry: 'CO',
        idType: 1,
        area: 2,
        entryDate: DateTime(2023, 1, 1),
        photoFile: MockFile(),
      )),
      act: (bloc) => bloc.add(SubmitForm(employee: employee)),
      expect: () => [
        isA<EmployeeFormSubmitting>(),
        isA<ImageUploadFailure>(),
      ],
    );

    blocTest<EmployeeFormBloc, EmployeeFormState>(
      'emits [EmployeeFormSubmitting, EmployeeFormSubmissionFailure] when updateEmployee fails',
      build: () {
        when(() => mockEmployeesRepository.isEmailInUse(any()))
            .thenAnswer((_) async => false);
        when(() => mockEmployeesRepository.updateEmployee(any()))
            .thenThrow(Exception('Update employee failed'));
        return employeeFormBloc;
      },
      seed: () => DataUpdatedState(
          data: Data(
        employmentCountry: 'CO',
        idType: 1,
        area: 2,
        entryDate: DateTime(2023, 1, 1),
      )),
      act: (bloc) => bloc.add(SubmitForm(employee: employee)),
      expect: () => [
        isA<EmployeeFormSubmitting>(),
        isA<EmployeeFormSubmissionFailure>(),
      ],
    );

    blocTest<EmployeeFormBloc, EmployeeFormState>(
      'emits [EmployeeFormSubmitting, EmployeeFormIdNumberInUse] when ID number is already in use',
      build: () {
        when(() => mockEmployeesRepository.isIdNumberInUse(
              idType: any(named: 'idType'),
              idNumber: any(named: 'idNumber'),
              excludeEmployeeId: any(named: 'excludeEmployeeId'),
            )).thenAnswer((_) async => true);
        return employeeFormBloc;
      },
      seed: () => DataUpdatedState(
        data: Data(
          employmentCountry: 'CO',
          idType: 1,
          area: 2,
          entryDate: DateTime(2023, 1, 1),
          photoFile: MockFile(),
        ),
      ),
      act: (bloc) => bloc.add(SubmitForm(employee: employee)),
      expect: () => [
        isA<EmployeeFormSubmitting>(),
        isA<EmployeeFormIdNumberInUse>(),
      ],
      verify: (_) {
        verify(() => mockEmployeesRepository.isIdNumberInUse(
              idType: any(named: 'idType'),
              idNumber: any(named: 'idNumber'),
              excludeEmployeeId: any(named: 'excludeEmployeeId'),
            )).called(1);
      },
    );
  });
}
