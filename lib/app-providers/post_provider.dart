import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../data-models.dart/postModel.dart';
import '../data-models.dart/single-game.model.dart';
import '../service/config.dart';
import '../data-models.dart/postModel.dart' as post;
import '../data-models.dart/myPostModel.dart' as mypost;
import '../data-models.dart/userPostModel.dart' as userpost;
import '../data-models.dart/commentsModel.dart' as comment;
import '../service/http-services.dart';
import 'main_provider.dart';

class PostProvider with ChangeNotifier {
  String _message = 'From Provider';
  HTTPInstances hTTPInstances = HTTPInstances();
  final String baseUrl = Config.baseUrl;

  SingleGame _singleGame = SingleGame();

  post.Result _allPosts = post.Result(data: [], meta: MetaInfo());

  mypost.Result _myPosts = mypost.Result(data: [], meta: MetaInfo());

  userpost.Result _userPosts = userpost.Result(data: [], meta: MetaInfo());
  List<post.Data> _postLiked = [];
  List<comment.CommentData> _allComments = [];

  bool _isLoadingAllPosts = false;
  bool _isInitialLoadingAllPosts = false;
  bool _isInitialLoadingMyOrUsersPosts = false;
  bool _isReportingPost = false;
  bool _isLoadingMyOrUsersPosts = false;
  bool _isLoadingPostsLiked = false;
  bool _isLoadingComments = false;
  String _activeComment = '';
  bool _isReviewingPost = false;

  String get message {
    return _message;
  }

  String get activeComment {
    return _activeComment;
  }

  SingleGame get singleGame {
    return _singleGame;
  }

  post.Result get allposts {
    return _allPosts;
  }

  mypost.Result get myPosts {
    return _myPosts;
  }

  userpost.Result get userPosts {
    return _userPosts;
  }

  List<post.Data> get postLiked {
    return List.from(_postLiked);
  }

  List<comment.CommentData> get allComments {
    return List.from(_allComments);
  }

  bool get isLoadingAllPosts {
    return _isLoadingAllPosts;
  }

  bool get isInitialLoadingAllPosts {
    return _isInitialLoadingAllPosts;
  }

  bool get isInitialLoadingMyOrUsersPosts {
    return _isInitialLoadingMyOrUsersPosts;
  }

  bool get isReportingPost {
    return _isReportingPost;
  }

  bool get isLoadingPostsLiked {
    return _isLoadingPostsLiked;
  }

  bool get isLoadingMyOrUsersPosts {
    return _isLoadingMyOrUsersPosts;
  }

  bool get isLoadingComments {
    return _isLoadingComments;
  }

  bool get isReviewingPost {
    return _isReviewingPost;
  }

  var headers = {'apikey': 'dfghyru2ed_34gdddsfggddfdqa'};

  Future<void> getAllPosts({
    int page = 1,
  }) async {
    try {
      // Show loading state on initial load
      if (allposts.data!.isEmpty) {
        _isInitialLoadingAllPosts = true;
      } else {
        _isLoadingAllPosts = true;
      }

      notifyListeners();
      // Determine the appropriate URL and headers based on token presence
      final token = await localStorage.getData(name: 'token');
      final url = 'post/${token != null ? 'all' : 'all-no-auth'}?page=$page';

      if (token != null) {
        headers['Authorization'] = "Bearer $token";
      }
      // bypass token to sent request with or without toke
      dynamic decodedData =
          await hTTPInstances.httpGet(url, byePassToken: true);

      final serialized = post.Result.fromJson(decodedData['result']);
      if (page > 1) {
        if (serialized.data!.isNotEmpty) {
          List<Data> newList = serialized.data ?? [];
          List<Data> initList = allposts.data ?? [];
          List<Data> updatedData = initList + newList;

          _allPosts = post.Result(data: updatedData, meta: serialized.meta);
        }
      } else {
        _allPosts = serialized;
      }
      // Update state with the fetched posts
      _isLoadingAllPosts = false;
      _isInitialLoadingAllPosts = false;
      notifyListeners();
    } catch (error) {
      print('Error occurred fetching posts: $error');
      _isLoadingAllPosts = false;
      _isInitialLoadingAllPosts = false;
      notifyListeners();
      rethrow; // rethrow the error to be handled further up the call stack if needed
    }
  }

  Future<void> getMyPosts({int page = 1}) async {
    try {
      // Show loading state on initial load
      if (_myPosts.data!.isEmpty) {
        _isInitialLoadingMyOrUsersPosts = true;
      } else {
        _isLoadingMyOrUsersPosts = true;
      }

      notifyListeners();
      // Determine the appropriate URL and headers based on token presence
      final token = await localStorage.getData(name: 'token');
      String url = 'post/mine?page=$page';

      headers['Authorization'] = "Bearer $token";

      // Fetch posts
      dynamic decodedData = await hTTPInstances.httpGet(url);

      final serialized = mypost.Result.fromJson(decodedData['result']);
      // Update state with the fetched posts
      if (page > 1) {
        if (serialized.data!.isNotEmpty) {
          List<Data> newList = serialized.data ?? [];
          List<Data> initList = _myPosts.data ?? [];
          List<Data> updatedData = initList + newList;

          _myPosts = mypost.Result(data: updatedData, meta: serialized.meta);
        }
      } else {
        _myPosts = serialized;
      }

      _isLoadingMyOrUsersPosts = false;
      _isInitialLoadingMyOrUsersPosts = false;
      notifyListeners();
    } catch (error) {
      _isLoadingMyOrUsersPosts = false;
      _isInitialLoadingMyOrUsersPosts = false;
      notifyListeners();
      rethrow; // rethrow the error to be handled further up the call stack if needed
    }
  }

