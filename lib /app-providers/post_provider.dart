import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../data-models.dart/game-images.dart';
import '../data-models.dart/game.model.dart';
import '../data-models.dart/games.dart';
import '../data-models.dart/genre.dart';
import '../data-models.dart/single-game.model.dart';
import '../service/config.dart';
import '../data-models.dart/postModel.dart' as post;
import '../data-models.dart/commentsModel.dart' as comment;
import 'main_provider.dart';

class PostProvider with ChangeNotifier {
  String _message = 'From Provider';
  final String baseUrl = Config.baseUrl;

  SingleGame _singleGame = SingleGame();

  List<post.Data> _allPosts = [];

  List<post.Data> _myPosts = [];
  List<comment.CommentData> _allComments = [];

  bool _isLoadingAllPosts = true;
  bool _isLoadingMyPosts = true;
  bool _isLoadingComments = true;
  String _activeComment = '';

  String get message {
    return _message;
  }

  String get activeComment {
    return _activeComment;
  }

  SingleGame get singleGame {
    return _singleGame;
  }

  List<post.Data> get allposts {
    return List.from(_allPosts);
  }

  List<post.Data> get myPosts {
    return List.from(_myPosts);
  }

  List<comment.CommentData> get allComments {
    return List.from(_allComments);
  }

  bool get isLoadingAllPosts {
    return _isLoadingAllPosts;
  }

  bool get isLoadingMyPosts {
    return _isLoadingMyPosts;
  }

  bool get isLoadingComments {
    return _isLoadingComments;
  }

  var headers = {'apikey': 'dfghyru2ed_34gdddsfggddfdqa'};

  Future<void> getAllPosts() async {
    try {
      // Show loading state on initial load
      if (_allPosts.isEmpty) {
        _isLoadingAllPosts = true;
        notifyListeners();
      }
      // Determine the appropriate URL and headers based on token presence
      final token = await localStorage.getData(name: 'token');
      final url = Uri.parse(
        '$baseUrl/post/${token != null ? 'all' : 'all-no-auth'}',
      );

      if (token != null) {
        headers['Authorization'] = "Bearer $token";
      }

      // Fetch posts
      final response = await http.get(url, headers: headers);

      // Decode and process the response
      final decodedData = jsonDecode(response.body);
      final serialized = post.Result.fromJson(decodedData['result']);

      // Update state with the fetched posts
      _allPosts = serialized.data ?? [];
      _isLoadingAllPosts = false;

      print('Posts: $_allPosts');
      notifyListeners();
    } catch (error) {
      print('Error occurred fetching posts: $error');
      _isLoadingAllPosts = false;
      notifyListeners();
      rethrow; // rethrow the error to be handled further up the call stack if needed
    }
  }

  Future<void> getMyPosts() async {
    try {
      // Show loading state on initial load
      if (_myPosts.isEmpty) {
        _isLoadingMyPosts = true;
        notifyListeners();
      }
      // Determine the appropriate URL and headers based on token presence
      final token = await localStorage.getData(name: 'token');
      final url = Uri.parse(
        '$baseUrl/post/mine',
      );

      headers['Authorization'] = "Bearer $token";

      // Fetch posts
      final response = await http.get(url, headers: headers);

      // Decode and process the response
      final decodedData = jsonDecode(response.body);
      final serialized = post.Result.fromJson(decodedData['result']);

      // Update state with the fetched posts
      _myPosts = serialized.data ?? [];
      _isLoadingMyPosts = false;
      notifyListeners();
    } catch (error) {
      print('Error occurred fetching posts: $error');
      _isLoadingMyPosts = false;
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
      http.Response response = await http.get(
          Uri.parse('$baseUrl/comment/post/$id/comments'),
          headers: headers);

      final decodedData = jsonDecode(response.body);
      print('post result ${decodedData}');

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

  likePost(id, isLiked) async {
    try {
      var token = await localStorage.getData(name: 'token');
      headers['Authorization'] = "Bearer $token";
      headers['Content-type'] = 'application/json';
      notifyListeners();
      http.Response response = await http.post(
          Uri.parse('$baseUrl/like/$id/like'),
          body: jsonEncode({"isLiked": isLiked}),
          headers: headers);

      final decodedData = jsonDecode(response.body);
      if (response.statusCode != 201) {
        throw (decodedData['error'] ?? 'Something went wrong');
      }
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
      http.Response response = await http
          .delete(Uri.parse('$baseUrl/post/mine/$id'), headers: headers);

      final decodedData = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (decodedData['error'] ?? 'Something went wrong');
      }
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
}
