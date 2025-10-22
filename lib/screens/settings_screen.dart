import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLanguageSection(context),
          const SizedBox(height: 16),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.language,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Consumer<LocaleProvider>(
              builder: (context, localeProvider, child) {
                return Column(
                  children: LocaleProvider.supportedLocales.map((locale) {
                    final languageName = _getLanguageName(locale.languageCode);
                    
                    return ListTile(
                      title: Text(languageName),
                      leading: Radio<String>(
                        value: locale.languageCode,
                        groupValue: localeProvider.locale.languageCode,
                        onChanged: (value) {
                          if (value != null) {
                            localeProvider.setLocale(Locale(value, ''));
                          }
                        },
                      ),
                      onTap: () {
                        localeProvider.setLocale(locale);
                      },
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.about,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'RealMesh Mobile',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${AppLocalizations.of(context)!.version} 1.0.0',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.aboutAppDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.aboutTechDescription,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.kosovoJeSrbija,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'sr':
        return 'Српски (Serbian)';
      default:
        return languageCode;
    }
  }
}