import '../repositories/employess_repository.dart';

class GenerateEmployeeEmail {
  final EmployeesRepository repository;

  GenerateEmployeeEmail(this.repository);

  Future<String> execute({
    required String firstName,
    required String lastName,
    required String employmentCountry,
  }) async {
    try {
      final baseEmail = _generateBaseEmail(firstName, lastName);
      final domain = _getDomainForCountry(employmentCountry);

      var email = '$baseEmail@$domain';
      var counter = 1;

      while (await repository.isEmailInUse(email)) {
        email = '$baseEmail.$counter@$domain';
        counter++;
      }

      return email;
    } catch (e) {
      throw EmailGenerationFailure();
    }
  }

  String _generateBaseEmail(String firstName, String lastName) {
    final normalizedFirstName = _normalizeString(firstName);
    final normalizedLastName = _normalizeString(lastName);
    return '$normalizedFirstName.$normalizedLastName'.toLowerCase();
  }

  String _getDomainForCountry(String country) {
    switch (country.toUpperCase()) {
      case 'VE':
        return 'armirene.com.ve';
      default:
        return 'tuarmi.com.co';
    }
  }

  String _normalizeString(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll(RegExp(r'[áàäâã]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöôõ]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll(RegExp(r'ñ'), 'n');
  }
}

class Failure {}

class EmailGenerationFailure extends Failure {}
