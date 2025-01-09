import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gamerz/app-providers/auth_provider.dart';
import 'package:gamerz/commom/avatar.dart';
import 'package:provider/provider.dart';
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
    final authProvider = Provider.of<UserAuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            widget.isLoggedIn
                ? Container(
                    padding: const EdgeInsets.only(right: 12),
                    child: AvatarBig(
                      isNetwork: authProvider.userData.profileImage != null
                          ? true
                          : false,
                      img: authProvider.userData.profileImage ??
                          "assets/icons/image1.png",
                    ))
                : const SizedBox.shrink(),
            const Text('𝖦𝖺𝗆𝖾𝗋𝗓 𝖹𝗈𝗇𝖾',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 250, 56, 121))),
          ],
        ),
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
