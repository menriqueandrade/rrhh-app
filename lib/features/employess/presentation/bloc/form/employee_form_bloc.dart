import 'package:employees/features/employess/domain/entities/employee.dart';
import 'package:employees/features/employess/domain/usecases/generate_employee_email.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:employees/features/employess/domain/repositories/employess_repository.dart';
import 'package:employees/features/employess/domain/repositories/file_upload_repository.dart';
import 'dart:io';

part 'employee_form_event.dart';
part 'employee_form_state.dart';

class EmployeeFormBloc extends Bloc<EmployeeFormEvent, EmployeeFormState> {
  final EmployeesRepository employeesRepository;
  final FilesRepository fileUploadRepository;
  final GenerateEmployeeEmail generateEmployeeEmail;

  EmployeeFormBloc({
    required this.employeesRepository,
    required this.fileUploadRepository,
    required this.generateEmployeeEmail,
  }) : super(const EmployeeFormInitial()) {
    on<InitializeEditForm>(_onInitializeEditForm);
    on<InitializeCreateForm>(_onInitializeCreateForm);
    on<EmploymentCountryChanged>(_onEmploymentCountryChanged);
    on<IdTypeChanged>(_onIdTypeChanged);
    on<AreaChanged>(_onAreaChanged);
    on<EntryDateChanged>(_onEntryDateChanged);
    on<PhotoTaken>(_onPhotoTaken);
    on<PhotoRemoved>(_onPhotoRemoved);
    on<SubmitForm>(_onSubmitForm);
  }

  void _onInitializeEditForm(
      InitializeEditForm event, Emitter<EmployeeFormState> emit) {
    emit(EmployeeFormInitial(
        data: Data(
      employmentCountry: event.employee.employmentCountry,
      idType: event.employee.idType,
      area: event.employee.area,
      entryDate: event.employee.entryDate,
    )));
  }

  void _onEmploymentCountryChanged(
      EmploymentCountryChanged event, Emitter<EmployeeFormState> emit) {
    emit(DataUpdatedState(
        data: state.data?.copyWith(employmentCountry: event.country)));
  }

  void _onInitializeCreateForm(
      InitializeCreateForm event, Emitter<EmployeeFormState> emit) {
    emit(const EmployeeFormInitial());
  }

  void _onIdTypeChanged(IdTypeChanged event, Emitter<EmployeeFormState> emit) {
    emit(DataUpdatedState(data: state.data?.copyWith(idType: event.idType)));
  }

  void _onAreaChanged(AreaChanged event, Emitter<EmployeeFormState> emit) {
    emit(DataUpdatedState(data: state.data?.copyWith(area: event.area)));
  }

  void _onEntryDateChanged(
      EntryDateChanged event, Emitter<EmployeeFormState> emit) {
    emit(DataUpdatedState(data: state.data?.copyWith(entryDate: event.date)));
  }

  void _onPhotoTaken(PhotoTaken event, Emitter<EmployeeFormState> emit) {
    emit(DataUpdatedState(
        data: state.data?.copyWith(photoFile: event.photoFile)));
  }

  void _onPhotoRemoved(PhotoRemoved event, Emitter<EmployeeFormState> emit) {
    emit(DataUpdatedState(data: state.data?.copyWithRemovePhoto()));
  }

  void _onSubmitForm(SubmitForm event, Emitter<EmployeeFormState> emit) async {
    emit(EmployeeFormSubmitting(data: state.data));
    try {
      final isIdInUse = await employeesRepository.isIdNumberInUse(
        idType: event.employee.idType,
        idNumber: event.employee.idNumber,
        excludeEmployeeId: event.isEditing ? event.employee.id : null,
      );

      if (isIdInUse) {
        emit(EmployeeFormIdNumberInUse(data: state.data));
        return;
      }

      final generateEmail =
          (event.employee.firstName != event.oldEmployee?.firstName ||
              event.employee.employmentCountry !=
                  event.oldEmployee?.employmentCountry ||
              event.employee.firstSurname != event.oldEmployee?.firstSurname);

      final email = generateEmail
          ? await generateEmployeeEmail.execute(
              firstName: event.employee.firstName,
              lastName: event.employee.firstSurname,
              employmentCountry: event.employee.employmentCountry,
            )
          : event.employee.email;

      String? photoUrl;

      if (state.data!.photoFile != null) {
        try {
          photoUrl =
              await fileUploadRepository.uploadImage(state.data!.photoFile!);
        } catch (e) {
          emit(ImageUploadFailure(data: state.data));
          return;
        }
      }
      final finalEmployee = event.employee.copyWith(
        photoUrl: photoUrl ?? event.employee.photoUrl,
        email: email,
        id: event.isEditing ? event.employee.id : const Uuid().v4(),
      );
      if (event.isEditing) {
        await employeesRepository.updateEmployee(finalEmployee);
      } else {
        await employeesRepository.addEmployee(finalEmployee);
      }

      emit(EmployeeFormSubmissionSuccess(
        data: const Data(),
        employee: finalEmployee,
      ));
    } catch (e) {
      emit(EmployeeFormSubmissionFailure(data: state.data));
    }
  }
}
