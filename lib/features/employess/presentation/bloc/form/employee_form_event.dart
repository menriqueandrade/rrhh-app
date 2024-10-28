part of 'employee_form_bloc.dart';

abstract class EmployeeFormEvent extends Equatable {
  const EmployeeFormEvent();

  @override
  List<Object?> get props => [];
}

class EmploymentCountryChanged extends EmployeeFormEvent {
  final String country;

  const EmploymentCountryChanged(this.country);

  @override
  List<Object?> get props => [country];
}

class IdTypeChanged extends EmployeeFormEvent {
  final int idType;

  const IdTypeChanged(this.idType);

  @override
  List<Object?> get props => [idType];
}

class AreaChanged extends EmployeeFormEvent {
  final int area;

  const AreaChanged(this.area);

  @override
  List<Object?> get props => [area];
}

class EntryDateChanged extends EmployeeFormEvent {
  final DateTime date;

  const EntryDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class PhotoTaken extends EmployeeFormEvent {
  final File photoFile;

  const PhotoTaken(this.photoFile);

  @override
  List<Object?> get props => [photoFile];
}

class PhotoRemoved extends EmployeeFormEvent {
  const PhotoRemoved();
}

class SubmitForm extends EmployeeFormEvent {
  final Employee employee;
  final Employee? oldEmployee;
  final bool isEditing;

  const SubmitForm({
    this.isEditing = false,
    required this.employee,
    this.oldEmployee,
  });

  @override
  List<Object?> get props => [];
}

class InitializeEditForm extends EmployeeFormEvent {
  final Employee employee;

  const InitializeEditForm(this.employee);
}

class InitializeCreateForm extends EmployeeFormEvent {
  const InitializeCreateForm();
}
