import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamerz/app-providers/post_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../app-providers/auth_provider.dart';
import '../../app-providers/games.provider.dart';
import '../../commom/bottomsheet.dart';
import '../../commom/custom-colors.dart';
import '../../helpers/snackbars.dart';
import '../../service/local-storage.dart';
import '../authentication/login.dart';
import '../community/communityHome.dart';
import '../community/for-you/for-you.dart';

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
      initFirebase();
      getGamesAndPlatforms();
      getUserProfile();
    });
  }

  initFirebase() async {
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    Firebase.initializeApp().whenComplete(() async {
      messaging = FirebaseMessaging.instance;
      await messaging.subscribeToTopic("newGamePost");
      await messaging.subscribeToTopic("gamerzCommunityPost");
      messaging.getToken().then((value) async {
        print('firebase token $value');
        if (value != null) {
          await authProvider.subscribeToFirebase(value);
        }
      });
    });
    Firebase.initializeApp();
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
    if (index == 2 && !isLoggedIn()) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Login()));

      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    // if (_selectedIndex != 0) {
    //   setState(() {
    //     _selectedIndex = 0;
    //   });
    //   return false;
    // }
    return (await showDialog(
          context: context,
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
              title: const Text(
                'Exit App',
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(168, 233, 30, 98)),
              ),
              content: const Text(
                'Do you want to exit Gamerz Zone?',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(150, 0, 0, 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    'No',
                    style: TextStyle(color: CustomColors.primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final List<Widget> _widgetOptions = <Widget>[
      CommunityHomeScreen(
          widget.provider, authProvider, postProvider, isLoggedIn()),
      HomeScreen(widget.provider, isLoggedIn()),
      Profile(
        myProfile: true,
      )
    ];
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) => _onWillPop(),
        child: Scaffold(
          backgroundColor: CustomColors.backgroundColors,
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: CustomColors.backgroundColors,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_rounded),
                  label: 'Home',
                  backgroundColor: CustomColors.backgroundColors),
              const BottomNavigationBarItem(
                icon: Icon(Icons.diamond_rounded),
                label: 'Featured',
                backgroundColor: CustomColors.backgroundColors,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: isLoggedIn() ? 'Me' : 'Login',
                backgroundColor: CustomColors.backgroundColors,
              ),
            ],
            currentIndex: _selectedIndex,
            unselectedItemColor: const Color(0xff9A9A9A),
            selectedItemColor: Colors.white,
            onTap: _onItemTapped,
          ),
        ));
  }
}
