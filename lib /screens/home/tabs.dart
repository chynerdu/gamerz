import 'package:flutter/material.dart';

import '../../app-providers/games.provider.dart';
import '../../commom/custom-colors.dart';
import '../community/communityHome.dart';
import '../home.dart';

class NavigationTabs extends StatefulWidget {
  final AllGamesProvider provider;

  const NavigationTabs(this.provider, {super.key});

  @override
  State<NavigationTabs> createState() => _NavigationTabsState();
}

class _NavigationTabsState extends State<NavigationTabs> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getGamesAndPlatforms());
  }

  getGamesAndPlatforms() async {
    try {
      await widget.provider.getAllGames();
      await widget.provider.getAllPlatforms();
    } catch (error) {}
  }

  void _onItemTapped(int index) {
    // reload on tapping icon on same tab
    if (index == 0 && _selectedIndex == 0) {
      getGamesAndPlatforms();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomeScreen(widget.provider),
      CommunityHomeScreen(widget.provider)
    ];
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Gamerz Zone',
              backgroundColor: CustomColors.backgroundColors),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
            backgroundColor: CustomColors.backgroundColors,
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color(0xff9A9A9A),
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
