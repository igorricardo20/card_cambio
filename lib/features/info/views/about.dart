import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher_string.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
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
                      Text(
                        'About This App',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'This app is a showcase of what we do best: building fast, reliable, and visually stunning software. '
                        'It serves as an example of the quality and creativity we bring to every project and how we turn ideas into impactful digital experiences.',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Us',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          text: 'At ',
                          style: TextStyle(fontSize: 16, height: 1.5),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Rockpeach',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ', we believe technology is more than just code – it’s about crafting experiences that connect people and businesses. '
                                  'We are a software house dedicated to developing super fast, reliable, and visually compelling solutions to our clients.\n\n'
                                  'We quickly turn concepts into products that drive success. Our mission is to simplify complexity while delivering applications with impeccable design.\n\n'
                                  'Get in touch! We’d love to hear from you and discuss your goals.',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Rockpeach',
                        style: TextStyle(
                          fontSize: 28, 
                          fontWeight: FontWeight.w900, 
                          fontStyle: FontStyle.italic, 
                          foreground: Paint()..shader = LinearGradient(colors: [Colors.blue, Colors.redAccent]).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),
                      ),
                      SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          text: 'Visit our Website',
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrlString('https://www.rockpeach.io/'),
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
      ),
    );
  }
}
