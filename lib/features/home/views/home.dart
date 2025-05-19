import 'package:card_cambio/features/historical/views/historical.dart';
import 'package:card_cambio/features/home/views/dashboard.dart';
import 'package:card_cambio/features/settings/views/settings.dart';
import 'package:card_cambio/features/onboarding/views/onboarding.dart'; // Add this import
import 'package:card_cambio/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isFirstRun') ?? true;
    if (isFirstRun) {
      setState(() {
        _showOnboarding = true;
      });
      await prefs.setBool('isFirstRun', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return Onboarding(onFinish: () {
        setState(() {
          _showOnboarding = false;
        });
      });
    }

    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = Dashboard();
        break; // Add break statements
      case 1:
        page = Historical();
        break; // Add break statements
      case 2: 
        page = Settings();
        break; // Add break statements
      default:
        throw UnimplementedError('Invalid index');
    }

    final isWideScreen = MediaQuery.sizeOf(context).width > 600;
    
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: isWideScreen 
        ? Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              top: false,
              bottom: false,
              right: false,
              child: NavigationRail(
                onDestinationSelected: changeDestination,
                groupAlignment: -0.95,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(CupertinoIcons.house, color: iconColor),
                    selectedIcon: Icon(CupertinoIcons.house_fill, color: iconColor),
                    label: Text(AppLocalizations.of(context)!.home),
                    padding: EdgeInsets.symmetric(vertical: 4.0), // Add padding
                  ),
                  NavigationRailDestination(
                    icon: Icon(CupertinoIcons.clock, color: iconColor),
                    selectedIcon: Icon(CupertinoIcons.clock_fill, color: iconColor),
                    label: Text(AppLocalizations.of(context)!.historical),
                    padding: EdgeInsets.symmetric(vertical: 4.0), // Add padding
                  ),
                  NavigationRailDestination(
                    icon: Icon(CupertinoIcons.settings, color: iconColor),
                    selectedIcon: Icon(CupertinoIcons.settings_solid, color: iconColor),
                    label: Text(AppLocalizations.of(context)!.settings),
                    padding: EdgeInsets.symmetric(vertical: 4.0), // Add padding
                  ),
                ], 
                selectedIndex: _selectedIndex,
                labelType: NavigationRailLabelType.all,
                elevation: 1,
                minWidth: 200,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                indicatorColor: isDarkMode ? Colors.green : Colors.lightGreen[200],
                )
            ),
          ),
          Expanded(
            child: page
          ),
          ],
      )
      : Scaffold(
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            top: false,
            bottom: false,
            right: false,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: page
              ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: changeDestination,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          indicatorColor: Colors.transparent,
          shadowColor: Colors.grey[50],
          indicatorShape: ShapeBorder.lerp(CircleBorder(), CircleBorder(), 1),
          animationDuration: const Duration(milliseconds: 800),
          height: 60,
          destinations: [
            NavigationDestination(
              icon: Icon(CupertinoIcons.house, color: iconColor),
              selectedIcon: Icon(CupertinoIcons.house_fill, color: iconColor),
              label: AppLocalizations.of(context)!.home,
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.clock, color: iconColor),
              selectedIcon: Icon(CupertinoIcons.clock_fill, color: iconColor),
              label: AppLocalizations.of(context)!.historical,
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.gear_alt, color: iconColor),
              selectedIcon: Icon(CupertinoIcons.gear_alt_fill, color: iconColor),
              label: AppLocalizations.of(context)!.settings,
            ),
          ],
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }

  changeDestination(int index) {
    if (_selectedIndex == index) return; // Prevent redirecting to the same page
    setState(() {
      _selectedIndex = index;
    });
  }
}