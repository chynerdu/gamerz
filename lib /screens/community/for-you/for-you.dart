import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_svg/flutter_svg.dart';
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
          int.tryParse(widget.postProvider.allposts.meta!.total.toString())) {
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
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 213, 6, 75),
            splashColor: const Color.fromARGB(255, 180, 0, 60),
            onPressed: () async {
              final result = await Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const NewPost()));

              if (result == true) {
                setState(() {
                  widget.postProvider.getAllPosts();
                });
              }
            },
            child: const Icon(Icons.edit_outlined, size: 30)),
        body: widget.postProvider.isInitialLoadingAllPosts
            ? ShimmerList()
            : Container(
                child: ListView.separated(
                itemCount: widget.postProvider.allposts.data!.length,
                controller: widget.mainScrollController,
                separatorBuilder: (context, index) {
                  return const Divider(
                      thickness: 1, height: 0, color: Color(0xFF747474));
                },
                itemBuilder: ((BuildContext context, index) {
                  Data post = widget.postProvider.allposts.data![index];
                  return PostContainer(
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
              )));
  }
}

class PostContainer extends StatefulWidget {
  final String id;
  final bool? showFollow;
  final String content;
  final dynamic image;
  final int commentCounts;
  final int likes;
  final String author;
  final String authorId;
  final String? authorAvatar;
  final String date;
  final bool? isSingle;
  final bool? isMyPost;
  final bool? addingComment;
  final bool? isLoggedIn;
  final bool? userLiked;
  final PostProvider postProvider;

  const PostContainer(
      {required this.content,
      required this.id,
      this.image,
      this.isSingle,
      this.showFollow = true,
      this.addingComment,
      required this.authorId,
      this.isMyPost,
      this.isLoggedIn,
      this.userLiked,
      required this.commentCounts,
      required this.likes,
      required this.author,
      this.authorAvatar,
      required this.date,
      required this.postProvider});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PostContainerState();
  }
}

class _PostContainerState extends State<PostContainer> {
  bool userLiked = false;
  int likes = 0;
  @override
  initState() {
    userLiked = widget.userLiked ?? false;
    likes = widget.likes;
    super.initState();
  }

  Widget _stackedHeads() => Container(
      padding: const EdgeInsets.only(left: 10),
      width: 48,
      height: 12,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.commentCounts > 3 ? 3 : widget.commentCounts,
          itemBuilder: (context, index) {
            return const Align(
              widthFactor: 0.3,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: AvatarSmall(
                  img: "assets/icons/image2.png",
                ),
              ),
            );
          }));

  promptLogin(context, sizeManager, title) async {
    await bottomSheetPopUp(
        ctx: context,
        height: MediaQuery.of(context).size.height * 0.85,
        child: Container(
          color: Colors.transparent,
          child: UserLoginPrompt(actionMessage: title),
        ));
  }

  reportPost(context, sizeManager, id) async {
    print('report post');
    await bottomSheetPopUp(
        ctx: context,
        height: MediaQuery.of(context).size.height * 0.85,
        child: Container(
          color: Colors.transparent,
          child: ReportPostPrompt(
            id: id,
          ),
        ));
  }

