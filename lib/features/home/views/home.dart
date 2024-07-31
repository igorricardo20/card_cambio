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
        backgroundColor: Colors.white,
        body: SafeArea(child: page),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_2x2),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.clock),
              label: 'Historical',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.cube),
              label: 'Open Data',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_2),
              label: 'About Us',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: changeDestination,
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