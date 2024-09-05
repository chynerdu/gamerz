import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
import '../for-you/for-you.dart';

class Profile extends StatefulWidget {
  final bool myProfile;

  Profile({required this.myProfile});
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  bool profileLoading = false;
  // AuthRepository authRepository = AuthRepository();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProfile();
    });
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
    // try {
    //   Controller c = Get.put(Controller());
    //   updateProfileState(true);
    //   var result = await authRepository.myProfile();
    //   print("fetch ${c.userData.value.result!.data!}");
    //   updateProfileState(false);
    // } catch (e) {
    //   updateProfileState(false);
    // }
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
    Data profile = authProvider.userData;
    return authProvider.isLoadingAuth
        ? const SizedBox(
            height: 150, child: Center(child: CircularProgressIndicator()))
        : profile == null
            ? const SizedBox(
                height: 50,
                child: Center(
                    child: Text('Unable to load profile',
                        style: TextStyle(color: Colors.white))))
            : Column(
                children: [
                  const SizedBox(height: 24),
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
                                  ? SizedBox.shrink()
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
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 1),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: const Text("Edit Profile",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ))))
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
                                      : SvgPicture.asset(
                                          'assets/icons/filSettings.svg')
                                ],
                              )
                            ],
                          )),
                      const SizedBox(width: 24),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                  'Sometimes I talk about tech and sometimes it is just vibes and cruise 🫠',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: GamerzTheme.bioStyle),
                              SizedBox(height: 15),
                              Text(
                                'linktr.ee/chinedu_uche7',
                                style: GamerzTheme.followerCount,
                              ),
                            ],
                          )),
                    ],
                  ),

                  // !widget.myProfile
                  //     ? Container(
                  //         padding: const EdgeInsets.symmetric(vertical: 12),
                  //         width: double.infinity,
                  //         child: OutlinedButton(
                  //             onPressed: (() => {}),
                  //             style: OutlinedButton.styleFrom(
                  //               shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(8.0),
                  //               ),
                  //               side: const BorderSide(
                  //                   width: 1.0, color: Color(0xFF262626)),
                  //             ),
                  //             child: const Text("Follow",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.w700,
                  //                     color: Colors.white))))
                  //     : Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //             Container(
                  //                 padding:
                  //                     const EdgeInsets.symmetric(vertical: 12),
                  //                 width:
                  //                     MediaQuery.of(context).size.width * 0.4,
                  //                 child: OutlinedButton(
                  //                     onPressed: (() => {}),
                  //                     style: OutlinedButton.styleFrom(
                  //                       shape: RoundedRectangleBorder(
                  //                         borderRadius:
                  //                             BorderRadius.circular(8.0),
                  //                       ),
                  //                       side: const BorderSide(
                  //                           width: 1.0,
                  //                           color: Color(0xFF262626)),
                  //                     ),
                  //                     child: const Text("Edit Profile",
                  //                         style: TextStyle(
                  //                             fontSize: 16,
                  //                             fontWeight: FontWeight.w700,
                  //                             color: Colors.white)))),
                  //             Container(
                  //                 padding:
                  //                     const EdgeInsets.symmetric(vertical: 12),
                  //                 width:
                  //                     MediaQuery.of(context).size.width * 0.4,
                  //                 child: OutlinedButton(
                  //                     onPressed: (() => {}),
                  //                     style: OutlinedButton.styleFrom(
                  //                       shape: RoundedRectangleBorder(
                  //                         borderRadius:
                  //                             BorderRadius.circular(8.0),
                  //                       ),
                  //                       side: const BorderSide(
                  //                           width: 1.0,
                  //                           color: Color(0xFF262626)),
                  //                     ),
                  //                     child: const Text("Share Profile",
                  //                         style: TextStyle(
                  //                             fontSize: 16,
                  //                             fontWeight: FontWeight.w700,
                  //                             color: Colors.white))))
                  //           ]),

                  // tabs

                  // _tabSection(context)
                ],
              );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);
    return DefaultTabController(
      length: 2,
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
                bottom: const TabBar(
                  labelColor: CustomColors.primaryColor,
                  indicatorColor: CustomColors.primaryColor,
                  unselectedLabelColor: Colors.white,
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
            ];
          },
          body: const GamerzWrapper(
              child: TabBarView(
            // controller: tabController,
            children: <Widget>[
              MyPosts(),
              Text('Replies'),
            ],
          ))),
    );
  }
}

class MyPosts extends StatelessWidget {
  const MyPosts({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    return postProvider.isLoadingMyPosts
        ? ShimmerList()
        : postProvider.myPosts.isNotEmpty
            ? Container(
                child: ListView.separated(
                // physics: NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                // reverse: true,
                itemCount: postProvider.myPosts.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                      thickness: 1, height: 0, color: Color(0xFF747474));
                },
                itemBuilder: ((BuildContext context, index) {
                  postData.Data post = postProvider.myPosts[index];
                  return PostContainer(
                      id: post.sId as String,
                      content: "${post.message}",
                      commentCounts: post.comments as int,
                      likes: post.likes as int,
                      author: "${post.author![0].firstName}",
                      date: "${Jiffy(post.updatedAt).fromNow()}",
                      image: post.media!.length > 0
                          ? "${post.media![0].url}"
                          : null,
                      postProvider: postProvider,
                      isMyPost: true);
                }),
              ))
            : const Center(
                child: Text("You have not made any post yet",
                    style: TextStyle(color: (Colors.white))));
  }
}
