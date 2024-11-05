import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
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
import '../for-you/for-you.dart';
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

class _ProfileState extends State<Profile> {
  bool profileLoading = false;
  final _allPostsscrollController = ScrollController();
  final _scrollThreshold = 200;

  // AuthRepository authRepository = AuthRepository();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider =
          Provider.of<UserAuthProvider>(context, listen: false);
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
      _allPostsscrollController
          .addListener(() => _onScroll(profile, postProvider));
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
            int.tryParse(postProvider.myPosts.meta!.total.toString())) {
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
                                style: GamerzTheme.usernameStyle,
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              // TODO uncomment after implementing follow and follow back
                              // Text(
                              //   '${profile.following} following',
                              //   style: GamerzTheme.followerCount,
                              // ),
                              // const SizedBox(height: 10),
                              // Text(
                              //   '${profile.followers} followers',
                              //   style: GamerzTheme.followerCount,
                              // ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  SvgPicture.asset('assets/icons/share.svg'),
                                  const SizedBox(width: 16),
                                  !widget.myProfile
                                      ? SvgPicture.asset(
                                          'assets/icons/filMessage.svg')
                                      : GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Setting()));
                                          },
                                          child: SvgPicture.asset(
                                              'assets/icons/filSettings.svg'))
                                ],
                              )
                            ],
                          )),
                      const SizedBox(width: 24),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile.bio ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: GamerzTheme.bioStyle),
                              const SizedBox(height: 15),
                              // const Text(
                              //   'linktr.ee/chinedu_uche7',
                              //   style: GamerzTheme.followerCount,
                              // ),
                            ],
                          )),
                    ],
                  ),
                ],
              );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);
    return DefaultTabController(
      length: widget.myProfile || widget.userId == authProvider.userData.sId
          ? 2
          : 1,
      child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                sliver: SliverToBoxAdapter(child: header(authProvider)),
              ),
              SliverAppBar(
                backgroundColor: CustomColors.backgroundColors,
                pinned: true,
                elevation: 12.0,
                leading: Container(),
                toolbarHeight: 0,
                bottom: TabBar(
                  labelColor: CustomColors.primaryColor,
                  indicatorColor: CustomColors.primaryColor,
                  unselectedLabelColor: Colors.white,
                  tabs: widget.myProfile ||
                          widget.userId == authProvider.userData.sId
                      ? [
                          const Text("Posts",
                              style: TextStyle(
                                fontSize: 16.475095748901367,
                                fontWeight: FontWeight.w400,
                              )),
                          const Text("Likes",
                              style: TextStyle(
                                fontSize: 16.475095748901367,
                                fontWeight: FontWeight.w400,
                              ))
                        ]
                      : [
                          const Text("Posts",
                              style: TextStyle(
                                fontSize: 16.475095748901367,
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                ),
              ),
            ];
          },
          body: GamerzWrapper(
              child: TabBarView(
            // controller: tabController,
            children: widget.myProfile ||
                    widget.userId == authProvider.userData.sId
                ? <Widget>[
                    MyPosts(mainScrollController: _allPostsscrollController),
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
  const MyPosts({super.key, required this.mainScrollController});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    return postProvider.isInitialLoadingMyOrUsersPosts
        ? ShimmerList()
        : postProvider.myPosts.data!.isNotEmpty
            ? Container(
                child: ListView.separated(
                controller: mainScrollController,
                // physics: NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                // reverse: true,
                itemCount: postProvider.myPosts.data!.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                      thickness: 1, height: 0, color: Color(0xFF747474));
                },
                itemBuilder: ((BuildContext context, index) {
                  postData.Data post = postProvider.myPosts.data![index];
                  return PostContainer(
                    id: post.sId as String,
                    content: "${post.message}",
                    commentCounts: post.comments as int,
                    likes: post.likes as int,
                    author: "${post.author![0].firstName}",
                    authorAvatar: post.author![0].profilePicture ??
                        post.author![0].profilePicture as dynamic,
                    date: "${Jiffy(post.updatedAt).fromNow()}",
                    image:
                        post.media!.length > 0 ? "${post.media![0].url}" : null,
                    postProvider: postProvider,
                    authorId: post.author![0].sId as String,
                    isMyPost: true,
                    userLiked: post.userLiked,
                    isLoggedIn: true,
                  );
                }),
              ))
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
            ? Container(
                child: ListView.separated(
                controller: mainScrollController,
                // physics: NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                // reverse: true,
                itemCount: postProvider.userPosts.data!.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                      thickness: 1, height: 0, color: Color(0xFF747474));
                },
                itemBuilder: ((BuildContext context, index) {
                  postData.Data post = postProvider.userPosts.data![index];
                  return PostContainer(
                    id: post.sId as String,
                    content: "${post.message}",
                    commentCounts: post.comments as int,
                    likes: post.likes as int,
                    author: "${post.author![0].firstName}",
                    authorAvatar: post.author![0].profilePicture ??
                        post.author![0].profilePicture as dynamic,
                    date: "${Jiffy(post.updatedAt).fromNow()}",
                    image:
                        post.media!.length > 0 ? "${post.media![0].url}" : null,
                    postProvider: postProvider,
                    authorId: post.author![0].sId as String,
                    isMyPost: true,
                    userLiked: post.userLiked,
                    isLoggedIn: true,
                  );
                }),
              ))
            : const Center(
                child: Text("This user has not made any post yet",
                    style: TextStyle(color: (Colors.white))));
  }
}