  Future<void> getUserPosts({required String id, int page = 1}) async {
    try {
      // Show loading state on initial load
      if (_userPosts.data!.isEmpty ||
          _userPosts.data![0].author![0].sId != id) {
        _isInitialLoadingMyOrUsersPosts = true;
      } else {
        // empty user post for new user
        if (_userPosts.data != null) {
          if (_userPosts.data![0].author![0].sId != id) {
            _userPosts = userpost.Result(data: [], meta: MetaInfo());
          }
        }

        _isLoadingMyOrUsersPosts = true;
      }

      notifyListeners();
      // Determine the appropriate URL and headers based on token presence
      final token = await localStorage.getData(name: 'token');
      String url = 'post/user/$id?page=$page';

      headers['Authorization'] = "Bearer $token";

      // Fetch posts
      dynamic decodedData = await hTTPInstances.httpGet(url);
      print(url);
      print('decoded $decodedData');
      final serialized = userpost.Result.fromJson(decodedData['result']);
      // Update state with the fetched posts
      // Update state with the fetched posts
      if (page > 1) {
        if (serialized.data!.isNotEmpty) {
          List<Data> newList = serialized.data ?? [];
          List<Data> initList = _userPosts.data ?? [];
          List<Data> updatedData = initList + newList;

          _userPosts =
              userpost.Result(data: updatedData, meta: serialized.meta);
        }
      } else {
        _userPosts = serialized;
      }
      _isLoadingMyOrUsersPosts = false;
      _isInitialLoadingMyOrUsersPosts = false;
      notifyListeners();
    } catch (error) {
      _isLoadingMyOrUsersPosts = false;
      _isInitialLoadingMyOrUsersPosts = false;
      notifyListeners();
      rethrow; // rethrow the error to be handled further up the call stack if needed
    }
  }

  Future<void> getPostsLiked() async {
    try {
      // Show loading state on initial load
      if (_postLiked.isEmpty) {
        _isLoadingPostsLiked = true;
        notifyListeners();
      }
      // Determine the appropriate URL and headers based on token presence
      final token = await localStorage.getData(name: 'token');
      const url = 'post/liked-posts';

      headers['Authorization'] = "Bearer $token";

      // Fetch posts
      dynamic decodedData = await hTTPInstances.httpGet(url);

      final serialized = post.Result.fromJson(decodedData['result']);

      // Update state with the fetched posts
      _postLiked = serialized.data ?? [];
      _isLoadingPostsLiked = false;
      notifyListeners();
    } catch (error) {
      print('Error occurred fetching posts: $error');
      _isLoadingPostsLiked = false;
      notifyListeners();
      rethrow; // rethrow the error to be handled further up the call stack if needed
    }
  }

  getPostComments(id) async {
    try {
      // set active comment and clear initial comment if new id

      if (id != activeComment) {
        _allComments = [];
        _activeComment = id;
        notifyListeners();
      }
      //  show loading state on  initial load
      if (_allComments.isEmpty) {
        _isLoadingComments = true;
      }
      var token = await localStorage.getData(name: 'token');
      headers['Authorization'] = "Bearer $token";

      print('gettig comments');

      notifyListeners();

      //  call /all if user is logged in
      dynamic decodedData =
          await hTTPInstances.httpGet('comment/post/$id/comments');
      var serialized = comment.Result.fromJson(decodedData['result']);

      _allComments = serialized.data ?? [];

      _isLoadingComments = false;
      print('comments $_allComments');
      notifyListeners();
    } catch (error) {
      print('errror occured fetching posts $error');
      _isLoadingComments = false;
      notifyListeners();
      rethrow;
    }
  }

  updateCommentList(newComment) {
    _allComments.add(newComment);
    notifyListeners();
  }

  likePost(
      {required String id,
      required bool isLiked,
      required String authorId}) async {
    try {
      notifyListeners();

      dynamic decodedData = await hTTPInstances.httpPost(
        path: 'like/$id/like',
        data: {"isLiked": isLiked, "authorId": authorId},
      );

      // http.Response response = await http.post(
      //     Uri.parse('$baseUrl/like/$id/like'),
      //     body: jsonEncode({"isLiked": isLiked}),
      //     headers: headers);

      // final decodedData = jsonDecode(response.body);
      // if (response.statusCode != 201) {
      //   throw (decodedData['error'] ?? 'Something went wrong');
      // }
      notifyListeners();
    } catch (error) {
      print('errror occured fetching posts $error');
      _isLoadingComments = false;
      notifyListeners();
      rethrow;
    }
  }

  deletePost(id) async {
    try {
      var token = await localStorage.getData(name: 'token');
      headers['Authorization'] = "Bearer $token";
      headers['Content-type'] = 'application/json';
      notifyListeners();

      dynamic decodedData = await hTTPInstances.httpDelete('post/mine/$id');

      getAllPosts();
      getMyPosts();
      notifyListeners();
    } catch (error) {
      print('errror occured fetching posts $error');
      _isLoadingComments = false;
      notifyListeners();
      rethrow;
    }
  }

  updateReviewStatus(bool status) {
    _isReviewingPost = status;
    notifyListeners();
  }

  reportPost(id, message) async {
    try {
      _isReportingPost = true;
      SmartDialog.showLoading();
      notifyListeners();
      await hTTPInstances.httpPost(
        path: 'post/report/$id',
        data: {"message": message},
      );
      _isReportingPost = false;
      SmartDialog.dismiss();
      notifyListeners();
    } catch (error) {
      print('errror occured reporting posts $error');
      _isReportingPost = false;
      SmartDialog.showToast((error as Map<String, dynamic>)['error'],
          displayTime: const Duration(seconds: 3));
      SmartDialog.dismiss();
      notifyListeners();
      rethrow;
    }
  }
}
