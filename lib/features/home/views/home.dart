import 'package:card_cambio/features/home/views/dashboard.dart';
import 'package:card_cambio/features/home/views/info.dart';
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
        page = Info();
      case 2:
        page = Info();
      default:
        throw UnimplementedError('Invalid index');
    }

    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: isWideScreen 
        ? Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SafeArea(
            child: NavigationRail(
              onDestinationSelected: changeDestination,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(CupertinoIcons.square_grid_2x2),
                  selectedIcon: Icon(CupertinoIcons.square_grid_2x2_fill),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(CupertinoIcons.news),
                  selectedIcon: Icon(CupertinoIcons.news_solid),
                  label: Text('Historical'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.info_outline),
                  selectedIcon: Icon(Icons.info),
                  label: Text('About'),
                ),
              ], 
              selectedIndex: _selectedIndex,
              labelType: NavigationRailLabelType.all,
              elevation: 5,
              backgroundColor: Colors.white,
              indicatorColor: Colors.transparent,
              )
          ),
          Expanded(
            child: page
          ),
          ],
      )
      : Scaffold(
        body: SafeArea(child: page),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_2x2),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.news),
              label: 'Historical',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              label: 'About',
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