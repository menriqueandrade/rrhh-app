import 'package:employees/features/employess/presentation/widgets/primary_button.dart';
import 'package:employees/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employees/features/employess/presentation/bloc/list/employees_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:employees/features/employess/presentation/widgets/custom_text_field.dart';
import 'package:employees/features/employess/presentation/widgets/custom_dropdown.dart';

class EmployeeFilterBottomSheet extends StatelessWidget {
  EmployeeFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: BlocProvider.value(
        value: getIt<EmployeesBloc>(),
        child: BlocBuilder<EmployeesBloc, EmployeesState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.filterEmployees,
                            style: Theme.of(context).textTheme.titleLarge),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      initialValue: state.filter.firstName,
                      label: l10n.firstName,
                      onChanged: (value) =>
                          _updateFilter(context, firstName: value),
                      maxLength: 20,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        OnlyLettersTextFormatter()
                      ],
                    ),
                    CustomTextField(
                      initialValue: state.filter.otherNames,
                      label: l10n.otherNames,
                      onChanged: (value) =>
                          _updateFilter(context, otherNames: value),
                      maxLength: 50,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        OnlyLettersTextFormatter()
                      ],
                    ),
                    CustomTextField(
                      initialValue: state.filter.firstSurname,
                      label: l10n.firstSurname,
                      onChanged: (value) =>
                          _updateFilter(context, firstSurname: value),
                      maxLength: 20,
                      inputFormatters: [UpperCaseTextFormatter()],
                    ),
                    CustomTextField(
                      initialValue: state.filter.secondSurname,
                      label: l10n.secondSurname,
                      onChanged: (value) =>
                          _updateFilter(context, secondSurname: value),
                      maxLength: 20,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        OnlyLettersTextFormatter()
                      ],
                    ),
                    CustomDropdown(
                      label: l10n.idType,
                      value: state.filter.idType,
                      items: state.idTypes,
                      onChanged: (value) =>
                          _updateFilter(context, idType: value),
                    ),
                    CustomTextField(
                      initialValue: state.filter.idNumber,
                      label: l10n.idNumber,
                      onChanged: (value) =>
                          _updateFilter(context, idNumber: value),
                      maxLength: 20,
                      inputFormatters: [IdentificationTextFormatter()],
                    ),
                    CustomDropdown(
                      label: l10n.employmentCountry,
                      value: state.filter.employmentCountry,
                      items: state.countries,
                      onChanged: (value) =>
                          _updateFilter(context, employmentCountry: value),
                    ),
                    CustomTextField(
                      initialValue: state.filter.email,
                      label: l10n.email,
                      onChanged: (value) =>
                          _updateFilter(context, email: value),
                    ),
                    CustomDropdown(
                      label: l10n.status,
                      value: state.filter.isActive?.toString(),
                      items: {'true': l10n.active, 'false': l10n.inactive},
                      onChanged: (value) =>
                          _updateFilter(context, isActive: value == 'true'),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: l10n.applyFilters,
                        isLoading: state is EmployeesLoading,
                        onPressed: () {
                          context.read<EmployeesBloc>().add(ApplyFilter());
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        context.read<EmployeesBloc>().add(ResetFilter());
                        Navigator.pop(context);
                      },
                      child: Text(l10n.resetFilters),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _updateFilter(
    BuildContext context, {
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
    final currentState = context.read<EmployeesBloc>().state;
    context.read<EmployeesBloc>().add(UpdateFilter(
          currentState.filter.copyWith(
            firstName: firstName,
            otherNames: otherNames,
            firstSurname: firstSurname,
            secondSurname: secondSurname,
            idType: idType,
            idNumber: idNumber,
            employmentCountry: employmentCountry,
            email: email,
            isActive: isActive,
          ),
        ));
  }
}
