import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamerz/screens/community/profile/followers.dart';
import 'package:gamerz/shared/post-container.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../app-providers/auth_provider.dart';
import '../../../app-providers/post_provider.dart';
import '../../../commom/avatar.dart';
import '../../../commom/custom-colors.dart';
import '../../../commom/gamerz-wrapper.dart';
import '../../../commom/theming.dart';
import '../../../commom/ui/shimmers.dart';
import '../../../data-models.dart/userModel.dart';
import '../../../data-models.dart/postModel.dart' as postData;
import '../../settings/settings.dart';
import 'dart:math';
import 'edit-profile.dart';
import 'posts-liked.dart';

class Profile extends StatefulWidget {
  bool myProfile;
  final String? userId;

  Profile({required this.myProfile, this.userId});
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  bool profileLoading = false;
  final _allPostsscrollController = ScrollController();
  final _allPostsscrollController2 = ScrollController();
  late TabController tabController;
  final _scrollThreshold = 200;
  bool _isAtTop = true;
  // AuthRepository authRepository = AuthRepository();
  @override
  void initState() {
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    tabController = TabController(
        length: widget.myProfile || widget.userId == authProvider.userData.sId
            ? 2
            : 1,
        vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      Data profile = authProvider.userData;
      if (widget.myProfile || widget.userId == profile.sId) {
        widget.myProfile = true;
        getProfile();
      } else {
        if (widget.userId == null) {
          throw StateError('Id is required');
        }
        getOtherUserProfile(widget.userId!);
      }
      _allPostsscrollController.addListener(() {
        _onScroll(profile, postProvider);
      });

      _allPostsscrollController2.addListener(() {
        setState(() {
          print('${_allPostsscrollController2.position.pixels}');
          // Check if the scroll position is at the top
          _isAtTop = _allPostsscrollController2.position.pixels == 0;
        });
      });
    });

