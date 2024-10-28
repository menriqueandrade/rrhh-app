import 'package:equatable/equatable.dart';

class EmployeeFilter extends Equatable {
  final String? firstName;
  final String? otherNames;
  final String? firstSurname;
  final String? secondSurname;
  final int? idType;
  final String? idNumber;
  final String? employmentCountry;
  final String? email;
  final bool? isActive;

  const EmployeeFilter({
    this.firstName,
    this.otherNames,
    this.firstSurname,
    this.secondSurname,
    this.idType,
    this.idNumber,
    this.employmentCountry,
    this.email,
    this.isActive,
  });

  EmployeeFilter copyWith({
    String? firstName,
    String? otherNames,
    String? firstSurname,
    String? secondSurname,
    int? idType,
    String? idNumber,
    String? employmentCountry,
    String? email,
    bool? isActive,
  }) {
    return EmployeeFilter(
      firstName: firstName ?? this.firstName,
      otherNames: otherNames ?? this.otherNames,
      firstSurname: firstSurname ?? this.firstSurname,
      secondSurname: secondSurname ?? this.secondSurname,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
      employmentCountry: employmentCountry ?? this.employmentCountry,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (firstName != null) 'firstName': firstName,
      if (otherNames != null) 'otherNames': otherNames,
      if (firstSurname != null) 'firstSurname': firstSurname,
      if (secondSurname != null) 'secondSurname': secondSurname,
      if (idType != null) 'idType': idType,
      if (idNumber != null) 'idNumber': idNumber,
      if (employmentCountry != null) 'employmentCountry': employmentCountry,
      if (email != null) 'email': email,
      if (isActive != null) 'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [
        firstName,
        otherNames,
        firstSurname,
        secondSurname,
        idType,
        idNumber,
        employmentCountry,
        email,
        isActive,
      ];
}
