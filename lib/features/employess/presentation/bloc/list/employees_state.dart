part of 'employees_bloc.dart';

abstract class EmployeesState extends Equatable {
  final EmployeeFilter filter;
  final Map<int, String> idTypes;
  final Map<String, String> countries;

  const EmployeesState({
    required this.filter,
    this.idTypes = const {
      0: 'Cédula de Ciudadanía',
      1: 'Cédula de Extranjería',
      2: 'Pasaporte',
      3: 'Permiso Especial',
    },
    this.countries = const {
      'CO': 'Colombia',
      'US': 'Estados Unidos',
      'VE': 'Venezuela',
    },
  });

  @override
  List<Object> get props => [filter, idTypes, countries];
}

class EmployeesInitial extends EmployeesState {
  const EmployeesInitial() : super(filter: const EmployeeFilter());
}

class EmployeesLoading extends EmployeesState {
  const EmployeesLoading({required super.filter});
}

class EmployeesLoaded extends EmployeesState {
  final EmployeeData employeeData;

  const EmployeesLoaded({required this.employeeData, required super.filter});

  @override
  List<Object> get props => [employeeData, filter];
}

class EmployeesError extends EmployeesState {
  const EmployeesError({required super.filter});

  @override
  List<Object> get props => [filter];
}

class EmployeesLoadingMore extends EmployeesLoaded {
  const EmployeesLoadingMore(
      {required super.employeeData, required super.filter});
}

class EmployeesLoadedWithFilter extends EmployeesLoaded {
  const EmployeesLoadedWithFilter(
      {required super.employeeData, required super.filter});
}

class EmployeesDeletedSuccess extends EmployeesLoaded {
  const EmployeesDeletedSuccess(
      {required super.employeeData, required super.filter});
}

class EmployeesDeletedFailed extends EmployeesLoaded {
  const EmployeesDeletedFailed(
      {required super.employeeData, required super.filter});
}
