import 'dart:async';

import 'package:employees/features/employess/domain/entities/employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:employees/features/employess/domain/entities/employee_filter.dart';
import 'package:employees/features/employess/domain/entities/employees_data.dart';
import 'package:employees/features/employess/domain/repositories/employess_repository.dart';

part 'employees_event.dart';
part 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final EmployeesRepository employeesRepository;

  EmployeesBloc({required this.employeesRepository})
      : super(const EmployeesInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<LoadMoreEmployees>(_onLoadMoreEmployees);
    on<UpdateFilter>(_onUpdateFilter);
    on<ApplyFilter>(_onApplyFilter);
    on<ResetFilter>(_onResetFilter);
    on<EmployeeAdded>(_onEmployeeAdded);
    on<EmployeeDeleted>(_onEmployeeDeleted);
    on<EmployeeUpdated>(_onEmployeeUpdated);
  }

  void _onLoadEmployees(
      LoadEmployees event, Emitter<EmployeesState> emit) async {
    emit(EmployeesLoading(filter: state.filter));
    try {
      final employeesData = await employeesRepository.getEmployees(
        page: event.page,
        limit: event.limit,
      );
      emit(EmployeesLoaded(employeeData: employeesData, filter: state.filter));
    } catch (e) {
      emit(EmployeesError(filter: state.filter));
    }
  }

  void _onLoadMoreEmployees(
      LoadMoreEmployees event, Emitter<EmployeesState> emit) async {
    if (state is EmployeesLoaded) {
      final currentState = state as EmployeesLoaded;
      if (currentState.employeeData.page <
          currentState.employeeData.totalPages) {
        emit(EmployeesLoadingMore(
            employeeData: currentState.employeeData,
            filter: currentState.filter));
        try {
          final newEmployeesData = await employeesRepository.getEmployees(
            page: currentState.employeeData.page + 1,
            limit: 10,
          );
          final updatedEmployees = [
            ...currentState.employeeData.employees,
            ...newEmployeesData.employees,
          ];
          emit(EmployeesLoaded(
            employeeData: EmployeeData(
              employees: updatedEmployees,
              page: newEmployeesData.page,
              totalPages: newEmployeesData.totalPages,
              totalEmployees: newEmployeesData.totalEmployees,
            ),
            filter: currentState.filter,
          ));
        } catch (e) {
          emit(EmployeesError(filter: currentState.filter));
        }
      }
    }
  }

  void _onUpdateFilter(UpdateFilter event, Emitter<EmployeesState> emit) {
    emit(EmployeesLoaded(
      employeeData: (state as EmployeesLoaded).employeeData,
      filter: event.filter,
    ));
  }

  void _onApplyFilter(ApplyFilter event, Emitter<EmployeesState> emit) async {
    emit(EmployeesLoading(filter: state.filter));
    try {
      final filteredEmployeesData = await employeesRepository
          .getEmployeesWithFilter(state.filter.toMap());
      emit(EmployeesLoadedWithFilter(
          employeeData: filteredEmployeesData, filter: state.filter));
    } catch (e) {
      emit(EmployeesError(filter: state.filter));
    }
  }

  void _onResetFilter(ResetFilter event, Emitter<EmployeesState> emit) {
    emit(const EmployeesInitial());
    add(const LoadEmployees());
  }

  FutureOr<void> _onEmployeeAdded(
      EmployeeAdded event, Emitter<EmployeesState> emit) {
    final currentState = state as EmployeesLoaded;
    final updatedEmployees = [
      event.employee,
      ...currentState.employeeData.employees,
    ];
    emit(EmployeesLoaded(
      employeeData: EmployeeData(
        employees: updatedEmployees,
        page: currentState.employeeData.page,
        totalPages: currentState.employeeData.totalPages,
        totalEmployees: currentState.employeeData.totalEmployees + 1,
      ),
      filter: currentState.filter,
    ));
  }

  FutureOr<void> _onEmployeeDeleted(
    EmployeeDeleted event,
    Emitter<EmployeesState> emit,
  ) async {
    try {
      await employeesRepository.deleteEmployee(event.employee.id);
      final currentState = state as EmployeesLoaded;

      final employees = currentState.employeeData.employees
          .where((employee) => employee.id != event.employee.id)
          .toList();

      emit(EmployeesDeletedSuccess(
        employeeData: currentState.employeeData.copyWith(
          employees: employees,
          totalEmployees: currentState.employeeData.totalEmployees - 1,
        ),
        filter: currentState.filter,
      ));
    } catch (e) {
      emit(EmployeesDeletedFailed(
        employeeData: (state as EmployeesLoaded).employeeData,
        filter: state.filter,
      ));
    }
  }

  FutureOr<void> _onEmployeeUpdated(
      EmployeeUpdated event, Emitter<EmployeesState> emit) async {
    final currentState = state as EmployeesLoaded;
    final updatedEmployees = currentState.employeeData.employees
        .map((employee) =>
            employee.id == event.employee.id ? event.employee : employee)
        .toList();

    emit(EmployeesLoaded(
      employeeData:
          currentState.employeeData.copyWith(employees: updatedEmployees),
      filter: currentState.filter,
    ));
  }
}
