import 'package:employees/features/employess/domain/entities/employee.dart';
import 'package:employees/features/employess/presentation/screens/employee_form_screen.dart';
import 'package:employees/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../bloc/list/employees_bloc.dart';
import '../widgets/employee_list.dart';
import '../widgets/employee_filter_bottom_sheet.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/empty_employees_view.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EmployeesBloc>()..add(const LoadEmployees()),
      child: EmployeesView(),
    );
  }
}

class EmployeesView extends StatelessWidget {
  EmployeesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.employeeList,
        ),
        actions: [
          IconButton(
            tooltip: l10n.logs,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TalkerScreen(
                        talker: getIt<Talker>(),
                        appBarTitle: l10n.logs,
                        theme: const TalkerScreenTheme(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          cardColor: Colors.grey,
                          logColors: {TalkerLogType.route: Colors.black},
                        ),
                      )),
            ),
            icon: const Icon(Icons.bug_report),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: BlocConsumer<EmployeesBloc, EmployeesState>(
          listener: (context, state) {
            if (state is EmployeesDeletedFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(l10n.errorDeletingEmployee),
                ),
              );
            }

            if (state is EmployeesDeletedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(l10n.employeeDeletedSuccessfully),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is EmployeesError) {
              return ErrorView(
                onRetry: () =>
                    context.read<EmployeesBloc>().add(const LoadEmployees()),
              );
            }

            if (state is EmployeesLoading) {
              return Center(child: LoadingView(message: l10n.loadingEmployees));
            }

            if (state is EmployeesLoadedWithFilter &&
                state.employeeData.employees.isEmpty) {
              return EmptyEmployeesView(
                message: l10n.noEmployeesFoundFilter,
                buttonText: l10n.resetFilters,
                onButtonPressed: () =>
                    context.read<EmployeesBloc>().add(ResetFilter()),
              );
            }

            if (state is EmployeesLoaded &&
                state.employeeData.employees.isEmpty) {
              return EmptyEmployeesView(
                message: l10n.addNewEmployeeToStart,
              );
            }

            if (state is EmployeesLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<EmployeesBloc>().add(const LoadEmployees());
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.loadedEmployees(
                              state.employeeData.employees.length.toString(),
                              state.employeeData.totalEmployees.toString(),
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          InkWell(
                            onTap: () => _showFilterBottomSheet(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(l10n.filter,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    )),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.filter_list,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: EmployeeList(
                        employeeData: state.employeeData,
                        isLoadingMore: state is EmployeesLoadingMore,
                        onLoadMore: () => context
                            .read<EmployeesBloc>()
                            .add(LoadMoreEmployees()),
                        onDelete: (employee) async {
                          final confirmed = await _showDeleteConfirmationDialog(
                              context, employee);
                          if (confirmed != null && confirmed) {
                            context
                                .read<EmployeesBloc>()
                                .add(EmployeeDeleted(employee));
                          }
                        },
                        onEdit: (employee) => _editEmployee(context, employee),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewEmployee(context),
        tooltip: l10n.addEmployee,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => EmployeeFilterBottomSheet(),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(
      BuildContext context, Employee employee) async {
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.deleteEmployee),
          content: Text(l10n.confirmDeleteEmployee),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.no),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(l10n.yes),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewEmployee(BuildContext context) async {
    final employee = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeFormScreen()),
    );

    if (employee != null) {
      context.read<EmployeesBloc>().add(EmployeeAdded(employee));
    }
  }

  void _editEmployee(BuildContext context, Employee employee) async {
    final updatedEmployee = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EmployeeFormScreen(employee: employee)),
    );

    if (updatedEmployee != null) {
      context.read<EmployeesBloc>().add(EmployeeUpdated(updatedEmployee));
    }
  }
}
