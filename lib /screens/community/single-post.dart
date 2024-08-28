import 'package:flutter/material.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import 'dart:io';

import '../../commom/avatar.dart';
import '../../commom/theming.dart';
import '../../commom/ui/gamerzRaisedButton.dart';
import '../../data-models.dart/postModel.dart';
import '../../service/local-storage.dart';
import 'for-you/for-you.dart';
import '../../data-models.dart/commentsmodel.dart' as comment;

class SinglePost extends StatefulWidget {
  PostBody body;
  SinglePost({super.key, required this.body});

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  TextEditingController messageController = TextEditingController();
  LocalStorage localStorage = LocalStorage();

  submit(context) async {
    FocusScope.of(context).unfocus();

    try {
      if (messageController.text.isEmpty) {
        SmartDialog.showToast("You cannot submit an empty comment");
        return;
      }
      SmartDialog.showLoading();
      var token = await localStorage.getData(name: 'token');

      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer " + token
      }; // ignore this headers if there is no authentication

      // string to uri
      // var uri = Uri.parse(APIPath.postComments(widget.body.id));
      var uri = Uri.parse('dggfgfgfgfhg');

      // create multipart request
      var request = http.MultipartRequest("POST", uri);
      //add headers
      request.headers.addAll(headers);
      //adding params
      request.fields['message'] = messageController.text;

      // send
      var response = await request.send();
      // listen for response
      var stringResponse = await response.stream.toBytes();
      var responseString = String.fromCharCodes(stringResponse);
      SmartDialog.dismiss();

      if (response.statusCode == 201 || response.statusCode == 200) {
        SmartDialog.showToast("posted");
        Navigator.pop(context);
      } else {
        SmartDialog.showToast(responseString);
        return;
      }
    } catch (e) {
      print('error $e');
      SmartDialog.dismiss();
    }
  }

  Data singlePost = Data(
      sId: '3545454ffggg',
      isActive: true,
      isDeleted: true,
      isApproved: true,
      message: "Demo post",
      comments: 1,
      author: [Author(sId: "343243254", firstName: "Kelvin", lastName: "Dust")],
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
      ]);

  List<comment.Data> comments = [
    comment.Data(
        likes: 2,
        sId: '242354354fdg',
        message: 'A comments',
        updatedAt: DateTime.now().toString(),
        replies: 2,
        commenter: [
          comment.Commenter(
              firstName: 'Kelvin', lastName: 'Wale', sId: '34324234rewfsd')
        ],
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
        ])
  ];

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          titleSpacing: 32,
          // automaticallyImplyLeading: false,
          leadingWidth: 24, //
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_rounded)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: const Text('Post', style: GamerzTheme.appbarStyle),
        ),
        body: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.60,

                // width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    PostContainer(
                        id: widget.body.id,
                        content: widget.body.content,
                        commentCounts: widget.body.commentCounts,
                        likes: widget.body.likes,
                        author: widget.body.author,
                        date: widget.body.date,
                        image: widget.body.image),
                    const SizedBox(height: 10),
                    const Divider(
                        thickness: 1, height: 0, color: Color(0xFF747474)),
                    comments != null
                        ? comments.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Text("No comments yet",
                                    style: TextStyle(color: (Colors.white))))
                            : ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                reverse: true,
                                shrinkWrap: true,
                                itemCount: comments.length,
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                      thickness: 0.3,
                                      height: 0,
                                      color:
                                          Color.fromARGB(255, 180, 180, 180));
                                },
                                itemBuilder: ((BuildContext context, index) {
                                  comment.Data userComments = comments[index];
                                  return PostContainer(
                                    showFollow: false,
                                    id: userComments.sId as String,
                                    content: "${userComments.message}",
                                    commentCounts: userComments.replies as int,
                                    likes: userComments.likes as int,
                                    author:
                                        "${userComments.commenter![0].firstName}",
                                    date:
                                        Jiffy(userComments.updatedAt).fromNow(),
                                  );
                                }),
                              )
                        : const Center(
                            child: Text("Nothing to show yet",
                                style: TextStyle(color: (Colors.white))))
                  ],
                ))),
            Expanded(
                // bottom: 0,

                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                              color: const Color(0xff313132),
                              border: Border.all(
                                  color: const Color(0xFF747474), width: 1),
                              borderRadius: BorderRadius.circular(12)),
                          // width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const AvatarSmall(
                                    img: "assets/icons/image1.png",
                                  ),
                                  const SizedBox(width: 26),
                                  Text('reply to @${widget.body.author}',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Container(
                                  //     child: const Icon(
                                  //   Icons.image,
                                  //   size: 24,
                                  //   color: Colors.white,
                                  // )),
                                  Expanded(
                                      child: TextFormField(
                                    controller: messageController,
                                    style: const TextStyle(
                                        fontSize: 16, color: Color(0xFFFFFFFF)),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "Start typing",
                                      hintStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff989898)),
                                      contentPadding:
                                          const EdgeInsets.only(left: 16),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                              // text
                            ],
                          )),
                      const SizedBox(height: 16),
                      GamerzElevatedButtonSmall(
                        label: "Reply",
                        onPressed: () => submit(context),
                      )
                    ])))
          ],
        ));
  }
}
