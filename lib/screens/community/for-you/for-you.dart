import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamerz/screens/community/communityHome.dart';
import 'package:gamerz/shared/post-container.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../../app-providers/post_provider.dart';
import '../../../commom/avatar.dart';
import '../../../commom/bottomsheet.dart';
import '../../../commom/custom-colors.dart';
import '../../../commom/theming.dart';
import '../../../commom/ui/gamerzRaisedButton.dart';
import '../../../commom/ui/shimmers.dart';
import '../../../data-models.dart/postModel.dart';
import '../../../helpers/sizeManager.dart';

import '../../../shared/report-post.dart';
import '../../authentication/login.dart';
import '../add-comment.dart';
import '../new-post.dart';
import '../profile/profile.dart';
import '../single-post.dart';

class FeedForYou extends StatefulWidget {
  final ScrollController mainScrollController;
  final bool isLoggedIn;
  final PostProvider postProvider;

  FeedForYou(
      {required this.mainScrollController,
      required this.postProvider,
      required this.isLoggedIn});
  @override
  State<FeedForYou> createState() => _FeedForYouState();
}

class _FeedForYouState extends State<FeedForYou> {
  final _scrollThreshold = 200;
  @override
  void initState() {
    widget.mainScrollController.addListener(_onScroll);
    super.initState();
  }

  getData() async {
    await widget.postProvider.getAllPosts();
  }

  void _onScroll() async {
    final extentAfter = widget.mainScrollController.position.extentAfter;
    if (extentAfter < _scrollThreshold) {
      if (int.tryParse(widget.postProvider.allposts.meta!.page!.toString()) !=
          int.tryParse(widget.postProvider.allposts.meta!.pages.toString())) {
        int page = widget.postProvider.allposts.data == null
            ? 1
            : widget.postProvider.allposts.meta!.page! + 1;
        if (!widget.postProvider.isLoadingAllPosts &&
            widget.postProvider.allposts.meta!.nextPage != 0) {
          await widget.postProvider.getAllPosts(page: page);
        }
      }
    }
  }

  @override
  void dispose() {
    widget.mainScrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        // floatingActionButton: FloatingActionButton(
        //     elevation: 5,
        //     shape: const CircleBorder(),
        //     backgroundColor: const Color.fromARGB(255, 213, 6, 75),
        //     splashColor: const Color.fromARGB(255, 180, 0, 60),
        //     onPressed: () async {
        //       final result = await Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (_) => NewPost(
        //                     postProvider: widget.postProvider,
        //                   )));

        //       if (result == true) {
        //         setState(() {
        //           widget.postProvider.getAllPosts();
        //         });
        //       }
        //     },
        //     child: Image.asset('assets/new-post.png')
        //     // const Icon(Icons.edit_outlined, size: 30)
        //     ),
        body: widget.postProvider.isInitialLoadingAllPosts
            ? ShimmerList()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.postProvider.isReviewingPost == true
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Post under review.'),
                              SizedBox(height: 10),
                              LinearProgressIndicator(
                                color: CustomColors.primaryColor,
                              ),
                            ],
                          ))
                      : const SizedBox.shrink(),
                  Expanded(
                      child: ListView.separated(
                    itemCount: widget.postProvider.allposts.data!.length,
                    controller: widget.mainScrollController,
                    separatorBuilder: (context, index) {
                      return const Divider(
                          thickness: 1,
                          height: 0,
                          color: CustomColors.dividerColor);
                    },
                    itemBuilder: ((BuildContext context, index) {
                      Data post = widget.postProvider.allposts.data![index];
                      return PostContainer(
                          postType: PostType.main,
                          id: post.sId as String,
                          content: "${post.message}",
                          authorId: post.author![0].sId as String,
                          commentCounts: post.comments as int,
                          authorAvatar: post.author![0].profilePicture ??
                              post.author![0].profilePicture,
                          likes: post.likes as int,
                          author: post.author != null
                              ? "${post.author![0].firstName}"
                              : '',
                          date: Jiffy(post.updatedAt).fromNow(),
                          image: (post.media != null && post.media!.isNotEmpty)
                              ? "${post.media![0].url}"
                              : null,
                          isLoggedIn: widget.isLoggedIn,
                          userLiked: post.userLiked,
                          postProvider: widget.postProvider);
                    }),
                  ))
                ],
              ));
  }
}

class UserWidget extends StatelessWidget {
  Widget child;
  bool? isMyPost;
  bool? isLoggedIn;
  String author;
  String authorId;
  Function promptLogin;
  SizeManager sizeManager;

  UserWidget(
      {required this.child,
      this.isMyPost,
      this.isLoggedIn,
      required this.author,
      required this.authorId,
      required this.promptLogin,
      required this.sizeManager});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
              isLoggedIn != true
                  ? promptLogin(context, sizeManager,
                      'Sign in to view ${author}\'s profile.')
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Profile(
                              myProfile: isMyPost ?? false, userId: authorId))),
            },
        child: child);
  }
}

class PostBody {
  String content;
  dynamic image;
  String id;
  int commentCounts;
  int likes;
  String author;
  String authorId;
  String? authorAvatar;
  String date;
  bool? isSingle;
  bool? isMyPost;
  bool? addingComment;

  PostBody(
      {required this.content,
      required this.commentCounts,
      required this.likes,
      required this.id,
      required this.author,
      required this.authorId,
      this.authorAvatar,
      required this.date,
      this.isSingle,
      this.isMyPost,
      this.addingComment,
      this.image});
}

class WidgetButton extends StatelessWidget {
  final Widget child;
  final dynamic onPressed;

  const WidgetButton({super.key, required this.child, required this.onPressed});

  Widget build(BuildContext context) {
    return TextButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(3),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
          backgroundColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: child);
  }
}

class UserLoginPrompt extends StatelessWidget {
  String? actionMessage;
  String? actionSubMessage;

  UserLoginPrompt({super.key, this.actionMessage, this.actionSubMessage});
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: CustomColors.primaryColor),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/appIcon.png', width: 100, height: 100),
            const SizedBox(height: 70),
            Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(actionMessage ?? 'Hey there! Join the conversation',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20))),
            const SizedBox(height: 20),
            Text(
                actionSubMessage ??
                    'When you log in you will be able to join the conversation',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: GamerzElevatedButton(
                  label: 'Login',
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const Login()))),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: GamerzElevatedButton(
                  labelColor: Colors.white,
                  backgroundColor: CustomColors.primaryColor,
                  label: 'Register',
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const Login()))),
            )
          ],
        )));
  }
}
