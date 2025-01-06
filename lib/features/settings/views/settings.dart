import 'package:card_cambio/features/info/views/about.dart';
import 'package:card_cambio/features/info/views/info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/providers/theme_provider.dart';
import 'package:card_cambio/features/settings/views/languages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.settings, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
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
                        AppLocalizations.of(context)!.dark_mode,
                        style: Theme.of(context).textTheme.bodySmall, // Use new text style
                      ),
                      trailing: CupertinoSwitch(
                        value: context.watch<ThemeProvider>().isDarkMode,
                        onChanged: (value) {
                          context.read<ThemeProvider>().toggleTheme();
                        },
                      ),
                    ),
                    Divider(height: 1, color: Theme.of(context).dividerColor),
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.language,
                        style: Theme.of(context).textTheme.bodySmall, // Use new text style
                      ),
                      trailing: Icon(CupertinoIcons.forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Languages()),
                        );
                      },
                    ),
                  ],
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
                        AppLocalizations.of(context)!.about,
                        style: Theme.of(context).textTheme.bodySmall, // Use new text style
                      ),
                      trailing: Icon(CupertinoIcons.forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => About()),
                        );
                      },
                    ),
                    Divider(height: 1, color: Theme.of(context).dividerColor),
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.open_data,
                        style: Theme.of(context).textTheme.bodySmall, // Use new text style
                      ),
                      trailing: Icon(CupertinoIcons.forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Info()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
