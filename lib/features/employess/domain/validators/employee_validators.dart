import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmployeeValidators {
  final AppLocalizations l10n;

  EmployeeValidators(this.l10n);

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.requiredField;
    }
    if (value.length > 20) {
      return l10n.max20Chars;
    }
    if (!RegExp(r'^[A-ZÑ ]+$').hasMatch(value)) {
      if (value.contains(RegExp(r'[a-z]'))) {
        return l10n.onlyUppercaseLetters;
      }
      if (value.contains(RegExp(r'[áéíóúÁÉÍÓÚ]'))) {
        return l10n.noAccents;
      }
      return l10n.onlyLettersAndSpaces;
    }
    return null;
  }

  String? validateOtherNames(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length > 50) {
      return l10n.max50Chars;
    }
    if (!RegExp(r'^[A-ZÑ ]+$').hasMatch(value)) {
      if (value.contains(RegExp(r'[a-z]'))) {
        return l10n.onlyUppercaseLetters;
      }
      if (value.contains(RegExp(r'[áéíóúÁÉÍÓÚ]'))) {
        return l10n.noAccents;
      }
      return l10n.onlyLettersAndSpaces;
    }
    return null;
  }

  String? validateIdNumber(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.requiredField;
    }
    if (value.length > 20) {
      return l10n.max20Chars;
    }
    if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(value)) {
      return l10n.onlyLettersNumbersAndHyphens;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value ?? '')) {
      return l10n.invalidEmail;
    }
    return null;
  }
}
