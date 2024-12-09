import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
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
                      Text('Open Data', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text('Definition', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
                      Text('Open data in Brazil helps promoting transparency and innovation by making government data freely available to the public. The government and various institutions provide a wide range of datasets across different areas.')
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
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Visit the Brazilian Open Data Portal',
                              style: TextStyle(color: Colors.blue, fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => launchUrlString('https://dados.gov.br/'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Text('Central Bank', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
                      Text('The Central Bank of Brazil also provides open data through its open data portal. The data includes information on the country\'s financial system, foreign exchange, and more.'),
                      SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Visit the Central Bank of Brazil Open Data Portal',
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