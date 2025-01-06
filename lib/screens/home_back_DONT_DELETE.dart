import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../app-providers/games.provider.dart';
import '../commom/ui/gamerzTextButton.dart';
import '../service/local-storage.dart';
import '../service/socket-connection.dart';
import 'authentication/login.dart';
import 'game-listing.dart';
import 'platforms.dart';
import 'popular.dart';

class HomeScreen extends StatefulWidget {
  final AllGamesProvider provider;
  final bool isLoggedIn;
  HomeScreen(this.provider, this.isLoggedIn);
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController homeController;
  late FirebaseMessaging messaging;
  bool index0visibility = true;
  bool index1visibility = false;
  bool index2visibility = false;
  SocketConnection socketConnection = SocketConnection();
  LocalStorage localStorage = LocalStorage();

  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      socketConnection.startConnection();
    });

    super.initState();

    homeController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    socketConnection.disconnectSocket();

    super.dispose();
  }

  getGames() async {
    try {
      await widget.provider.getAllGames();
    } catch (error) {}
  }

  Widget buildBody() {
    return Container(
        child: const Center(
      child: Text('Home Screen'),
    ));
  }

  toggleVisibility(index) {
    switch (index) {
      case 0:
        setState(() {
          index0visibility = true;
          index1visibility = false;
          index2visibility = false;
        });
        break;
      case 1:
        setState(() {
          index0visibility = false;
          index1visibility = true;
          index2visibility = false;
        });
        break;
      case 2:
        setState(() {
          index0visibility = false;
          index1visibility = false;
          index2visibility = true;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Gamerz Zone'),
          actions: <Widget>[
            Visibility(
                visible: !widget.isLoggedIn,
                child: GamerzTextButton(
                  label: 'Login',
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Login())),
                ))
          ],
          bottom: TabBar(
            onTap: (index) {
              toggleVisibility(index);
              print('hello $index');
            },
            labelColor: const Color(0xffE91E63),
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.transparent,
            controller: homeController,
            tabs: <Widget>[
              Tab(
                child: Row(
                  children: <Widget>[
                    Visibility(
                        visible: index0visibility,
                        child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xffE91E63),
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.0),
                              ),
                            ))),
                    const Text(
                      'Popular',
                    )
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: <Widget>[
                    Visibility(
                        visible: index1visibility,
                        child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.0),
                              ),
                            ))),
                    const Text(
                      'Games',
                    )
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: <Widget>[
                    Visibility(
                        visible: index2visibility,
                        child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.0),
                              ),
                            ))),
                    const Text(
                      'Platforms',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(controller: homeController, children: <Widget>[
          Popular(widget.provider),
          GameListing(widget.provider),
          GamePlatforms(widget.provider)
        ]));
  }
}
