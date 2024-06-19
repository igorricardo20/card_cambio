import 'package:card_cambio/features/home/views/dashboard.dart';
import 'package:card_cambio/features/home/views/info.dart';
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
        break;
      case 1:
        page = Info();
        break;
      default:
        throw UnimplementedError('Invalid index');
    }

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: NavigationRail(
              onDestinationSelected: changeDestination,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.info_outline),
                  selectedIcon: Icon(Icons.info),
                  label: Text('Info'),
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
            child: Container(
              child: page,
            ),
          ),
          ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _selectedIndex++),
        tooltip: 'Change Page',
        child: const Icon(Icons.add),
      ),
    );
  }

  changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}