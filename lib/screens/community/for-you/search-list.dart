import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamerz/app-providers/auth_provider.dart';
import 'package:gamerz/commom/avatar.dart';
import 'package:gamerz/commom/custom-colors.dart';
import 'package:gamerz/commom/gamerz-wrapper.dart';
import 'package:gamerz/screens/community/profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:gamerz/data-models.dart/searchUserModel.dart'
    as searchUserModel;
import '../../../data-models.dart/followersModel.dart' as follower;

class SearchList extends StatefulWidget {
  UserAuthProvider authProvider;
  SearchList({super.key, required this.authProvider});

  @override
  State<StatefulWidget> createState() {
    return SearchListState();
  }
}

class SearchListState extends State<SearchList> {
  TextEditingController searchController = TextEditingController();
  ScrollController mainScrollController = ScrollController();
  late Timer _timer;
  final _scrollThreshold = 200;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer(const Duration(seconds: 5), () => {});
      mainScrollController.addListener(_onScroll);
    });

    super.initState();
  }

  void _onScroll() async {
    final extentAfter = mainScrollController.position.extentAfter;
    if (extentAfter < _scrollThreshold) {
      if (widget.authProvider.isSearchingUser) {
        return;
      }
      if ((num.tryParse(
                  widget.authProvider.searchUserList.meta!.page!.toString()) ??
              0) <
          (num.tryParse(
                  widget.authProvider.searchUserList.meta!.pages.toString()) ??
              0)) {
        int page = widget.authProvider.searchUserList.data == null
            ? 1
            : widget.authProvider.searchUserList.meta!.page! + 1;
        if (!widget.authProvider.isSearchingUser &&
            widget.authProvider.searchUserList.meta!.nextPage != 0) {
          await widget.authProvider
              .searchuser(page: page, searchQuery: searchController.text);
        }
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);

    searchUser() async {
      await authProvider.searchuser(searchQuery: searchController.text);
    }

    handleDebounce(
        {required Timer timer,
        required dynamic callBack,
        required int time}) async {
      timer = new Timer(Duration(milliseconds: time), () {
        callBack();
      });
    }

    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.8),
        // appBar: AppBar(
        //   toolbarHeight: 0,
        //   backgroundColor: Colors.transparent,
        //   automaticallyImplyLeading: false,
        //   bottom: TabBar(
        //     labelColor: Colors.white,
        //     labelStyle:
        //         const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        //     indicatorColor: CustomColors.primaryColor,
        //     unselectedLabelColor: Colors.white60,
        //     tabs: [
        //       Text(
        //         "${authProvider.userData.following} Following",
        //       ),
        //       Text(
        //         "${authProvider.userData.followers} Followers",
        //       ),
        //     ],
        //   ),
        // ),
        body: GamerzWrapper(
            child: Column(children: [
// seaarch field
          Row(
            children: [
              GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                      onChanged: (String value) => handleDebounce(
                          timer: _timer, time: 500, callBack: searchUser),
                      controller: searchController,
                      textInputAction: TextInputAction.search,
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
                        contentPadding:
                            const EdgeInsets.only(left: 16, top: 10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ))
                  ],
                ),
              ))
            ],
          ),

// List
          // Expanded(child: Center(child: Text('result')))
          Expanded(
              child: ListView.builder(
            controller: mainScrollController,
            // separatorBuilder: (context, index) {
            //   return const Divider(
            //       thickness: 1, height: 0, color: CustomColors.dividerColor);
            // },
            itemCount: authProvider.searchUserList.data!.length,
            itemBuilder: ((BuildContext context, index) {
              searchUserModel.Data user =
                  authProvider.searchUserList.data![index];
              return ListTile(
                onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Profile(
                            myProfile: user.sId == authProvider.userData.sId
                                ? true
                                : false,
                            userId: user.sId))),
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Container(
                    width: 28,
                    height: 28,
                    child: AvatarBig(
                      isNetwork: user.profileImage != null ? true : false,
                      img: user.profileImage ?? "assets/icons/image1.png",
                    )),
                title: Text('${user.firstName} ${user.lastName}',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text(user.username!.toLowerCase(),
                    style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(92, 232, 232, 232))),
              );
            }),
          ))
        ])));
  }
}
