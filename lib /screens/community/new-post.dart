import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import 'dart:io';

import '../../commom/avatar.dart';
import '../../commom/ui/gamerzRaisedButton.dart';
import '../../service/local-storage.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  List<XFile>? _imageFileList = [];
  final ImagePicker _picker = ImagePicker();
  LocalStorage localStorage = LocalStorage();
  TextEditingController messageController = TextEditingController();

  // Function to know the size of a certain file
  checkSize(XFile? x, int decimals) async {
    final file = File(x!.path);
    int bytes = file.lengthSync();
    log("lengthSync $bytes", name: "FILE SIZE");
    double sizeMb = bytes / (1000 * 1000);
    // the return is mb default
    return sizeMb.toStringAsFixed(decimals);
    // below if you wanted to return suffix just uncomment them
    // const suffixes = ["b", "kb", "mb", "gb", "tb"];
    // var i = (m.log(bytes) / m.log(1024)).floor();
    // return ((bytes / m.pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
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

      print('image length ${_imageFileList!.length}');
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
        SmartDialog.showToast("You cannot submit an empty post");
        return;
      }
      SmartDialog.showLoading();
      var token = await localStorage.getData(name: 'token');

      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer " + token
      }; // ignore this headers if there is no authentication

      // string to uri
      var uri = Uri.parse('fdsfsdgfd');

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);
      print('uri $uri');

      for (var img in _imageFileList!) {
        if (img.path != '') {
          var multipartFiles = await http.MultipartFile.fromPath(
            'post_images',
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
      print("message is ${messageController.text}");
      request.fields['message'] = messageController.text;

      // send
      var response = await request.send();

      print(response.statusCode);
      // listen for response
      var stringResponse = await response.stream.toBytes();
      var responseString = String.fromCharCodes(stringResponse);
      print(responseString);
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

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: Center(
              child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(
                        color: Color(0xffD0D0D0),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      )))),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text("New post",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff8C8C8C),
                fontWeight: FontWeight.w400,
              )),
          actions: [
            Center(
                child: GamerzElevatedButtonSmall(
              label: "Post",
              onPressed: () => submit(context),
            ))
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 25),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                    color: Color(0xff313132),
                    border: Border.all(color: Color(0xFF747474), width: 1),
                    borderRadius: BorderRadius.circular(12)),
                // width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        AvatarSmall(
                          img: "assets/icons/image1.png",
                        ),
                        SizedBox(width: 26),
                        Text('Start typing',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: (() => _getFromGallery(context)),
                            child: const SizedBox(
                                child: Icon(
                              Icons.image,
                              size: 24,
                              color: Colors.white,
                            ))),
                        Expanded(
                            child: TextFormField(
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
                            contentPadding: const EdgeInsets.only(left: 16),
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
            SizedBox(height: 30),
            _imageFileList != null
                ? _imageFileList!.length > 0
                    ? Container(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          key: UniqueKey(),
                          itemCount: _imageFileList!.length,
                          itemBuilder: (BuildContext context, index) {
                            return Stack(children: [
                              Container(
                                  padding: EdgeInsets.fromLTRB(5, 5, 15, 5),
                                  // radius: 50,

                                  child: Semantics(
                                      label: 'Images',
                                      child: Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 4.0,
                                                  spreadRadius: 0.3)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Colors.white),
                                        child: Image.file(
                                            File(_imageFileList![index].path)),
                                      ))),
                              Positioned(
                                  right: 3,
                                  child: GestureDetector(
                                      onTap: () {
                                        print('index $index');
                                        setState(() {
                                          _imageFileList!.removeAt(index);
                                        });
                                      },
                                      child: Icon(Icons.close_outlined,
                                          size: 20, color: Colors.red[700]))),
                            ]);
                          },
                        ))
                    : Container()
                : Container(),
            SizedBox(height: 40),
          ],
        )));
  }
}