    super.initState();
  }

  void _onScroll(profile, postProvider) async {
    final extentAfter = _allPostsscrollController.position.extentAfter;
    if (extentAfter < _scrollThreshold) {
      if (widget.myProfile || widget.userId == profile.sId) {
        //  My profile and post
        widget.myProfile = true;
        if (int.tryParse(postProvider.myPosts.meta!.page!.toString()) !=
            int.tryParse(postProvider.myPosts.meta!.pages.toString())) {
          int page = postProvider.myPosts.data == null
              ? 1
              : postProvider.myPosts.meta!.page! + 1;
          if (!postProvider.isLoadingMyOrUsersPosts &&
              postProvider.myPosts.meta!.nextPage != 0) {
            await postProvider.getMyPosts(page: page);
          }
        }
      } else {
        // Other user profile and posts
        if (widget.userId == null) {
          throw StateError('Id is required');
        }
        if (int.tryParse(postProvider.userPosts.meta!.page!.toString()) !=
            int.tryParse(postProvider.userPosts.meta!.total.toString())) {
          int page = postProvider.userPosts.data == null
              ? 1
              : postProvider.userPosts.meta!.page! + 1;
          if (!postProvider.isLoadingMyOrUsersPosts &&
              postProvider.userPosts.meta!.nextPage != 0) {
            await postProvider.getUserPosts(id: widget.userId, page: page);
          }
        }
      }
    }
  }

  @override
  void dispose() {
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    Data profile = authProvider.userData;
    _allPostsscrollController
        .removeListener(() => _onScroll(profile, postProvider));
    _allPostsscrollController2.dispose();
    super.dispose();
  }

  updateProfileState(state) {
    setState(() {
      profileLoading = state;
    });
  }

  getProfile() async {
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    await authProvider.getUserProfie();
    await postProvider.getMyPosts();
    await postProvider.getPostsLiked();
  }

  getOtherUserProfile(String userId) async {
    print('other user >>>>$userId');
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    await authProvider.getOtherUserProfie(userId);
    await postProvider.getUserPosts(id: userId);
  }

  Widget _tabSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Text("Posts",
                  style: TextStyle(
                    fontSize: 16.475095748901367,
                    fontWeight: FontWeight.w400,
                  )),
              Text("Replies",
                  style: TextStyle(
                    fontSize: 16.475095748901367,
                    fontWeight: FontWeight.w400,
                  ))
            ],
          ),
        ),
      ],
    );
  }

  void showFollowerList(int initialIndex) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Followers(
        initialIndex: initialIndex,
      ),
    );
  }

  confirmUnfollow({name, id, authProvider}) async {
    return (await showDialog(
          context: context,
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
              title: Text(
                'Unfollow $name',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              content: const Text(
                'You will not be able to interact with them',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Color.fromARGB(240, 0, 0, 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Unfollow',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    authProvider.isFollowing
                        ? null
                        : Navigator.of(context).pop(false);
                    await authProvider.followUnfollow(id: id);
                  },
                ),
                TextButton(
                  child: const Text(
                    'Cancel',
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

  Widget header(UserAuthProvider authProvider) {
    // Controller c = Get.put(Controller());
    Data profile =
        widget.myProfile ? authProvider.userData : authProvider.otherUserData;
    print('image url ${profile.profileImage}');
    return authProvider.isLoadingAuth
        ? const SizedBox(
            height: 150, child: Center(child: CircularProgressIndicator()))
        : profile.sId == null
            ? const SizedBox(
                height: 50,
                child: Center(
                    child: Text('Unable to load profile',
                        style: TextStyle(color: Colors.white))))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: profile.profileImage != null
                              ? CachedNetworkImage(
                                  imageUrl: profile.profileImage,
                                  imageBuilder: (context, imageProvider) =>
                                      AvatarNetworkProfile(
                                          url: profile.profileImage),
                                  placeholder: (context, url) =>
                                      const SpinKitRipple(
                                          color: Color(0xffE91E63)),
                                  errorWidget: (context, url, error) =>
                                      const Visibility(
                                          visible: false,
                                          child: Icon(Icons.error)),
                                )
                              : const SizedBox.shrink()),
                      const SizedBox(width: 24),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${profile.firstName} ${profile.lastName}',
                                  style: GamerzTheme.profileHeader),
                              const SizedBox(height: 4),
                              Text(
                                profile.username != null
                                    ? '@${profile.username}'
                                    : '',
                                style: GamerzTheme.followerCount
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          )),
                          Container(
                              child: !widget.myProfile
                                  // TODO Change after implementing folow and follow back
                                  ? const SizedBox.shrink()
                                  // Container(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 8, vertical: 1),
                                  //     decoration: BoxDecoration(
                                  //         borderRadius:
                                  //             BorderRadius.circular(4),
                                  //         border:
                                  //             Border.all(color: Colors.white)),
                                  //     child: const Text("Follow",
                                  //         style: TextStyle(
                                  //           fontSize: 12,
                                  //           color: Colors.white,
                                  //           fontWeight: FontWeight.w700,
                                  //         )))
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const EditProfile()));
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 1),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  color: Colors.white)),
                                          child: const Text("Edit Profile",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              )))))
                        ],
                      ))
                    ],
                  ),

                  // follower count
                  Container(
                    // width: MediaQuery.of(context).size.width * 0.2,
                    child: Row(
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              padding:
                                  EdgeInsets.zero, // Remove internal padding
                            ),
                            onPressed: () => showFollowerList(0),
                            child: RichText(
                              text: TextSpan(
                                text: '${profile.following} ',
                                style: GamerzTheme.followerCount
                                    .copyWith(color: Colors.white),
                                children: const <TextSpan>[
                                  TextSpan(
                                      text: 'following',
                                      style: GamerzTheme.followerCount),
                                ],
                              ),
                            )),
                        SizedBox(width: 15),
                        TextButton(
                            style: TextButton.styleFrom(
                              padding:
                                  EdgeInsets.zero, // Remove internal padding
                            ),
                            onPressed: () => showFollowerList(1),
                            child: RichText(
                              text: TextSpan(
                                text: '${profile.followers} ',
                                style: GamerzTheme.followerCount
                                    .copyWith(color: Colors.white),
                                children: const <TextSpan>[
                                  TextSpan(
                                      text: 'followers',
                                      style: GamerzTheme.followerCount),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  // bio
                  Column(
                    children: [
                      profile.bio != null && profile.bio!.isNotEmpty
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(profile.bio ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: GamerzTheme.postStyle
                                          .copyWith(fontSize: 14)),

                                  // const Text(
                                  //   'linktr.ee/chinedu_uche7',
                                  //   style: GamerzTheme.followerCount,
                                  // ),
                                ],
                              ))
                          : SizedBox.shrink(),
                      SizedBox(height: 20),
                    ],
                  ),

                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: Colors.white)),
                          child: SvgPicture.asset('assets/icons/share.svg',
                              width: 10, height: 10)),
                      const SizedBox(width: 10),
                      !widget.myProfile
                          ? Row(children: [
                              GestureDetector(
                                  onTap: () async {
                                    // authProvider.isFollowing
                                    //     ? null
                                    //     : await authProvider.followUnfollow(
                                    //         id: profile.sId);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: const Text("Message",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          )))),
                              SizedBox(width: 10),
                              profile.followingUser == true
                                  ? GestureDetector(
                                      onTap: () {
                                        confirmUnfollow(
                                            name: profile.firstName,
                                            id: profile.sId,
                                            authProvider: authProvider);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              border: Border.all(
                                                  color: Colors.white)),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text("Following",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Transform.rotate(
                                                  angle: 270 *
                                                      (pi /
                                                          180), // Rotate 45 degrees
                                                  child: Icon(
                                                    Icons.arrow_back_ios_new,
                                                    size: 11,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ])))
                                  : GestureDetector(
                                      onTap: () async {
                                        authProvider.isFollowing
                                            ? null
                                            : await authProvider.followUnfollow(
                                                id: profile.sId);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white)),
                                          child: const Text("Follow",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ))))
                            ])
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Setting()));
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(color: Colors.white)),
                                  child: SvgPicture.asset(
                                      'assets/icons/filSettings.svg',
                                      width: 10,
                                      height: 10)))
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);
    return SafeArea(
      child: NestedScrollView(
          controller: _allPostsscrollController2,
          // physics: _isAtTop
          //     ? const AlwaysScrollableScrollPhysics()
          //     : const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                sliver: SliverToBoxAdapter(child: header(authProvider)),
              ),
              SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    iconTheme: const IconThemeData(color: Colors.black),
                    backgroundColor: Color(0xFF000000),
                    // pinned: true,
                    toolbarHeight: 0,
                    elevation: 0,
                    pinned: true,
                    floating: true,
                    forceElevated: innerBoxIsScrolled,
                    bottom: TabBar(
                      padding: EdgeInsets.all(0),

                      controller: tabController,
                      labelColor: Colors.white,
                      labelStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      indicatorColor: CustomColors.primaryColor,
                      unselectedLabelColor: Colors.white60,
                      // indicatorWeight: 0.1,
                      // indicatorPadding: EdgeInsets.only(
                      //     right: MediaQuery.of(context).size.width * 0.25),
                      tabs: widget.myProfile ||
                              widget.userId == authProvider.userData.sId
                          ? [
                              const Text(
                                "Posts",
                              ),
                              const Text(
                                "Likes",
                              )
                            ]
                          : [
                              const Text(
                                "Posts",
                              ),
                            ],
                    ),

                    // flexibleSpace: FlexibleSpaceBar(
                    //   title: header(authProvider),
                    // ),
                  )),
              // SliverPersistentHeader(
              //   delegate: MySliverPersistentHeaderDelegate(

              //   ),
              //   pinned: true,
              // ),
            ];
          },
          body:
              // TabBarView(
              //   children: [
              //     Icon(Icons.flight, size: 350),
              //     Icon(Icons.directions_transit, size: 350),
              //   ],
              // )
              GamerzWrapper(
                  child: TabBarView(
            controller: tabController,
            children: widget.myProfile ||
                    widget.userId == authProvider.userData.sId
                ? <Widget>[
                    MyPosts(
                      mainScrollController: _allPostsscrollController,
                      isAtTop: _isAtTop,
                    ),
                    const PostsILiked()
                  ]
                : <Widget>[
                    UsersPosts(mainScrollController: _allPostsscrollController),
                  ],
          ))),
    );
  }
}

