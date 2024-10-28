import 'package:flutter_test/flutter_test.dart';
import 'package:employees/features/employess/domain/validators/employee_validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';

void main() {
  late EmployeeValidators validators;
  late AppLocalizations l10n;

  setUp(() {
    l10n = AppLocalizationsEn();
    validators = EmployeeValidators(l10n);
  });

  group('validateName', () {
    test('should return null for valid names', () {
      expect(validators.validateName('JUAN'), isNull);
      expect(validators.validateName('DE LA CALLE'), isNull);
      expect(validators.validateName('NUÑEZ'), isNull);
    });

    test('should return error for empty name', () {
      expect(validators.validateName(''), equals(l10n.requiredField));
    });

    test('should return error for name longer than 20 characters', () {
      expect(validators.validateName('ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
          equals(l10n.max20Chars));
    });

    test('should return error for name with lowercase letters', () {
      expect(
          validators.validateName('juan'), equals(l10n.onlyUppercaseLetters));
    });

    test('should return error for name with accents', () {
      expect(validators.validateName('JOSÉ'), equals(l10n.noAccents));
    });

    test('should return error for name with invalid characters', () {
      expect(validators.validateName('JUAN123'),
          equals(l10n.onlyLettersAndSpaces));
    });
  });

  group('validateOtherNames', () {
    test('should return null for valid other names', () {
      expect(validators.validateOtherNames('JOSE'), isNull);
      expect(validators.validateOtherNames('DE LA CRUZ'), isNull);
      expect(validators.validateOtherNames(''), isNull);
      expect(validators.validateOtherNames('MARIA LUISA'), isNull);
    });

    test('should return error for other names longer than 50 characters', () {
      expect(validators.validateOtherNames('A' * 51), equals(l10n.max50Chars));
    });

    test('should return error for other names with lowercase letters', () {
      expect(validators.validateOtherNames('jose'),
          equals(l10n.onlyUppercaseLetters));
    });

    test('should return error for other names with accents', () {
      expect(validators.validateOtherNames('MARÍA'), equals(l10n.noAccents));
    });

    test('should return error for other names with invalid characters', () {
      expect(validators.validateOtherNames('JOSE123'),
          equals(l10n.onlyLettersAndSpaces));
    });
  });

  group('validateIdNumber', () {
    test('should return null for valid ID numbers', () {
      expect(validators.validateIdNumber('123456'), isNull);
      expect(validators.validateIdNumber('ABC-123'), isNull);
    });

    test('should return error for empty ID number', () {
      expect(validators.validateIdNumber(''), equals(l10n.requiredField));
    });

    test('should return error for ID number longer than 20 characters', () {
      expect(validators.validateIdNumber('12345678901234567890A'),
          equals(l10n.max20Chars));
    });

    test('should return error for ID number with invalid characters', () {
      expect(validators.validateIdNumber('ABC 123'),
          equals(l10n.onlyLettersNumbersAndHyphens));
    });
  });
}
