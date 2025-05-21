import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:card_cambio/l10n/app_localizations.dart';
import 'package:card_cambio/widgets/rockpeach_logo.dart';

class About extends StatelessWidget {
  const About({super.key});

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
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.about_this_app,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 10),
                    Text(
                      localizations.about_this_app_description,
                      style: Theme.of(context).textTheme.bodySmall, // Use new text style
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.about_us,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: localizations.at,
                        style: Theme.of(context).textTheme.bodySmall, // Use new text style
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Rockpeach',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: localizations.about_us_description,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    RockpeachLogo(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        text: localizations.visit_website,
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrlString('https://rockpeach.io/'),
                      ),
                    ),
                    SizedBox(height: 5),
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