//  List<PopupMenuEntry<String>>  buildPostOptions() {
//     return widget.isMyPost == true
//         ? ['Delete', 'Share']
//         : ['Share', 'Report Post'];
//   }

  likePost(isLiked, context) async {
    try {
      setState(() {
        userLiked = isLiked;
        likes = isLiked
            ? likes + 1
            : likes > 0
                ? likes - 1
                : 0;
      });

      await widget.postProvider
          .likePost(id: widget.id, isLiked: isLiked, authorId: widget.authorId);
    } catch (e) {
      print('failed $e');
    }
  }

  void handleClick(String value, context, id, sizeManager) {
    switch (value) {
      case 'Delete':
        deletePost(id);
        break;
      case 'Report':
        reportPost(context, sizeManager, id);
        break;
      case 'Share post':
        break;
    }
  }

  deletePost(id) async {
    try {
      SmartDialog.showLoading(msg: 'Deleting...');
      final postProvider = Provider.of<PostProvider>(context);
      await postProvider.deletePost(id);
      SmartDialog.dismiss();
      SmartDialog.showToast('Deleted');
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast('Error occured',
          displayTime: const Duration(seconds: 3));
    }
  }

  Widget build(BuildContext context) {
    SizeManager sizeManager = SizeManager(context);

    return IntrinsicHeight(
        child: Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  UserWidget(
                      isMyPost: widget.isMyPost,
                      authorId: widget.authorId,
                      isLoggedIn: widget.isLoggedIn,
                      author: widget.author,
                      promptLogin: promptLogin,
                      sizeManager: sizeManager,
                      child: AvatarBig(
                        isNetwork: widget.authorAvatar != null ? true : false,
                        img: widget.authorAvatar ?? "assets/icons/image1.png",
                      ))
                ],
              ),

              const Expanded(
                  child: DottedLine(
                direction: Axis.vertical,
                // alignment: WrapAlignment.center,
                lineLength: 10,
                lineThickness: 1.0,
                dashLength: 20.0,
                dashColor: Color(0xff9A9A9A),
                // dashGradient: [Colors.red, Colors.blue],
                dashRadius: 0.0,
                dashGapLength: 10.0,
                dashGapColor: Colors.transparent,
                // dashGapGradient: [Colors.red, Colors.blue],
                dashGapRadius: 0.0,
              )),
              // }),

              // Container(
              //   width: 282,
              //   height: 0,
              // ),
              widget.addingComment == null || widget.addingComment == false
                  ? _stackedHeads()
                  : const SizedBox.shrink()
            ],
          ),
          const SizedBox(width: 5),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.2),
                                    child: UserWidget(
                                        author: widget.author,
                                        authorId: widget.authorId,
                                        promptLogin: promptLogin,
                                        sizeManager: sizeManager,
                                        isMyPost: widget.isMyPost,
                                        child: Text(widget.author,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            )))),
                                const SizedBox(width: 6),
                                SvgPicture.asset("assets/icons/filVerified.svg",
                                    width: 12),
                                const SizedBox(width: 10),
                                // widget.showFollow == true
                                //     ? Container(
                                //         padding: const EdgeInsets.symmetric(
                                //             horizontal: 8, vertical: 1),
                                //         decoration: BoxDecoration(
                                //             borderRadius:
                                //                 BorderRadius.circular(4),
                                //             border: Border.all(
                                //                 color: Colors.white)),
                                //         child: const Text("Follow",
                                //             style: TextStyle(
                                //               fontSize: 12,
                                //               color: Colors.white,
                                //               fontWeight: FontWeight.w500,
                                //             )))
                                //     : const SizedBox.shrink()
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(widget.date,
                                    style: GamerzTheme.interactionStyle),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  child: PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                    ),
                                    onSelected: (String choice) {
                                      // c.updateTab(2);
                                      widget.isLoggedIn != true
                                          ? promptLogin(context, sizeManager,
                                              'Sign in to join the conversation in ${widget.author}\'s post.')
                                          : handleClick(choice, context,
                                              widget.id, sizeManager);
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return widget.isMyPost == true
                                          ? ['Share Post', 'Delete']
                                              .map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(choice),
                                              );
                                            }).toList()
                                          : ['Share Post', 'Report']
                                              .map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(choice),
                                              );
                                            }).toList();
                                    },
                                  ),
                                )
                                // const Icon(
                                //   Icons.more_horiz,
                                //   color: Colors.white,
                                // )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 7),
                        GestureDetector(
                            onTap: () => widget.isLoggedIn != true
                                ? promptLogin(context, sizeManager,
                                    'Sign in to join the conversation in ${widget.author}\'s post.')
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SinglePost(
                                              body: PostBody(
                                                id: widget.id,
                                                author: widget.author,
                                                image: widget.image,
                                                content: widget.content,
                                                authorId: widget.authorId,
                                                authorAvatar:
                                                    widget.authorAvatar,
                                                commentCounts:
                                                    widget.commentCounts,
                                                likes: likes,
                                                date: widget.date,
                                              ),
                                            )),
                                  ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(widget.content,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: GamerzTheme.postStyle)),
                                  const SizedBox(height: 7),
                                  widget.image != null
                                      ? CachedNetworkImage(
                                          imageUrl: widget.image as String,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.network(
                                                        fit: BoxFit.cover,
                                                        widget.image as String,
                                                        // width: double.infinity,
                                                        // height: MediaQuery.of(context).size.height * 0.4,
                                                      )),
                                          placeholder: (context, url) =>
                                              const SpinKitRipple(
                                                  color: Color(0xffE91E63)),
                                          errorWidget: (context, url, error) =>
                                              const Visibility(
                                                  visible: false,
                                                  child: Icon(Icons.error)),
                                        )
                                      : const SizedBox.shrink()
                                ])),
                      ])),
                ],
              ),
              const SizedBox(height: 17),
              widget.addingComment == null || widget.addingComment == false
                  ? FittedBox(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.isSingle == null || widget.isSingle == false
                                ? WidgetButton(
                                    onPressed: () => widget.isLoggedIn != true
                                        ? promptLogin(context, sizeManager,
                                            'Sign in to join the conversation and reply to ${widget.author}\'s post.')
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddComment(
                                                        body: PostBody(
                                                          id: widget.id,
                                                          author: widget.author,
                                                          authorId:
                                                              widget.authorId,
                                                          image: widget.image,
                                                          content:
                                                              widget.content,
                                                          commentCounts: widget
                                                              .commentCounts,
                                                          likes: likes,
                                                          date: widget.date,
                                                        ),
                                                        postProvider: widget
                                                            .postProvider)),
                                          ),
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text("${widget.commentCounts}",
                                            style:
                                                GamerzTheme.interactionStyle),
                                        const SizedBox(width: 4),
                                        SvgPicture.asset(
                                          "assets/icons/comment.svg",
                                          width: 15,
                                        ),
                                      ],
                                    ))
                                : const SizedBox.shrink(),
                            // Text("$commentCounts comments",
                            //     style: GamerzTheme.interactionStyle)),
                            const SizedBox(width: 16),
                            WidgetButton(
                                onPressed: () => widget.isLoggedIn != true
                                    ? promptLogin(context, sizeManager,
                                        'Sign in to join the conversation in ${widget.author}\'s post.')
                                    : likePost(userLiked == true ? false : true,
                                        context),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text("${likes}",
                                        style: GamerzTheme.interactionStyle),
                                    const SizedBox(width: 4),
                                    SvgPicture.asset(
                                      "assets/icons/filLike.svg",
                                      color: userLiked == true
                                          ? CustomColors.primaryColor
                                          : Colors.white,
                                      width: 15,
                                    ),
                                  ],
                                )),
                            // const SizedBox(width: 16),
                            // SvgPicture.asset("assets/icons/filRepost.svg",
                            //     width: 15),
                            const SizedBox(width: 16),

                            SvgPicture.asset("assets/icons/send.svg",
                                width: 15),
                          ],
                        ),
                      ],
                    ))
                  : const SizedBox.shrink()
            ],
          ))
        ],
      ),
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
