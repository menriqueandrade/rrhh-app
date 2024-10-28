import 'package:employees/features/employess/domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required super.id,
    required super.firstSurname,
    required super.secondSurname,
    required super.firstName,
    super.otherNames,
    required super.employmentCountry,
    required super.idType,
    required super.idNumber,
    required super.email,
    required super.entryDate,
    required super.area,
    super.isActive = true,
    required super.registrationDate,
    required super.photoUrl,
    super.editionDate,
  });
  factory EmployeeModel.fromJson(Map<String, dynamic> json, String id) {
    return EmployeeModel(
      id: id,
      firstSurname: json['firstSurname'],
      secondSurname: json['secondSurname'],
      firstName: json['firstName'],
      otherNames: json['otherNames'],
      employmentCountry: json['employmentCountry'],
      idType: json['idType'],
      idNumber: json['idNumber'],
      email: json['email'],
      entryDate: json['entryDate'].toDate(),
      area: json['area'],
      isActive: json['isActive'],
      registrationDate: json['registrationDate'].toDate(),
      photoUrl: json['photoUrl'],
      editionDate: json['editionDate']?.toDate(),
    );
  }

  factory EmployeeModel.fromEntity(Employee employee) {
    return EmployeeModel(
      id: employee.id,
      area: employee.area,
      entryDate: employee.entryDate,
      firstSurname: employee.firstSurname,
      secondSurname: employee.secondSurname,
      firstName: employee.firstName,
      otherNames: employee.otherNames,
      employmentCountry: employee.employmentCountry,
      idType: employee.idType,
      idNumber: employee.idNumber,
      email: employee.email,
      registrationDate: employee.registrationDate,
      photoUrl: employee.photoUrl,
      editionDate: employee.editionDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstSurname': firstSurname,
      'secondSurname': secondSurname,
      'firstName': firstName,
      'otherNames': otherNames,
      'employmentCountry': employmentCountry,
      'idType': idType,
      'idNumber': idNumber,
      'email': email,
      'entryDate': entryDate,
      'area': area,
      'isActive': isActive,
      'registrationDate': registrationDate,
      'photoUrl': photoUrl,
      'editionDate': editionDate,
    };
  }

  @override
  EmployeeModel copyWith({
    String? id,
    String? firstSurname,
    String? secondSurname,
    String? firstName,
    String? otherNames,
    String? employmentCountry,
    int? idType,
    String? idNumber,
    String? email,
    DateTime? entryDate,
    int? area,
    bool? isActive,
    DateTime? registrationDate,
    String? photoUrl,
    DateTime? editionDate,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      firstSurname: firstSurname ?? this.firstSurname,
      secondSurname: secondSurname ?? this.secondSurname,
      firstName: firstName ?? this.firstName,
      otherNames: otherNames ?? this.otherNames,
      employmentCountry: employmentCountry ?? this.employmentCountry,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
      email: email ?? this.email,
      entryDate: entryDate ?? this.entryDate,
      area: area ?? this.area,
      isActive: isActive ?? this.isActive,
      registrationDate: registrationDate ?? this.registrationDate,
      photoUrl: photoUrl ?? this.photoUrl,
      editionDate: editionDate ?? this.editionDate,
    );
  }
}
