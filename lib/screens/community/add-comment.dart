import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'dart:io';

import '../../app-providers/post_provider.dart';
import '../../commom/avatar.dart';
import '../../commom/gamerz-wrapper.dart';
import '../../commom/theming.dart';
import '../../commom/ui/gamerzRaisedButton.dart';
import '../../service/config.dart';
import '../../service/local-storage.dart';
import 'for-you/for-you.dart';

class AddComment extends StatefulWidget {
  PostBody body;
  final PostProvider postProvider;
  AddComment({super.key, required this.body, required this.postProvider});

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  List<XFile>? _imageFileList = [];
  final ImagePicker _picker = ImagePicker();
  TextEditingController messageController = TextEditingController();
  LocalStorage localStorage = LocalStorage();

  // Function to know the size of a certain file
  checkSize(XFile? x, int decimals) async {
    final file = File(x!.path);
    int bytes = file.lengthSync();
    log("lengthSync $bytes", name: "FILE SIZE");
    double sizeMb = bytes / (1000 * 1000);
    // the return is mb default
    return sizeMb.toStringAsFixed(decimals);
  }

  /// Get from gallery
  _getFromGallery(context) async {
    final pickedFileList = await _picker.pickMultiImage(
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFileList != null) {
      for (var image in pickedFileList) {
        final knowSize = await checkSize(image, 2);

        // file is compressed so maximum of 2mb is technically 5 to 6MB on user side.
        if (double.parse(knowSize.toString()) > 1) {
          String message = pickedFileList.length > 1
              ? "Some file(s) are too large, limit is 10MB for each file"
              : "The selected file ${double.parse(knowSize.toString())} is too large, Limit is 10MB";
          SmartDialog.showToast(message);
        } else {
          setState(() {
            _imageFileList!.add(image);
          });
        }
      }
    }
  }

  /// Get from camera
  _getFromCamera(context) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFileList!.add(pickedFile);
      });
    }
    // Navigator.pop(context);
  }

  submit(context) async {
    FocusScope.of(context).unfocus();

    List<http.MultipartFile> newList = [];

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
      var uri = Uri.parse('${Config.baseUrl}/comment/${widget.body.id}/create');

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);
      print('uri $uri');

      for (var img in _imageFileList!) {
        if (img.path != '') {
          var multipartFiles = await http.MultipartFile.fromPath(
            'comment_images',
            img.path,
            contentType: MediaType("image", "jpg"),
          );
          newList.add(multipartFiles);
        }
      }

      //add headers
      request.headers.addAll(headers);
      request.files.addAll(newList);
      //adding params

      request.fields['message'] = messageController.text;

      request.fields['authorId'] = widget.body.authorId;

      // send
      var response = await request.send();
      // listen for response
      var stringResponse = await response.stream.toBytes();
      var responseString = String.fromCharCodes(stringResponse);
      SmartDialog.dismiss();

      if (response.statusCode == 201 || response.statusCode == 200) {
        widget.postProvider.getAllPosts();
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

  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    return GamerzWrapper(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              titleSpacing: 32,
              leadingWidth: 24, //
              leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_rounded)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              title: const Text('Post', style: GamerzTheme.appbarStyle),
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                PostContainer(
                    id: widget.body.id,
                    content: widget.body.content,
                    addingComment: true,
                    commentCounts: widget.body.commentCounts,
                    likes: widget.body.likes,
                    author: widget.body.author,
                    authorAvatar: widget.body.authorAvatar,
                    authorId: widget.body.authorId,
                    date: widget.body.date,
                    image: widget.body.image,
                    postProvider: widget.postProvider),
                Column(children: [
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
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // GestureDetector(
                              //     onTap: () => _getFromGallery(context),
                              //     child: Container(
                              //         child: Icon(
                              //       Icons.image,
                              //       size: 24,
                              //       color: Colors.white,
                              //     ))),
                              Expanded(
                                  child: TextFormField(
                                maxLength: 200,
                                controller: messageController,
                                maxLines: 3,
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
                ])
              ],
            ))));
  }
}
