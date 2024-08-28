import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../app-providers/games.provider.dart';
import 'for-you/feed.dart';
import 'for-you/for-you.dart';

class CommunityHomeScreen extends StatefulWidget {
  final AllGamesProvider provider;
  CommunityHomeScreen(this.provider);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommunityHomeScreenState();
  }
}

class CommunityHomeScreenState extends State<CommunityHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController homeController;
  late FirebaseMessaging messaging;
  bool index0visibility = true;
  bool index1visibility = false;
  bool index2visibility = false;
  final ScrollController _scrollController = ScrollController();
  // SocketConnection socketConnection = SocketConnection();

  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // socketConnection.startConnection();
      // initFirebase();
    });

    super.initState();

    homeController = TabController(vsync: this, length: 3);
  }

  initFirebase() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    Firebase.initializeApp().whenComplete(() {
      messaging = FirebaseMessaging.instance;
      messaging.subscribeToTopic("newGamePost");
      messaging.getToken().then((value) async {
        print('firebase token $value');
        // firebaseSubscribeModel.firebaseDeviceToken = value;

        // var result = await subscribeToFirebase(firebaseSubscribeModel);
        // print('subscribed $result');
      });
    });
    Firebase.initializeApp();

    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );

    // print('User granted permission: ${settings.authorizationStatus}');
  }

  @override
  void dispose() {
    // socketConnection.disconnectSocket();

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Community'),
          // actions: <Widget>[
          //   Visibility(
          //     visible: index1visibility,
          //     child: IconButton(
          //       color: Colors.black,
          //       onPressed: () {},
          //       icon: Icon(Icons.search,)
          //       )
          //   )
          // ],
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
                      'For You',
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
                      'Servers',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(controller: homeController, children: <Widget>[
          FeedForYou(mainScrollController: _scrollController),
          Feed(),
        ]));
  }
}
