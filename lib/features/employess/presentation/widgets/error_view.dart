import 'package:employees/features/employess/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  ErrorView({super.key, required this.onRetry});
  late final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.errorLoadingEmployees,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.errorLoadingEmployeesMessage,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            text: l10n.retry,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
