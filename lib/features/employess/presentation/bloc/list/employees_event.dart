part of 'employees_bloc.dart';

abstract class EmployeesEvent extends Equatable {
  const EmployeesEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployees extends EmployeesEvent {
  final int page;
  final int limit;

  const LoadEmployees({this.page = 1, this.limit = 10});
}

class LoadMoreEmployees extends EmployeesEvent {}

class UpdateFilter extends EmployeesEvent {
  final EmployeeFilter filter;

  const UpdateFilter(this.filter);

  @override
  List<Object> get props => [filter];
}

class ApplyFilter extends EmployeesEvent {}

class ResetFilter extends EmployeesEvent {}

class EmployeeAdded extends EmployeesEvent {
  final Employee employee;

  const EmployeeAdded(this.employee);
}

class EmployeeDeleted extends EmployeesEvent {
  final Employee employee;

  const EmployeeDeleted(this.employee);
}

class EmployeeUpdated extends EmployeesEvent {
  final Employee employee;

  const EmployeeUpdated(this.employee);
}

class GenerateFakeEmployees extends EmployeesEvent {
  final int numberOfEmployees;

  const GenerateFakeEmployees(this.numberOfEmployees);
}
