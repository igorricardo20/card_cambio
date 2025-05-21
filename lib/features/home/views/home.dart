import 'package:card_cambio/features/historical/views/historical.dart';
import 'package:card_cambio/features/home/views/dashboard.dart';
import 'package:card_cambio/features/settings/views/settings.dart';
import 'package:card_cambio/features/onboarding/views/onboarding.dart'; // Add this import
import 'package:card_cambio/features/services/views/services.dart';
import 'package:card_cambio/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'package:card_cambio/widgets/rockpeach_logo.dart';

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
      case 1:
        page = ServicesPage();
      case 2:
        page = Historical();
      case 3:
        page = Settings();
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Card(
              elevation: 0, // Remove shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              color: Theme.of(context).cardColor,
              child: Container(
                width: 72, // Reduced width for a more compact sidebar
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Removed the first icon (credit card)
                    _SideMenuButton(
                      icon: CupertinoIcons.house,
                      selectedIcon: CupertinoIcons.house_fill,
                      selected: _selectedIndex == 0,
                      onTap: () => changeDestination(0),
                      tooltip: AppLocalizations.of(context)!.home,
                      iconColor: iconColor,
                    ),
                    SizedBox(height: 18),
                    _SideMenuButton(
                      icon: CupertinoIcons.square_grid_2x2,
                      selectedIcon: CupertinoIcons.square_grid_2x2_fill,
                      selected: _selectedIndex == 2,
                      onTap: () => changeDestination(2),
                      tooltip: AppLocalizations.of(context)!.services_title,
                      iconColor: iconColor,
                    ),
                    SizedBox(height: 18),
                    _SideMenuButton(
                      icon: CupertinoIcons.clock,
                      selectedIcon: CupertinoIcons.clock_fill,
                      selected: _selectedIndex == 1,
                      onTap: () => changeDestination(1),
                      tooltip: AppLocalizations.of(context)!.historical,
                      iconColor: iconColor,
                    ),
                    SizedBox(height: 18),
                    _SideMenuButton(
                      icon: CupertinoIcons.settings,
                      selectedIcon: CupertinoIcons.settings_solid,
                      selected: _selectedIndex == 3,
                      onTap: () => changeDestination(3),
                      tooltip: AppLocalizations.of(context)!.settings,
                      iconColor: iconColor,
                    ),
                    SizedBox(height: 18),
                    Spacer(),
                    // Add rockpeach logo at the bottom, centered and harmonized in size
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Center(
                        child: RockpeachLogo(
                          height: 40, // Harmonized size with other icons
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          square: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
              icon: Icon(CupertinoIcons.square_grid_2x2, color: iconColor),
              selectedIcon: Icon(CupertinoIcons.square_grid_2x2_fill, color: iconColor),
              label: AppLocalizations.of(context)!.services_title,
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

class _SideMenuButton extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;
  final String tooltip;
  final Color iconColor;

  const _SideMenuButton({
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
    required this.tooltip,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            decoration: selected
                ? BoxDecoration(
                    color: iconColor.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(16),
                  )
                : null,
            padding: const EdgeInsets.all(10),
            child: Icon(
              selected ? selectedIcon : icon,
              color: iconColor,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}