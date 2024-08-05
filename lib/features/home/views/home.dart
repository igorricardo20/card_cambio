import 'package:card_cambio/features/historical/views/historical.dart';
import 'package:card_cambio/features/home/views/dashboard.dart';
import 'package:card_cambio/features/info/views/about.dart';
import 'package:card_cambio/features/info/views/info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = Dashboard();
      case 1:
        page = Historical();
      case 2:
        page = Info();
      case 3:
        page = About();
      default:
        throw UnimplementedError('Invalid index');
    }

    final isWideScreen = MediaQuery.sizeOf(context).width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isWideScreen 
        ? Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            color: Colors.grey[50],
            child: SafeArea(
              top: false,
              bottom: false,
              right: false,
              child: NavigationRail(
                onDestinationSelected: changeDestination,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(CupertinoIcons.square_grid_2x2),
                    selectedIcon: Icon(CupertinoIcons.square_grid_2x2_fill),
                    label: Text('Dashboard'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(CupertinoIcons.clock),
                    selectedIcon: Icon(CupertinoIcons.clock_fill),
                    label: Text('Historical'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(CupertinoIcons.cube),
                    selectedIcon: Icon(CupertinoIcons.cube_fill),
                    label: Text('Open Data'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(CupertinoIcons.person_2),
                    selectedIcon: Icon(CupertinoIcons.person_2_fill),
                    label: Text('About Us'),
                  ),
                ], 
                selectedIndex: _selectedIndex,
                labelType: NavigationRailLabelType.all,
                elevation: 5,
                backgroundColor: BottomNavigationBarTheme.of(context).backgroundColor,
                indicatorColor: Colors.transparent,
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
          color: Colors.white,
          child: SafeArea(
            top: false,
            bottom: false,
            right: false,
            child: page
          ),
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: changeDestination,
          destinations: [
            NavigationDestination(
              icon: Icon(CupertinoIcons.square_grid_2x2),
              selectedIcon: Icon(CupertinoIcons.square_grid_2x2_fill),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.clock),
              selectedIcon: Icon(CupertinoIcons.clock_fill),
              label: 'Historical',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.cube),
              selectedIcon: Icon(CupertinoIcons.cube_fill),
              label: 'Open Data',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.person_2),
              selectedIcon: Icon(CupertinoIcons.person_2_fill),
              label: 'About Us',
            ),
          ],
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }

  changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}