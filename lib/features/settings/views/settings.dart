import 'package:card_cambio/features/info/views/about.dart';
import 'package:card_cambio/features/info/views/info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/providers/theme_provider.dart';

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
                    Text('Settings', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.grey[100],
                elevation: 0,
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Dark mode'),
                      trailing: CupertinoSwitch(
                        value: context.watch<ThemeProvider>().isDarkMode,
                        onChanged: (value) {
                          context.read<ThemeProvider>().toggleTheme();
                        },
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    ListTile(
                      title: Text('Language'),
                      trailing: Icon(CupertinoIcons.forward),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.grey[100],
                elevation: 0,
                child: Column(
                  children: [
                    ListTile(
                      title: Text('About'),
                      trailing: Icon(CupertinoIcons.forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => About()),
                        );
                      },
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    ListTile(
                      title: Text('Open Data'),
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
