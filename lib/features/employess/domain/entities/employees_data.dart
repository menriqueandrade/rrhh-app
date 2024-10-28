import 'package:employees/features/employess/domain/entities/employee.dart';
import 'package:equatable/equatable.dart';

class EmployeeData extends Equatable {
  final int page;
  final int totalPages;
  final int totalEmployees;
  final List<Employee> employees;

  const EmployeeData({
    required this.page,
    required this.totalPages,
    required this.totalEmployees,
    required this.employees,
  });

  EmployeeData copyWith({
    int? page,
    int? totalPages,
    int? totalEmployees,
    List<Employee>? employees,
  }) {
    return EmployeeData(
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      totalEmployees: totalEmployees ?? this.totalEmployees,
      employees: employees ?? this.employees,
    );
  }

  @override
  List<Object?> get props => [page, totalPages, totalEmployees, employees];
}
