import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:employees/features/employess/domain/entities/employee.dart';
import 'package:employees/features/employess/presentation/bloc/form/employee_form_bloc.dart';
import 'package:employees/features/employess/presentation/widgets/custom_text_field.dart';
import 'package:employees/features/employess/presentation/widgets/custom_dropdown.dart';
import 'package:employees/features/employess/presentation/widgets/custom_date_picker.dart';
import 'package:employees/features/employess/presentation/widgets/photo_section.dart';
import 'package:employees/features/employess/presentation/widgets/primary_button.dart';
import 'package:employees/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:employees/features/employess/domain/validators/employee_validators.dart';

class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee;
  final bool isEditing;

  EmployeeFormScreen({super.key, this.employee}) : isEditing = employee != null;

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _otherNamesController = TextEditingController();
  final _firstSurnameController = TextEditingController();
  final _secondSurnameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _numberOfEmployeesController = TextEditingController();

  @override
  void initState() {
    if (widget.isEditing) {
      _firstNameController.text = widget.employee!.firstName;
      _otherNamesController.text = widget.employee!.otherNames ?? '';
      _firstSurnameController.text = widget.employee!.firstSurname;
      _secondSurnameController.text = widget.employee!.secondSurname;
      _idNumberController.text = widget.employee!.idNumber;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final validators = EmployeeValidators(l10n);

    return BlocProvider.value(
      value: getIt<EmployeeFormBloc>()
        ..add(widget.isEditing
            ? InitializeEditForm(widget.employee!)
            : const InitializeCreateForm()),
      child: BlocConsumer<EmployeeFormBloc, EmployeeFormState>(
        listener: (context, state) => _handleStateChanges(context, state, l10n),
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title:
                  Text(widget.isEditing ? l10n.editEmployee : l10n.newEmployee),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                          child: _buildPhotoSection(
                        context,
                        state,
                        l10n,
                      )),
                      const SizedBox(height: 16),
                      _buildFormFields(
                        context,
                        state,
                        l10n,
                        validators,
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        isLoading: state is EmployeeFormSubmitting,
                        text: widget.isEditing
                            ? l10n.updateEmployee
                            : l10n.registerEmployee,
                        loadingText: widget.isEditing
                            ? l10n.updatingEmployee
                            : l10n.registeringEmployee,
                        onPressed: () => _submitForm(
                          context,
                          state,
                          l10n,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleStateChanges(
      BuildContext context, EmployeeFormState state, AppLocalizations l10n) {
    if (state is ImageUploadFailure) {
      _showSnackBar(context, l10n.photoUploadError, Colors.red);
    } else if (state is EmployeeFormSubmissionSuccess) {
      _showSnackBar(
          context,
          widget.isEditing
              ? l10n.employeeUpdatedSuccess
              : l10n.employeeRegisteredSuccess,
          Colors.green);
      Navigator.of(context).pop(state.employee);
    } else if (state is EmployeeFormSubmissionFailure) {
      _showSnackBar(
          context,
          widget.isEditing
              ? l10n.employeeUpdateError
              : l10n.employeeRegistrationError,
          Colors.red);
    } else if (state is EmployeeFormIdNumberInUse) {
      _showSnackBar(context, l10n.idNumberInUse, Colors.red);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: color, content: Text(message)),
    );
  }

  Widget _buildPhotoSection(
    BuildContext context,
    EmployeeFormState state,
    AppLocalizations l10n,
  ) {
    return PhotoSection(
      photoFile: state.data?.photoFile,
      photoUrl: widget.isEditing && state.data?.isPhotoRemoved == false
          ? widget.employee!.photoUrl
          : null,
      onTakePhoto: () => _takePhoto(context),
      onRemovePhoto: () =>
          context.read<EmployeeFormBloc>().add(const PhotoRemoved()),
      label: widget.isEditing ? l10n.updatePhoto : l10n.takePhoto,
    );
  }

  Widget _buildFormFields(
    BuildContext context,
    EmployeeFormState state,
    AppLocalizations l10n,
    EmployeeValidators validators,
  ) {
    return Column(
      children: [
        CustomTextField(
          controller: _firstNameController,
          label: l10n.firstName,
          validator: validators.validateName,
          maxLength: 20,
          inputFormatters: [
            UpperCaseTextFormatter(),
            OnlyLettersTextFormatter()
          ],
        ),
        CustomTextField(
          controller: _otherNamesController,
          label: l10n.otherNames,
          validator: validators.validateOtherNames,
          maxLength: 50,
          inputFormatters: [
            UpperCaseTextFormatter(),
            OnlyLettersTextFormatter()
          ],
        ),
        CustomTextField(
          controller: _firstSurnameController,
          label: l10n.firstSurname,
          validator: validators.validateName,
          maxLength: 20,
          inputFormatters: [UpperCaseTextFormatter()],
        ),
        CustomTextField(
          controller: _secondSurnameController,
          label: l10n.secondSurname,
          validator: validators.validateName,
          maxLength: 20,
          inputFormatters: [
            UpperCaseTextFormatter(),
            OnlyLettersTextFormatter()
          ],
        ),
        CustomDropdown(
          label: l10n.employmentCountry,
          value: state.data?.employmentCountry,
          items: {
            'CO': l10n.colombia,
            'US': l10n.unitedStates,
            'VE': l10n.venezuela
          },
          onChanged: (value) => context
              .read<EmployeeFormBloc>()
              .add(EmploymentCountryChanged(value)),
        ),
        CustomDropdown(
          label: l10n.idType,
          value: state.data?.idType,
          items: {
            0: l10n.citizenshipCard,
            1: l10n.foreignerID,
            2: l10n.passport,
            3: l10n.specialPermit
          },
          onChanged: (value) =>
              context.read<EmployeeFormBloc>().add(IdTypeChanged(value)),
        ),
        CustomTextField(
          controller: _idNumberController,
          label: l10n.idNumber,
          validator: validators.validateIdNumber,
          maxLength: 20,
          inputFormatters: [IdentificationTextFormatter()],
        ),
        if (!widget.isEditing)
          CustomDatePicker(
            selectedDate: state.data?.entryDate,
            onDateChanged: (date) =>
                context.read<EmployeeFormBloc>().add(EntryDateChanged(date)),
            label: l10n.entryDate,
            selectDateText: l10n.selectDate,
          ),
        CustomDropdown(
          label: l10n.area,
          value: state.data?.area,
          items: {
            0: l10n.administration,
            1: l10n.finance,
            2: l10n.purchasing,
            3: l10n.infrastructure,
            4: l10n.operations,
            5: l10n.humanResources,
            6: l10n.variousServices
          },
          onChanged: (value) =>
              context.read<EmployeeFormBloc>().add(AreaChanged(value)),
        ),
      ],
    );
  }

  void _takePhoto(BuildContext context) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      context.read<EmployeeFormBloc>().add(PhotoTaken(File(image.path)));
    }
  }

  void _submitForm(
    BuildContext context,
    EmployeeFormState state,
    AppLocalizations l10n,
  ) {
    if (_formKey.currentState!.validate() &&
        state.data?.entryDate != null &&
        (state.data?.photoFile != null ||
            (widget.isEditing && widget.employee!.photoUrl.isNotEmpty))) {
      final employee = Employee(
        id: widget.isEditing ? widget.employee!.id : '',
        firstName: _firstNameController.text,
        otherNames: _otherNamesController.text,
        employmentCountry: state.data!.employmentCountry!,
        registrationDate: widget.isEditing
            ? widget.employee!.registrationDate
            : DateTime.now(),
        isActive: true,
        firstSurname: _firstSurnameController.text,
        secondSurname: _secondSurnameController.text,
        email: widget.isEditing ? widget.employee!.email : '',
        photoUrl: widget.isEditing ? widget.employee!.photoUrl : '',
        idType: state.data!.idType!,
        idNumber: _idNumberController.text,
        entryDate: state.data!.entryDate!,
        area: state.data!.area!,
        editionDate: widget.isEditing ? DateTime.now() : null,
      );
      context.read<EmployeeFormBloc>().add(SubmitForm(
            isEditing: widget.isEditing,
            employee: employee,
            oldEmployee: widget.isEditing ? widget.employee : null,
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseCompleteAllFields)),
      );
    }
  }
}
