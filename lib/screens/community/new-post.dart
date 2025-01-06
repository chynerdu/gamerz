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
import '../../commom/ui/gamerzRaisedButton.dart';
import '../../helpers/sizeManager.dart';
import '../../service/config.dart';
import '../../service/local-storage.dart';

class NewPost extends StatefulWidget {
  final PostProvider postProvider;
  const NewPost({super.key, required this.postProvider});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  List<XFile>? _imageFileList = [];
  final ImagePicker _picker = ImagePicker();
  final LocalStorage _localStorage = LocalStorage();
  final TextEditingController _messageController = TextEditingController();

  Future<double> _getFileSizeInMB(XFile file, int decimals) async {
    final bytes = await File(file.path).length();
    return (bytes / (1024 * 1024));
  }

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final pickedFile = await _picker.pickImage(
        source: source, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      final fileSize = await _getFileSizeInMB(pickedFile, 2);
      if (fileSize > 5) {
        SmartDialog.showToast(
            "The selected file $fileSize MB is too large. Limit is 10MB",
            displayTime: Duration(seconds: 5));
      } else {
        setState(() => _imageFileList!.add(pickedFile));
      }
    }
  }

  Future<void> _submitPost(BuildContext context) async {
    if (_messageController.text.isEmpty) {
      SmartDialog.showToast("You cannot submit an empty post");
      return;
    }

    try {
      SmartDialog.showLoading();
      final token = await _localStorage.getData(name: 'token');
      final headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      };
      final uri = Uri.parse('${Config.baseUrl}/post/create');
      final request = http.MultipartRequest("POST", uri)
        ..headers.addAll(headers);

      for (var image in _imageFileList!) {
        request.files.add(await http.MultipartFile.fromPath(
          'post_images',
          image.path,
          contentType: MediaType("image", "jpg"),
        ));
      }

      request.fields['message'] = _messageController.text;
      final response = await request.send();

      final responseString = await response.stream.bytesToString();
      SmartDialog.dismiss();

      if (response.statusCode == 201 || response.statusCode == 200) {
        SmartDialog.showToast("Posted");
        if (_imageFileList!.isNotEmpty) {
          widget.postProvider.updateReviewStatus(true);
        }
        Navigator.pop(context, true);
      } else {
        SmartDialog.showToast(responseString);
      }
    } catch (e) {
      log('Error: $e');
      SmartDialog.dismiss();
    }
  }

  Widget _buildImagePreview(SizeManager sizeManager) {
    if (_imageFileList == null || _imageFileList!.isEmpty)
      return SizedBox.shrink();
    return Container(
      height: sizeManager.scaledHeight(50),
      width: sizeManager.scaledWidth(85),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(5, 5, 15, 5),
            child: Image.file(
              File(_imageFileList![0].path),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Positioned(
            right: 3,
            child: GestureDetector(
              onTap: () => setState(() => _imageFileList!.removeAt(0)),
              child:
                  Icon(Icons.close_outlined, size: 20, color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeManager = SizeManager(context);
    return GamerzWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text("Cancel",
                  style: TextStyle(
                      color: Color(0xffD0D0D0),
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text("New post",
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff8C8C8C),
                  fontWeight: FontWeight.w400)),
          actions: [
            Center(
              child: GamerzElevatedButtonSmall(
                label: "Post",
                onPressed: () => _submitPost(context),
              ),
            ),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AvatarSmall(img: "assets/icons/image1.png"),
                        SizedBox(width: 26),
                        Text('Start typing',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_imageFileList!.isEmpty)
                          GestureDetector(
                            onTap: () =>
                                _pickImage(ImageSource.gallery, context),
                            child: const Icon(Icons.image,
                                size: 24, color: Colors.white),
                          ),
                        Expanded(
                          child: TextFormField(
                            controller: _messageController,
                            maxLines: 8,
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
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              _buildImagePreview(sizeManager),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
