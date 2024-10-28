import 'package:employees/features/employess/domain/repositories/employess_repository.dart';
import 'package:employees/features/employess/domain/usecases/generate_employee_email.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEmployeesRepository extends Mock implements EmployeesRepository {}

void main() {
  late GenerateEmployeeEmail useCase;
  late MockEmployeesRepository mockRepository;

  setUp(() {
    mockRepository = MockEmployeesRepository();
    useCase = GenerateEmployeeEmail(mockRepository);
  });

  test('should generate correct email for first employee in Colombia',
      () async {
    when(() => mockRepository.isEmailInUse(any()))
        .thenAnswer((_) async => false);

    final result = await useCase.execute(
      firstName: 'Juan',
      lastName: 'Perez',
      employmentCountry: 'CO',
    );

    expect(result, equals('juan.perez@tuarmi.com.co'));
  });

  test('should generate correct email for first employee in Venezuela',
      () async {
    when(() => mockRepository.isEmailInUse(any()))
        .thenAnswer((_) async => false);

    final result = await useCase.execute(
      firstName: 'Maria',
      lastName: 'Gonzalez',
      employmentCountry: 'VE',
    );

    expect(result, equals('maria.gonzalez@armirene.com.ve'));
  });

  test('should generate email with counter for duplicate in Colombia',
      () async {
    when(() => mockRepository.isEmailInUse('juan.perez@tuarmi.com.co'))
        .thenAnswer((_) async => true);
    when(() => mockRepository.isEmailInUse('juan.perez.1@tuarmi.com.co'))
        .thenAnswer((_) async => false);

    final result = await useCase.execute(
      firstName: 'Juan',
      lastName: 'Perez',
      employmentCountry: 'CO',
    );

    expect(result, equals('juan.perez.1@tuarmi.com.co'));
  });

  test('should generate email with counter for duplicate in Venezuela',
      () async {
    when(() => mockRepository.isEmailInUse('maria.gonzalez@armirene.com.ve'))
        .thenAnswer((_) async => true);
    when(() => mockRepository.isEmailInUse('maria.gonzalez.1@armirene.com.ve'))
        .thenAnswer((_) async => true);
    when(() => mockRepository.isEmailInUse('maria.gonzalez.2@armirene.com.ve'))
        .thenAnswer((_) async => false);

    final result = await useCase.execute(
      firstName: 'Maria',
      lastName: 'Gonzalez',
      employmentCountry: 'VE',
    );

    expect(result, equals('maria.gonzalez.2@armirene.com.ve'));
  });

  test('should handle compound last names', () async {
    when(() => mockRepository.isEmailInUse(any()))
        .thenAnswer((_) async => false);

    final result = await useCase.execute(
      firstName: 'Juan',
      lastName: 'De La Calle',
      employmentCountry: 'CO',
    );

    expect(result, equals('juan.delacalle@tuarmi.com.co'));
  });

  test('should normalize accented characters', () async {
    when(() => mockRepository.isEmailInUse(any()))
        .thenAnswer((_) async => false);

    final result = await useCase.execute(
      firstName: 'José',
      lastName: 'Martínez',
      employmentCountry: 'VE',
    );

    expect(result, equals('jose.martinez@armirene.com.ve'));
  });

  test('should handle multiple names', () async {
    when(() => mockRepository.isEmailInUse(any()))
        .thenAnswer((_) async => false);

    final result = await useCase.execute(
      firstName: 'Juan Carlos',
      lastName: 'Perez Montoya',
      employmentCountry: 'CO',
    );

    expect(result, equals('juancarlos.perezmontoya@tuarmi.com.co'));
  });

  test('should throw EmailGenerationFailure when repository throws', () async {
    when(() => mockRepository.isEmailInUse(any()))
        .thenThrow(Exception('Database error'));

    expect(
        () => useCase.execute(
              firstName: 'Juan',
              lastName: 'Perez',
              employmentCountry: 'CO',
            ),
        throwsA(isA<EmailGenerationFailure>()));
  });
}