class MyPosts extends StatelessWidget {
  final ScrollController mainScrollController;
  final bool isAtTop;
  const MyPosts(
      {super.key, required this.mainScrollController, required this.isAtTop});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    return postProvider.isInitialLoadingMyOrUsersPosts
        ? ShimmerList()
        : postProvider.myPosts.data!.isNotEmpty
            ? Builder(builder: (BuildContext context) {
                return CustomScrollView(
                  key: PageStorageKey<int>(0),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: SliverList.builder(
                        itemBuilder: (BuildContext context, int index) {
                          postData.Data post =
                              postProvider.myPosts.data![index];
                          return PostContainer(
                            postType: PostType.main,
                            id: post.sId as String,
                            content: "${post.message}",
                            commentCounts: post.comments as int,
                            likes: post.likes as int,
                            author: "${post.author![0].firstName}",
                            authorAvatar: post.author![0].profilePicture ??
                                post.author![0].profilePicture as dynamic,
                            date: "${Jiffy(post.updatedAt).fromNow()}",
                            image: post.media!.length > 0
                                ? "${post.media![0].url}"
                                : null,
                            postProvider: postProvider,
                            authorId: post.author![0].sId as String,
                            isMyPost: true,
                            userLiked: post.userLiked,
                            isLoggedIn: true,
                          );
                        },
                        itemCount: postProvider.myPosts.data!.length,
                      ),
                    ),
                  ],
                );
              }

                // ListView.separated(
                // padding: const EdgeInsets.only(top: 0),
                // physics: const AlwaysScrollableScrollPhysics(),
                // controller: mainScrollController,
                // physics: NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                // reverse: true,
                // physics: !isAtTop
                //     ? const NeverScrollableScrollPhysics()
                //     : const AlwaysScrollableScrollPhysics(),
                // itemCount: postProvider.myPosts.data!.length,
                // separatorBuilder: (context, index) {
                //   return const Divider(
                //       thickness: 1,
                //       height: 0,
                //       color: CustomColors.dividerColor);
                // },
                // itemBuilder: ((BuildContext context, index) {
                //   postData.Data post = postProvider.myPosts.data![index];
                //   return PostContainer(
                //     postType: PostType.main,
                //     id: post.sId as String,
                //     content: "${post.message}",
                //     commentCounts: post.comments as int,
                //     likes: post.likes as int,
                //     author: "${post.author![0].firstName}",
                //     authorAvatar: post.author![0].profilePicture ??
                //         post.author![0].profilePicture as dynamic,
                //     date: "${Jiffy(post.updatedAt).fromNow()}",
                //     image:
                //         post.media!.length > 0 ? "${post.media![0].url}" : null,
                //     postProvider: postProvider,
                //     authorId: post.author![0].sId as String,
                //     isMyPost: true,
                //     userLiked: post.userLiked,
                //     isLoggedIn: true,
                //   );
                // }),
                // )
                )
            : const Center(
                child: Text("You have not made any post yet",
                    style: TextStyle(color: (Colors.white))));
  }
}

