import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamerz/app-providers/auth_provider.dart';
import 'package:gamerz/commom/avatar.dart';
import 'package:gamerz/commom/custom-colors.dart';
import 'package:gamerz/commom/gamerz-wrapper.dart';
import 'package:provider/provider.dart';

import '../../../data-models.dart/followersModel.dart' as follower;

class Followers extends StatefulWidget {
  int initialIndex;
  Followers({super.key, required this.initialIndex});

  @override
  State<StatefulWidget> createState() {
    return FollowersState();
  }
}

class FollowersState extends State<Followers> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    super.initState();
  }

  getData() async {
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    await authProvider.getFollowers();
    await authProvider.getFollowing();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);
    return DefaultTabController(
        length: 2,
        initialIndex: widget.initialIndex > 1 ? 1 : widget.initialIndex,
        child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.8),
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              bottom: TabBar(
                labelColor: Colors.white,
                labelStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                indicatorColor: CustomColors.primaryColor,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Text(
                    "${authProvider.userData.following} Following",
                  ),
                  Text(
                    "${authProvider.userData.followers} Followers",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                FollowingList(authprovider: authProvider),
                FollowersList(authprovider: authProvider),
              ],
            )));
  }
}

class FollowersList extends StatelessWidget {
  UserAuthProvider authprovider;
  FollowersList({super.key, required this.authprovider});
  TextEditingController searchController = TextEditingController();
  Widget build(BuildContext context) {
    return GamerzWrapper(
        child: Column(children: [
// seaarch field
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 35, 35, 35),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: Color(0xff989898),
              size: 18,
            ),
            Expanded(
                child: TextFormField(
              onChanged: (String value) => {},
              controller: searchController,
              textInputAction: TextInputAction.newline,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFFFFFF)),
              decoration: InputDecoration(
                isDense: true,
                hintText: "Search",
                hintStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff989898)),
                contentPadding: const EdgeInsets.only(left: 16, top: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ))
          ],
        ),
      ),

// List
      // Expanded(child: Center(child: Text('result')))
      Expanded(
          child: ListView.builder(
        // separatorBuilder: (context, index) {
        //   return const Divider(
        //       thickness: 1, height: 0, color: CustomColors.dividerColor);
        // },
        itemCount: authprovider.followerlist.length,
        itemBuilder: ((BuildContext context, index) {
          follower.Data user = authprovider.followerlist[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
                width: 28,
                height: 28,
                child: AvatarBig(
                  isNetwork: user.user!.profileImage != null ? true : false,
                  img: user.user!.profileImage ?? "assets/icons/image1.png",
                )),
            title: Text('${user.user!.firstName} ${user.user!.lastName}',
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            subtitle: Text('${user.user!.username!.toLowerCase()}',
                style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(92, 232, 232, 232))),
          );
        }),
      ))
    ]));
  }
}

class FollowingList extends StatelessWidget {
  UserAuthProvider authprovider;
  FollowingList({super.key, required this.authprovider});
  TextEditingController searchController = TextEditingController();
  Widget build(BuildContext context) {
    return GamerzWrapper(
        child: Column(children: [
// seaarch field
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 35, 35, 35),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //     width: 25,
            //     height: 25,
            //     child: AvatarBig(
            //       isNetwork:
            //           authProvider.userData.profileImage !=
            //                   null
            //               ? true
            //               : false,
            //       img: authProvider.userData.profileImage ??
            //           "assets/icons/image1.png",
            //     )),
            Icon(
              Icons.search,
              color: Color(0xff989898),
              size: 18,
            ),
            Expanded(
                child: TextFormField(
              onChanged: (String value) => {},
              controller: searchController,
              textInputAction: TextInputAction.newline,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFFFFFF)),
              decoration: InputDecoration(
                isDense: true,
                hintText: "Search",
                hintStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff989898)),
                contentPadding: const EdgeInsets.only(left: 16, top: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ))
          ],
        ),
      ),

// List
      // Expanded(child: Center(child: Text('result')))
      Expanded(
          child: ListView.builder(
        // separatorBuilder: (context, index) {
        //   return const Divider(
        //       thickness: 1, height: 0, color: CustomColors.dividerColor);
        // },
        itemCount: authprovider.followinglist.length,
        itemBuilder: ((BuildContext context, index) {
          follower.Data user = authprovider.followinglist[index];
          return ListTile(
            leading: Container(
                width: 28,
                height: 28,
                child: AvatarBig(
                  isNetwork: user.user!.profileImage != null ? true : false,
                  img: user.user!.profileImage ?? "assets/icons/image1.png",
                )),
            title: Text('${user.user!.firstName} ${user.user!.lastName}',
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            subtitle: Text('${user.user!.username!.toLowerCase()}',
                style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(92, 232, 232, 232))),
          );
        }),
      ))
    ]));
  }
}
