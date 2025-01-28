import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gamerz/app-providers/auth_provider.dart';
import 'package:gamerz/commom/avatar.dart';
import 'package:gamerz/screens/community/for-you/search-list.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:provider/provider.dart';

import '../../app-providers/games.provider.dart';
import '../../app-providers/post_provider.dart';
import '../../commom/gamerz-wrapper.dart';
import '../../commom/ui/gamerzTextButton.dart';
import '../../service/socket-connection.dart';
import '../authentication/login.dart';
import 'for-you/feed.dart';
import 'for-you/for-you.dart';

class CommunityHomeScreen extends StatefulWidget {
  final AllGamesProvider provider;
  final PostProvider postProvider;
  final UserAuthProvider authProvider;
  final bool isLoggedIn;
  CommunityHomeScreen(
      this.provider, this.authProvider, this.postProvider, this.isLoggedIn);
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
  SocketConnection socketConnection = SocketConnection();
  bool index0visibility = true;
  bool index1visibility = false;
  bool index2visibility = false;

  final ScrollController _scrollController = ScrollController();

  // SocketConnection socketConnection = SocketConnection();

  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
      // TODO Pass callback to show badge
      socketConnection.startConnection(
          callBack: () => null,
          userId: widget.authProvider.userData.sId,
          postProvider: widget.postProvider);
    });

    super.initState();

    homeController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    socketConnection.disconnectSocket();

    super.dispose();
  }

  getData() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.getAllPosts();
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
    print(MediaQuery.of(context).size.width);
    final postProvider = Provider.of<PostProvider>(context);
    final authprovider = Provider.of<UserAuthProvider>(context);

    void searchUsers() {
      showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => SearchList(authProvider: authprovider),
      );
    }

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.isLoggedIn
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.11,
                      child: Center(
                          child: Container(
                              width: 30,
                              height: 30,
                              child: AvatarBig(
                                isNetwork:
                                    widget.authProvider.userData.profileImage !=
                                            null
                                        ? true
                                        : false,
                                img:
                                    widget.authProvider.userData.profileImage ??
                                        "assets/icons/image1.png",
                              ))))
                  : SizedBox(width: MediaQuery.of(context).size.width * 0.11),
              Image.asset("assets/icons/xporb/xporb-logo.png",
                  width: MediaQuery.of(context).size.width * 0.25
                  // width: 300,
                  ),
              // Text('𝖦𝖺𝗆𝖾𝗋𝗓 𝖹𝗈𝗇𝖾',
              //     style: TextStyle(
              //         fontWeight: FontWeight.w800,
              //         color: Color.fromARGB(255, 250, 56, 121))),
              !widget.isLoggedIn
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.11,
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: GamerzTextButton(
                            label: 'Login',
                            onPressed: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) => Login())),
                          )))
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.11,
                      child: TextButton(
                          onPressed: () => searchUsers(),
                          child: const Icon(Icons.search,
                              size: 30, color: Colors.white)))
            ],
          ),
          bottom: TabBar(
            onTap: (index) {
              toggleVisibility(index);
            },
            labelColor: Colors.white,
            // const Color(0xffE91E63),
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.white60,
            indicatorColor: const Color(0xffE91E63),
            indicatorSize: TabBarIndicatorSize.label,
            controller: homeController,
            tabAlignment: TabAlignment.center,
            // indicatorPadding: EdgeInsets.only(
            //     right: MediaQuery.of(context).size.width * 0.25),
            indicatorWeight: 0.1,
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
                              color: Colors.white,
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
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.0),
                              ),
                            ))),
                    const Text(
                      'Zones',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: GamerzWrapper(
            child: TabBarView(controller: homeController, children: <Widget>[
          FeedForYou(
              mainScrollController: _scrollController,
              postProvider: postProvider,
              isLoggedIn: widget.isLoggedIn),
          Feed(postProvider: postProvider),
        ])));
  }
}
