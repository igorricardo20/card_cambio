import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Access localization

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localizations.open_data, style: Theme.of(context).textTheme.headlineSmall),
                      SizedBox(height: 20),
                      Text(localizations.definition, style: Theme.of(context).textTheme.titleSmall),
                      SizedBox(height: 10),
                      Text(localizations.open_data_definition, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      Text(localizations.government_initiatives, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
                      Text(localizations.government_initiatives_description, style: Theme.of(context).textTheme.bodySmall),
                      SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: localizations.visit_brazilian_open_data_portal,
                              style: TextStyle(color: Colors.blue, fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => launchUrlString('https://dados.gov.br/'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(localizations.central_bank, style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
                      Text(localizations.central_bank_description, style: Theme.of(context).textTheme.bodySmall),
                      SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: localizations.visit_central_bank_open_data_portal,
                              style: TextStyle(color: Colors.blue, fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => launchUrlString('https://dadosabertos.bcb.gov.br/'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ]
              ),
            ),
          )
        ),
      ),
    );
  }
}