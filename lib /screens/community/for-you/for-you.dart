import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:photo_view/photo_view.dart';

import '../../../commom/avatar.dart';
import '../../../commom/theming.dart';
import '../../../data-models.dart/postModel.dart';
import '../add-comment.dart';
import '../new-post.dart';
import '../single-post.dart';

class FeedForYou extends StatefulWidget {
  ScrollController mainScrollController;
  FeedForYou({required this.mainScrollController});
  @override
  State<FeedForYou> createState() => _FeedForYouState();
}

class _FeedForYouState extends State<FeedForYou> {
  @override
  void initState() {
    super.initState();
    // _getAllPostsBloc.add(const GetAllPosts());
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Data> posts = [
    Data(
        sId: '3545454ffggg',
        isActive: true,
        isDeleted: true,
        isApproved: true,
        message: "Demo post",
        comments: 1,
        author: [
          Author(sId: "343243254", firstName: "Kelvin", lastName: "Dust")
        ],
        likes: 4,
        media: [
          Media(
              sId: '3434324',
              mediaType: 'image',
              isApproved: true,
              isDeleted: false,
              isDisabled: false,
              postId: '3545454ffggg',
              url:
                  'http://res.cloudinary.com/deu3xnay0/image/upload/v1724183206/post_images/i9sufgrwczknc0zk7zej.jpg')
        ]),
    Data(
        sId: '3545454ffggg',
        isActive: true,
        isDeleted: true,
        isApproved: true,
        message: "Another Demo post",
        comments: 1,
        author: [
          Author(sId: "343243254", firstName: "Kelvin", lastName: "Dust")
        ],
        likes: 4,
        media: [
          Media(
              sId: '3434324',
              mediaType: 'image',
              isApproved: true,
              isDeleted: false,
              isDisabled: false,
              postId: '3545454ffggg',
              url:
                  'http://res.cloudinary.com/deu3xnay0/image/upload/v1724183206/post_images/agmomn54wgjbpqznx7bv.jpg')
        ])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 213, 6, 75),
            splashColor: Color.fromARGB(255, 180, 0, 60),
            onPressed: () => {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => NewPost()))
                },
            child: Icon(Icons.edit_outlined, size: 30)),
        body: Container(
            child: ListView.separated(
          itemCount: posts.length,
          controller: widget.mainScrollController,
          separatorBuilder: (context, index) {
            return const Divider(
                thickness: 1, height: 0, color: Color(0xFF747474));
          },
          itemBuilder: ((BuildContext context, index) {
            Data post = posts[index];
            return PostContainer(
                id: post.sId as String,
                content: "${post.message}",
                commentCounts: post.comments as int,
                likes: post.likes as int,
                author: "${post.author![0].firstName}",
                date: Jiffy('2024-08-20T19:46:54.583+00:00').fromNow(),
                image: post.media!.isNotEmpty ? "${post.media![0].url}" : null);
          }),
        )));
  }
}

class PostContainer extends StatelessWidget {
  final String id;
  final bool? showFollow;
  final String content;
  final dynamic image;
  final int commentCounts;
  final int likes;
  final String author;
  final String date;
  final bool? isSingle;
  final bool? isMyPost;
  final bool? addingComment;

  const PostContainer(
      {required this.content,
      required this.id,
      this.image,
      this.isSingle,
      this.showFollow = true,
      this.addingComment,
      this.isMyPost,
      required this.commentCounts,
      required this.likes,
      required this.author,
      required this.date});

  @override
  Widget _stackedHeads() => Container(
      padding: EdgeInsets.only(left: 10),
      width: 48,
      height: 16,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: commentCounts > 3 ? 3 : commentCounts,
          itemBuilder: (context, index) {
            return Align(
              widthFactor: 0.3,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: AvatarSmall(
                  img: "assets/icons/image2.png",
                ),
              ),
            );
          }));

  Widget build(BuildContext context) {
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
                      isMyPost: isMyPost,
                      child: const AvatarBig(
                        img: "assets/icons/image1.png",
                      ))
                ],
              ),
              // LayoutBuilder(
              //     builder: (BuildContext context, BoxConstraints constraints) {
              //   return

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
              addingComment == null || addingComment == false
                  ? _stackedHeads()
                  : const SizedBox.shrink()
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2),
                                            child: UserWidget(
                                                isMyPost: isMyPost,
                                                child: Text(author,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )))),
                                        const SizedBox(width: 6),
                                        SvgPicture.asset(
                                          "assets/icons/filVerified.svg",
                                        ),
                                        const SizedBox(width: 10),
                                        showFollow == true
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 1),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                        color: Colors.white)),
                                                child: const Text("Follow",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )))
                                            : const SizedBox.shrink()
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(date,
                                            style:
                                                GamerzTheme.interactionStyle),
                                        const SizedBox(width: 10),
                                        const Icon(
                                          Icons.more_horiz,
                                          color: Colors.white,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 7),
                                GestureDetector(
                                    onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SinglePost(
                                                  body: PostBody(
                                                      id: id,
                                                      author: author,
                                                      image: image,
                                                      content: content,
                                                      commentCounts:
                                                          commentCounts,
                                                      likes: likes,
                                                      date: date))),
                                        ),
                                    child: Text(content,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: GamerzTheme.postStyle)),
                              ]))),
                  const SizedBox(height: 7),
                  image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            fit: BoxFit.cover,
                            image as String,
                            // width: double.infinity,
                            // height: MediaQuery.of(context).size.height * 0.4,
                          ))
                      : const SizedBox.shrink()
                ],
              ),
              const SizedBox(height: 17),
              addingComment == null || addingComment == false
                  ? FittedBox(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SinglePost(
                                              body: PostBody(
                                                  id: id,
                                                  author: author,
                                                  image: image,
                                                  content: content,
                                                  commentCounts: commentCounts,
                                                  likes: likes,
                                                  date: date))),
                                    ),
                                child: Text("$commentCounts comments",
                                    style: GamerzTheme.interactionStyle)),
                            const SizedBox(width: 4),
                            const Text(".",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff9A9A9A),
                                  fontWeight: FontWeight.w800,
                                )),
                            const SizedBox(width: 4),
                            Text("$likes likes",
                                style: GamerzTheme.interactionStyle)
                          ],
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/filLike.svg",
                            ),
                            const SizedBox(width: 16),
                            isSingle == null || isSingle == false
                                ? GestureDetector(
                                    onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddComment(
                                                  body: PostBody(
                                                      id: id,
                                                      author: author,
                                                      image: image,
                                                      content: content,
                                                      commentCounts:
                                                          commentCounts,
                                                      likes: likes,
                                                      date: date))),
                                        ),
                                    child: SvgPicture.asset(
                                      "assets/icons/comment.svg",
                                    ))
                                : const SizedBox.shrink(),
                            const SizedBox(width: 16),
                            SvgPicture.asset(
                              "assets/icons/filRepost.svg",
                            ),
                            const SizedBox(width: 16),
                            SvgPicture.asset(
                              "assets/icons/send.svg",
                            ),
                          ],
                        )
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

  UserWidget({required this.child, this.isMyPost});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => null, child: child);
  }
}

class PostBody {
  String content;
  dynamic image;
  String id;
  int commentCounts;
  int likes;
  String author;
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
      required this.date,
      this.isSingle,
      this.isMyPost,
      this.addingComment,
      this.image});
}
