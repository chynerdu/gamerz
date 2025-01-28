import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamerz/screens/community/communityHome.dart';
import 'package:gamerz/screens/community/for-you/for-you.dart';
import 'package:gamerz/screens/community/single-post.dart';
import 'package:gamerz/shared/report-post.dart';
import 'package:jiffy/jiffy.dart';
import 'package:photo_view/photo_view.dart';
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

enum PostType { main, single, comments }

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
  @Deprecated('Use PostType enum instead of isSingle boolean')
  final bool? isSingle;
  final PostType? postType;
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
      this.postType,
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

  void _showFullScreenDialog(BuildContext context, image) {
    SizeManager sizeManager = SizeManager(context);
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return Scaffold(
            backgroundColor: CustomColors.backgroundColors,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                Container(
                    padding: EdgeInsets.only(right: 15),
                    // height: 3,
                    child: Align(
                        alignment: Alignment.topRight,
                        child: PopupMenuButton<String>(
                          color: Colors.black,
                          // elevation: 20,
                          // padding:
                          //     const EdgeInsets.symmetric(vertical: 0),
                          child: Container(
                            height: 36,
                            width: 48,
                            alignment: Alignment.centerRight,
                            child: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),

                          onSelected: (String choice) {
                            // c.updateTab(2);

                            widget.isLoggedIn != true
                                ? promptLogin(context, sizeManager,
                                    'Sign in to join the conversation in ${widget.author}\'s post.')
                                : handleClick(
                                    choice, context, widget.id, sizeManager);
                          },
                          itemBuilder: (BuildContext context) {
                            return widget.isMyPost == true
                                ? ['Share Post', 'Delete'].map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList()
                                : ['Share Post', 'Report'].map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                          },
                        ))),
              ],
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: PhotoView(
                    imageProvider: NetworkImage(image),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WidgetButton(
                          onPressed: () => widget.isLoggedIn != true
                              ? promptLogin(context, sizeManager,
                                  'Sign in to join the conversation and reply to ${widget.author}\'s post.')
                              : widget.postType == PostType.main
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SinglePost(
                                                isLoggedIn:
                                                    widget.isLoggedIn ?? false,
                                                openkeyboard: true,
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
                                    )
                                  : null,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/comment.svg",
                                color: Color.fromARGB(255, 255, 255, 255),
                                width: 17,
                              ),
                              const SizedBox(width: 4),
                              Text("${widget.commentCounts}",
                                  style: GamerzTheme.interactionStyle.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 17)),
                            ],
                          )),

                      // Text("$commentCounts comments",
                      //     style: GamerzTheme.interactionStyle)),
                      const SizedBox(width: 16),
                      WidgetButton(
                          onPressed: () => widget.isLoggedIn != true
                              ? promptLogin(context, sizeManager,
                                  'Sign in to join the conversation in ${widget.author}\'s post.')
                              : likePost(
                                  userLiked == true ? false : true, context),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/filLike.svg",
                                color: userLiked == true
                                    ? CustomColors.primaryColor
                                    : Color.fromARGB(255, 255, 254, 254),
                                width: 17,
                              ),
                              const SizedBox(width: 4),
                              Text("${likes}",
                                  style: GamerzTheme.interactionStyle.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 17)),
                            ],
                          )),
                      // const SizedBox(width: 16),
                      // SvgPicture.asset("assets/icons/filRepost.svg",
                      //     width: 15),
                      const SizedBox(width: 16),
                      SvgPicture.asset(
                        "assets/icons/send.svg",
                        width: 17,
                        color: Color.fromARGB(255, 255, 253, 253),
                      ),
                    ],
                  ),
                )
              ],
            ));
      },
    ));
  }

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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  )),

              // post content\
              SizedBox(width: 20),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                    SizedBox(
                        height: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                                  fontWeight: FontWeight.w800,
                                                )))),
                                    const SizedBox(width: 6),
                                    SvgPicture.asset(
                                        "assets/icons/filVerified.svg",
                                        width: 12),
                                  ],
                                )),
                            Expanded(
                                child: SizedBox(
                                    // height: 3,
                                    child: Align(
                              alignment: Alignment.topRight,
                              child: PopupMenuButton<String>(
                                color: Colors.black,
                                // elevation: 20,
                                // padding:
                                //     const EdgeInsets.symmetric(vertical: 0),
                                child: Container(
                                  height: 36,
                                  width: 48,
                                  alignment: Alignment.centerRight,
                                  child: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                  ),
                                ),

                                onSelected: (String choice) {
                                  // c.updateTab(2);

                                  widget.isLoggedIn != true
                                      ? promptLogin(context, sizeManager,
                                          'Sign in to join the conversation in ${widget.author}\'s post.')
                                      : handleClick(choice, context, widget.id,
                                          sizeManager);
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
                            )))
                            // const Icon(
                            //   Icons.more_horiz,
                            //   color: Colors.white,
                            // )
                          ],
                        )),
                    const SizedBox(height: 1),
                    Text(widget.date, style: GamerzTheme.interactionStyle),
                    const SizedBox(height: 15),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () => widget.isLoggedIn != true
                                  ? promptLogin(context, sizeManager,
                                      'Sign in to join the conversation in ${widget.author}\'s post.')
                                  : widget.postType == PostType.main
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SinglePost(
                                                    isLoggedIn:
                                                        widget.isLoggedIn ??
                                                            false,
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
                                        )
                                      : null,
                              child: Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(widget.content,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: GamerzTheme.postStyle))),
                          const SizedBox(height: 10),
                          widget.image != null
                              ? GestureDetector(
                                  onTap: () => _showFullScreenDialog(
                                      context, widget.image),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.image as String,
                                    imageBuilder: (context, imageProvider) =>
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              fit: BoxFit.cover,
                                              widget.image as String,
                                              // width: double.infinity,
                                              // height: MediaQuery.of(context).size.height * 0.4,
                                            )),
                                    placeholder: (context, url) =>
                                        ShimmerSliderImage(),
                                    // SpinKitRipple(
                                    //     color: Color(0xffE91E63)
                                    // ),
                                    errorWidget: (context, url, error) =>
                                        const Visibility(
                                            visible: false,
                                            child: Icon(Icons.error)),
                                  ))
                              : const SizedBox.shrink()
                        ]),
                  ]))
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              widget.addingComment == null || widget.addingComment == false
                  ? _stackedHeads()
                  : const SizedBox.shrink(),

              // likes >>>>>>>>>>>

              widget.addingComment == null || widget.addingComment == false
                  ? FittedBox(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            WidgetButton(
                                onPressed: () => widget.isLoggedIn != true
                                    ? promptLogin(context, sizeManager,
                                        'Sign in to join the conversation and reply to ${widget.author}\'s post.')
                                    : widget.postType == PostType.main
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SinglePost(
                                                      isLoggedIn:
                                                          widget.isLoggedIn ??
                                                              false,
                                                      openkeyboard: true,
                                                      body: PostBody(
                                                        id: widget.id,
                                                        author: widget.author,
                                                        image: widget.image,
                                                        content: widget.content,
                                                        authorId:
                                                            widget.authorId,
                                                        authorAvatar:
                                                            widget.authorAvatar,
                                                        commentCounts: widget
                                                            .commentCounts,
                                                        likes: likes,
                                                        date: widget.date,
                                                      ),
                                                    )),
                                          )
                                        : null,

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             AddComment(
                                //                 body: PostBody(
                                //                   id: widget.id,
                                //                   author: widget.author,
                                //                   authorId:
                                //                       widget.authorId,
                                //                   image: widget.image,
                                //                   content:
                                //                       widget.content,
                                //                   commentCounts: widget
                                //                       .commentCounts,
                                //                   likes: likes,
                                //                   date: widget.date,
                                //                 ),
                                //                 postProvider: widget
                                //                     .postProvider)),
                                //   ),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/comment.svg",
                                      color: const Color.fromARGB(
                                          148, 198, 198, 198),
                                      width: 15,
                                    ),
                                    const SizedBox(width: 4),
                                    Text("${widget.commentCounts}",
                                        style: GamerzTheme.interactionStyle
                                            .copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14)),
                                  ],
                                )),

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
                                    SvgPicture.asset(
                                      "assets/icons/filLike.svg",
                                      color: userLiked == true
                                          ? CustomColors.primaryColor
                                          : const Color.fromARGB(
                                              148, 198, 198, 198),
                                      width: 15,
                                    ),
                                    const SizedBox(width: 4),
                                    Text("${likes}",
                                        style: GamerzTheme.interactionStyle
                                            .copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14)),
                                  ],
                                )),
                            // const SizedBox(width: 16),
                            // SvgPicture.asset("assets/icons/filRepost.svg",
                            //     width: 15),
                            const SizedBox(width: 16),

                            SvgPicture.asset(
                              "assets/icons/send.svg",
                              width: 15,
                              color: const Color.fromARGB(148, 198, 198, 198),
                            ),
                          ],
                        ),
                      ],
                    ))
                  : const SizedBox.shrink()
            ],
          )

          // const Expanded(
          //     child: DottedLine(
          //   direction: Axis.vertical,
          //   // alignment: WrapAlignment.center,
          //   lineLength: 10,
          //   lineThickness: 1.0,
          //   dashLength: 20.0,
          //   dashColor: Color(0xff9A9A9A),
          //   // dashGradient: [Colors.red, Colors.blue],
          //   dashRadius: 0.0,
          //   dashGapLength: 10.0,
          //   dashGapColor: Colors.transparent,
          //   // dashGapGradient: [Colors.red, Colors.blue],
          //   dashGapRadius: 0.0,
          // )),
          // }),

          // Container(
          //   width: 282,
          //   height: 0,
          // ),
        ],
      ),

      // likes >>>>>>>>>>>>>>>>>>>>>>>>>>.
    );
  }
}
