import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String id;
  final String firstSurname;
  final String secondSurname;
  final String firstName;
  final String? otherNames;
  final String employmentCountry;
  final int idType;
  final String idNumber;
  final String email;
  final DateTime entryDate;
  final int area;
  final bool isActive;
  final DateTime? registrationDate;
  final String photoUrl;
  final DateTime? editionDate;

  String get fullName =>
      '$firstName ${otherNames ?? ''} $firstSurname $secondSurname';

  String get idTypeHumanReadable {
    switch (idType) {
      case 0:
        return 'Cédula de ciudadanía';
      case 1:
        return 'Cédula de extranjería';
      case 2:
        return 'Pasaporte';
      case 3:
        return 'Permiso especial';
      default:
        return 'Desconocido';
    }
  }

  String get areaHumanReadable {
    switch (area) {
      case 0:
        return 'Administración';
      case 1:
        return 'Financiera';
      case 2:
        return 'Compras';
      case 3:
        return 'Infraestructura';
      case 4:
        return 'Operaciones';
      case 5:
        return 'Talento Humano';
      case 6:
        return 'Servicios Varios';
      default:
        return 'Desconocido';
    }
  }

  String get countryHumanReadable {
    switch (employmentCountry) {
      case "CO":
        return 'Colombia';
      case "VE":
        return 'Venezuela';
      case "US":
        return 'Estados Unidos';
      default:
        return 'Desconocido';
    }
  }

  const Employee({
    required this.id,
    required this.firstSurname,
    required this.secondSurname,
    required this.firstName,
    this.otherNames,
    required this.employmentCountry,
    required this.idType,
    required this.idNumber,
    required this.email,
    required this.entryDate,
    required this.area,
    this.isActive = true,
    required this.registrationDate,
    required this.photoUrl,
    this.editionDate,
  });

  Employee copyWith({
    String? id,
    String? photoUrl,
    DateTime? editionDate,
    int? area,
    bool? isActive,
    DateTime? entryDate,
    DateTime? registrationDate,
    String? firstSurname,
    String? secondSurname,
    String? firstName,
    String? otherNames,
    int? idType,
    String? idNumber,
    String? email,
    String? employmentCountry,
  }) =>
      Employee(
        id: id ?? this.id,
        photoUrl: photoUrl ?? this.photoUrl,
        editionDate: editionDate ?? this.editionDate,
        area: area ?? this.area,
        isActive: isActive ?? this.isActive,
        entryDate: entryDate ?? this.entryDate,
        registrationDate: registrationDate ?? this.registrationDate,
        firstSurname: firstSurname ?? this.firstSurname,
        secondSurname: secondSurname ?? this.secondSurname,
        firstName: firstName ?? this.firstName,
        otherNames: otherNames ?? this.otherNames,
        employmentCountry: employmentCountry ?? this.employmentCountry,
        idType: idType ?? this.idType,
        idNumber: idNumber ?? this.idNumber,
        email: email ?? this.email,
      );

  @override
  List<Object?> get props => [
        id,
        firstSurname,
        secondSurname,
        firstName,
        otherNames,
        employmentCountry,
        idType,
        idNumber,
        email,
        entryDate,
        area,
        isActive,
        registrationDate,
        photoUrl,
        editionDate,
      ];
}
