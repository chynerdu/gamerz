import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamerz/commom/custom-colors.dart';
import 'package:gamerz/shared/post-container.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'dart:io';

import '../../app-providers/auth_provider.dart';
import '../../app-providers/post_provider.dart';
import '../../commom/avatar.dart';
import '../../commom/gamerz-wrapper.dart';
import '../../commom/theming.dart';
import '../../commom/ui/shimmers.dart';
import '../../data-models.dart/commentsModel.dart' as postComment;
import '../../service/config.dart';
import '../../service/local-storage.dart';
import 'for-you/for-you.dart';

class SinglePost extends StatefulWidget {
  PostBody body;
  bool? openkeyboard;
  bool isLoggedIn;

  SinglePost(
      {super.key,
      required this.body,
      required this.isLoggedIn,
      this.openkeyboard = false});

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  TextEditingController messageController = TextEditingController();
  LocalStorage localStorage = LocalStorage();
  bool showSubmitButton = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
      if (widget.openkeyboard == true) {
        FocusScope.of(context).requestFocus(focusNode);
      }
    });

    super.initState();
  }

  getData() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    await postProvider.getPostComments(widget.body.id);
  }

  submit(context) async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);

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
      var uri = Uri.parse('${Config.baseUrl}/comment/${widget.body.id}/create');

      // create multipart request
      var request = http.MultipartRequest("POST", uri);
      //add headers
      request.headers.addAll(headers);
      //adding params
      request.fields['message'] = messageController.text;
      request.fields['authorId'] = widget.body.authorId;

      // send
      var response = await request.send();
      // listen for response
      // var stringResponse = await response.stream.toBytes();
      // var responseString = String.fromCharCodes(stringResponse);
      var streamedResponse = await http.Response.fromStream(response);
      var responseData = jsonDecode(streamedResponse.body);
      SmartDialog.dismiss();

      if (response.statusCode == 201 || response.statusCode == 200) {
        // SmartDialog.showToast("posted");
        postProvider.getAllPosts();
        var comment = responseData['result']['data'];
        postComment.CommentData newComment = postComment.CommentData(
            sId: comment['_id'],
            message: comment['message'],
            updatedAt: DateTime.now().toString(),
            commenter: [
              postComment.Commenter(
                  firstName: authProvider.userData.firstName,
                  lastName: authProvider.userData.lastName,
                  sId: authProvider.userData.sId)
            ]);
        postProvider.updateCommentList(newComment);
        FocusNode().unfocus();
        setState(() {
          messageController.text = '';
        });
      } else {
        SmartDialog.showToast(responseData.error ?? 'failed');
        return;
      }
    } catch (e) {
      print('error $e');
      SmartDialog.dismiss();
    }
  }

  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final authProvider = Provider.of<UserAuthProvider>(context);
    // FocusManager.instance.primaryFocus?.focus();
    return GamerzWrapper(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            // resizeToAvoidBottomInset: false,
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
                Expanded(
                    child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          children: [
                            PostContainer(
                                postType: PostType.single,
                                isLoggedIn: widget.isLoggedIn,
                                id: widget.body.id,
                                content: widget.body.content,
                                commentCounts: widget.body.commentCounts,
                                likes: widget.body.likes,
                                author: widget.body.author,
                                authorId: widget.body.authorId,
                                authorAvatar: widget.body.authorAvatar,
                                date: widget.body.date,
                                image: widget.body.image,
                                postProvider: postProvider),
                            const SizedBox(height: 10),
                            const Divider(
                                thickness: 1,
                                height: 0,
                                color: Color(0xFF747474)),
                            postProvider.isLoadingComments
                                ? ShimmerShortList()
                                : postProvider.allComments.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.only(top: 40),
                                        child: Text("No comments yet",
                                            style: TextStyle(
                                                color: (Colors.white))))
                                    : ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        reverse: true,
                                        shrinkWrap: true,
                                        itemCount:
                                            postProvider.allComments.length,
                                        separatorBuilder: (context, index) {
                                          return const Divider(
                                              thickness: 0.3,
                                              height: 0,
                                              color: CustomColors.dividerColor);
                                        },
                                        itemBuilder:
                                            ((BuildContext context, index) {
                                          postComment.CommentData userComments =
                                              postProvider.allComments[index];
                                          return PostContainer(
                                              postType: PostType.comments,
                                              isLoggedIn: widget.isLoggedIn,
                                              showFollow: false,
                                              id: userComments.sId as String,
                                              content:
                                                  "${userComments.message}",
                                              commentCounts:
                                                  userComments.replies != null
                                                      ? userComments.replies
                                                          as int
                                                      : 0,
                                              likes: userComments.likes != null
                                                  ? userComments.likes as int
                                                  : 0,
                                              author:
                                                  "${userComments.commenter![0].firstName}",
                                              authorId: userComments
                                                  .commenter![0].sId as String,
                                              authorAvatar:
                                                  "${userComments.commenter![0].profilePicture}",
                                              date:
                                                  Jiffy(userComments.updatedAt)
                                                      .fromNow(),
                                              postProvider: postProvider);
                                        }),
                                      )
                          ],
                        ))),
                Column(children: [
                  Row(
                    children: [
                      // Input
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 7),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 35, 35, 35),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 25,
                                  height: 25,
                                  child: AvatarBig(
                                    isNetwork:
                                        authProvider.userData.profileImage !=
                                                null
                                            ? true
                                            : false,
                                    img: authProvider.userData.profileImage ??
                                        "assets/icons/image1.png",
                                  )),
                              Expanded(
                                  child: TextFormField(
                                onChanged: (String value) => {
                                  if (messageController.text.isNotEmpty)
                                    {
                                      setState(() {
                                        showSubmitButton = true;
                                      })
                                    }
                                  else
                                    setState(() {
                                      showSubmitButton = false;
                                    })
                                },
                                controller: messageController,
                                textInputAction: TextInputAction.newline,
                                focusNode: focusNode,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFFFFFF)),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Reply to ${widget.body.author}",
                                  hintStyle: const TextStyle(
                                      fontSize: 15,
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
                        ),
                      ),
                      Visibility(
                          visible: showSubmitButton,
                          maintainAnimation: true,
                          maintainState: true,
                          child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.linear,
                              opacity: showSubmitButton ? 1 : 0,
                              child: GestureDetector(
                                  onTap: () => submit(context),
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      padding: EdgeInsets.all(5),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Icon(Icons.send_rounded)))))
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom)),
                ])
              ],
            )));
  }
}
