import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Open Data', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('Open data in Brazil helps promote transparency and innovation by making government data freely available to the public. The government and various institutions provide a wide range of datasets across different areas.')
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Text('Government Initiatives', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    Text('The platform where the Brazilian government publishes open data is called Portal Brasileiro de Dados Abertos (Brazilian Open Data Portal). It includes datasets from various ministries and agencies, covering topics like health, education, economy, environment, and more.'),
                    SizedBox(height: 20),
                    //textSpan widget with onTap to the link
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Visit the ',
                          ),
                          TextSpan(
                            text: 'Brazilian Open Data Portal',
                            style: TextStyle(color: Colors.blue, fontSize: 14),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => launchUrlString('https://dados.gov.br/'),
                          ),
                          TextSpan(
                            text: ' to learn more.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
            ),
          ),
        )
      ),
    );
  }
}