import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/entities/employee.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final Function(Employee) onDelete;
  final Function(Employee) onEdit;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: ExpansionTile(
        leading: CircleAvatar(
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: employee.photoUrl,
              fit: BoxFit.cover,
              width: 60,
              height: 60,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        title: Text(employee.fullName),
        subtitle: Text(employee.email),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${employee.idTypeHumanReadable}: ${employee.idNumber}'),
                Text('${l10n.country}: ${employee.countryHumanReadable}'),
                Text('${l10n.area}: ${employee.areaHumanReadable}'),
                Text(
                    '${l10n.entryDate}: ${DateFormat('dd/MM/yyyy').format(employee.entryDate)}'),
                Text(
                    '${l10n.status}: ${employee.isActive ? l10n.active : l10n.inactive}'),
                if (employee.registrationDate != null)
                  Text(
                      '${l10n.registrationDate}: ${DateFormat('dd/MM/yyyy').format(employee.registrationDate!)}'),
                if (employee.editionDate != null)
                  Text(
                      '${l10n.editionDate}: ${DateFormat('dd/MM/yyyy').format(employee.editionDate!)}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        onEdit(employee);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        onDelete(employee);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
