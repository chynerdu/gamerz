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

class HomeScreenState extends State<HomeScreen> {
  late FirebaseMessaging messaging;
  SocketConnection socketConnection = SocketConnection();
  LocalStorage localStorage = LocalStorage();

  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      socketConnection.startConnection();
    });

    super.initState();
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
      ),
      body: Popular(widget.provider),
    );
  }
}
