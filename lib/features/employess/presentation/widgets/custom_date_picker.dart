import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateChanged;
  final String label;
  final String selectDateText;

  const CustomDatePicker({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.label,
    required this.selectDateText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            lastDate: DateTime.now(),
          );
          if (date != null) {
            onDateChanged(date);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Text(
            selectedDate == null
                ? selectDateText
                : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
          ),
        ),
      ),
    );
  }
}
