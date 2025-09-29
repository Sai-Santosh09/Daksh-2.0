import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../generated/l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      subtitle: Text(localeNotifier.getLocaleDisplayName(currentLocale)),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        _showLanguageDialog(context, ref, currentLocale);
      },
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, Locale currentLocale) {
    final l10n = AppLocalizations.of(context)!;
    final localeNotifier = ref.read(localeProvider.notifier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LocaleNotifier.supportedLocales.map((locale) {
            final isSelected = locale.languageCode == currentLocale.languageCode;
            return RadioListTile<Locale>(
              title: Row(
                children: [
                  Text(
                    localeNotifier.getLocaleFlag(locale),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(localeNotifier.getLocaleDisplayName(locale)),
                ],
              ),
              value: locale,
              groupValue: currentLocale,
              onChanged: (Locale? value) {
                if (value != null) {
                  localeNotifier.setLocale(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel ?? 'Cancel'),
          ),
        ],
      ),
    );
  }
}


