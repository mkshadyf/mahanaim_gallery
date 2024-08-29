import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';
  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.themeSettingsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            DropdownButton<ThemeMode>(
              value: controller.themeMode,
              onChanged: controller.updateThemeMode,
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(AppLocalizations.of(context)!.systemTheme),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(AppLocalizations.of(context)!.lightTheme),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(AppLocalizations.of(context)!.darkTheme),
                )
              ],
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.languageSettingsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            DropdownButton<Locale>(
              value: controller.locale,
              onChanged: controller.updateLocale,
              items: [
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text(AppLocalizations.of(context)!.englishLanguage),
                ),
                DropdownMenuItem(
                  value: const Locale('fr'),
                  child: Text(AppLocalizations.of(context)!.frenchLanguage),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