class UsersPosts extends StatelessWidget {
  final ScrollController mainScrollController;
  const UsersPosts({super.key, required this.mainScrollController});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    return postProvider.isInitialLoadingMyOrUsersPosts
        ? ShimmerList()
        : postProvider.userPosts.data!.isNotEmpty
            ? Builder(builder: (BuildContext context) {
                return CustomScrollView(
                  key: PageStorageKey<int>(1),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: SliverList.builder(
                        itemBuilder: (BuildContext context, int index) {
                          postData.Data post =
                              postProvider.userPosts.data![index];
                          return PostContainer(
                            id: post.sId as String,
                            content: "${post.message}",
                            commentCounts: post.comments as int,
                            likes: post.likes as int,
                            author: "${post.author![0].firstName}",
                            authorAvatar: post.author![0].profilePicture ??
                                post.author![0].profilePicture as dynamic,
                            date: "${Jiffy(post.updatedAt).fromNow()}",
                            image: post.media!.length > 0
                                ? "${post.media![0].url}"
                                : null,
                            postProvider: postProvider,
                            authorId: post.author![0].sId as String,
                            isMyPost: true,
                            userLiked: post.userLiked,
                            isLoggedIn: true,
                          );
                        },
                        itemCount: postProvider.userPosts.data!.length,
                      ),
                    ),
                  ],
                );
              })

            // Container(
            //     padding: const EdgeInsets.only(bottom: 20),
            //     child: ListView.separated(
            //       padding: const EdgeInsets.only(top: 0),
            //       physics: const NeverScrollableScrollPhysics(),
            //       controller: mainScrollController,
            //       // physics: NeverScrollableScrollPhysics(),
            //       // shrinkWrap: true,
            //       // reverse: true,
            //       itemCount: postProvider.userPosts.data!.length,
            //       separatorBuilder: (context, index) {
            //         return const Divider(
            //             thickness: 1,
            //             height: 0,
            //             color: CustomColors.dividerColor);
            //       },
            //       itemBuilder: ((BuildContext context, index) {
            //         postData.Data post = postProvider.userPosts.data![index];
            //         return PostContainer(
            //           id: post.sId as String,
            //           content: "${post.message}",
            //           commentCounts: post.comments as int,
            //           likes: post.likes as int,
            //           author: "${post.author![0].firstName}",
            //           authorAvatar: post.author![0].profilePicture ??
            //               post.author![0].profilePicture as dynamic,
            //           date: "${Jiffy(post.updatedAt).fromNow()}",
            //           image: post.media!.length > 0
            //               ? "${post.media![0].url}"
            //               : null,
            //           postProvider: postProvider,
            //           authorId: post.author![0].sId as String,
            //           isMyPost: true,
            //           userLiked: post.userLiked,
            //           isLoggedIn: true,
            //         );
            //       }),
            //     ))

            : const Center(
                child: Text("This user has not made any post yet",
                    style: TextStyle(color: (Colors.white))));
  }
}

// ... existing code ...

// ... existing code ...

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  // final double minHeight;
  // final double maxHeight;

  MySliverPersistentHeaderDelegate(
    this.tabBar,
    // this.minHeight,
    // this.maxHeight,
  );
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Header content
    return SizedBox(
      height: tabBar.preferredSize.height,
      child: tabBar,
    );
  }

  @override
  double get minExtent => tabBar.preferredSize.height;
  // tabBar.preferredSize.height; // Set minExtent to the height of the TabBar

  @override
  double get maxExtent => tabBar.preferredSize.height;
  // tabBar.preferredSize.height; // Set maxExtent to the height of the TabBar

  double layoutExtent(double shrinkOffset) =>
      max(min(maxExtent, maxExtent - shrinkOffset), 0);

  @override
  bool shouldRebuild(covariant MySliverPersistentHeaderDelegate oldDelegate) {
    // Rebuild only if necessary
    return tabBar != oldDelegate.tabBar;
  }
}
