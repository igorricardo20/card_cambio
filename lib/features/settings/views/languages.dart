import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Languages extends StatelessWidget {
  final List<String> languageCodes = ['en', 'nl', 'es', 'pt'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 1),
                      child: Text(
                        AppLocalizations.of(context)!.language,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      color: Theme.of(context).cardColor,
                      elevation: 0,
                      child: Column(
                        children: languageCodes.map((code) => _buildLanguageTile(context, code)).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, String code) {
    bool isLast = languageCodes.last == code;
    return Column(
      children: [
        ListTile(
          title: Text(
            _getLocalizedString(context, code),
            style: Theme.of(context).textTheme.bodySmall, // Use new text style
          ),
          trailing: context.watch<LocaleProvider>().locale.languageCode == code
              ? Icon(Icons.check, color: Theme.of(context).primaryColor)
              : null,
          onTap: () {
            Navigator.pop(context);
            context.read<LocaleProvider>().setLocale(Locale(code));
          },
        ),
        if (!isLast) Divider(height: 1, color: Theme.of(context).dividerColor),
      ],
    );
  }

  String _getLocalizedString(BuildContext context, String code) {
    switch (code) {
      case 'en':
        return AppLocalizations.of(context)!.english;
      case 'nl':
        return AppLocalizations.of(context)!.dutch;
      case 'es':
        return AppLocalizations.of(context)!.spanish;
      case 'pt':
        return AppLocalizations.of(context)!.portuguese;
      default:
        return '';
    }
  }
}