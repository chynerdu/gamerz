import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app-providers/auth_provider.dart';
import '../../app-providers/games.provider.dart';
import '../../commom/custom-colors.dart';
import '../../service/local-storage.dart';
import '../community/communityHome.dart';
import '../community/profile/profile.dart';
import '../home.dart';

class NavigationTabs extends StatefulWidget {
  final AllGamesProvider provider;

  const NavigationTabs(this.provider, {super.key});

  @override
  State<NavigationTabs> createState() => _NavigationTabsState();
}

class _NavigationTabsState extends State<NavigationTabs> {
  int _selectedIndex = 0;
  LocalStorage localStorage = LocalStorage();
  var token;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getGamesAndPlatforms();
      getUserProfile();
    });
  }

  getGamesAndPlatforms() async {
    try {
      token = await localStorage.getData(name: 'token');
      await widget.provider.getAllGames();
      await widget.provider.getAllPlatforms();
    } catch (error) {}
  }

  getUserProfile() async {
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    await authProvider.getUserProfie();
  }

  bool isLoggedIn() {
    return token != null ? true : false;
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
      HomeScreen(widget.provider, isLoggedIn()),
      CommunityHomeScreen(widget.provider, isLoggedIn()),
      Profile(
        myProfile: true,
      )
    ];
    return Scaffold(
      backgroundColor: CustomColors.backgroundColors,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CustomColors.backgroundColors,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
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
