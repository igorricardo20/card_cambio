import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Languages extends StatelessWidget {
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
                        children: [
                          ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.english,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            trailing: context.watch<LocaleProvider>().locale.languageCode == 'en'
                                ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                                : null,
                            onTap: () {
                              Navigator.pop(context);
                              context.read<LocaleProvider>().setLocale(Locale('en'));
                            },
                          ),
                          Divider(height: 1, color: Theme.of(context).dividerColor),
                          ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.dutch,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            trailing: context.watch<LocaleProvider>().locale.languageCode == 'nl'
                                ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                                : null,
                            onTap: () {
                              Navigator.pop(context);
                              context.read<LocaleProvider>().setLocale(Locale('nl'));
                            },
                          ),
                          Divider(height: 1, color: Theme.of(context).dividerColor),
                          ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.spanish,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            trailing: context.watch<LocaleProvider>().locale.languageCode == 'es'
                                ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                                : null,
                            onTap: () {
                              Navigator.pop(context);
                              context.read<LocaleProvider>().setLocale(Locale('es'));
                            },
                          ),
                          Divider(height: 1, color: Theme.of(context).dividerColor),
                          ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.portuguese,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            trailing: context.watch<LocaleProvider>().locale.languageCode == 'pt'
                                ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                                : null,
                            onTap: () {
                              Navigator.pop(context);
                              context.read<LocaleProvider>().setLocale(Locale('pt'));
                            },
                          ),
                        ],
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
}