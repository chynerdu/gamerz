import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../data-models.dart/game-images.dart';
import '../data-models.dart/game.model.dart';
import '../data-models.dart/games.dart';
import '../data-models.dart/genre.dart';
import '../data-models.dart/login.dart';
import '../data-models.dart/register.dart';
import '../data-models.dart/single-game.model.dart';
import '../service/config.dart';
import '../data-models.dart/userModel.dart' as userDataModel;
import '../service/local-storage.dart';
import 'main_provider.dart';

class UserAuthProvider with ChangeNotifier {
  String _message = 'From Provider';
  final String baseUrl = Config.baseUrl;

  userDataModel.Data _userData = userDataModel.Data();

  bool _isLoadingAuth = true;

  userDataModel.Data get userData {
    return _userData;
  }

  bool get isLoadingAuth {
    return _isLoadingAuth;
  }

  var headers = {
    'apikey': 'dfghyru2ed_34gdddsfggddfdqa',
  };

  login(LoginModel loginData) async {
    try {
      _isLoadingAuth = true;

      notifyListeners();

      //  call /all if user is logged in
      http.Response response = await http.post(Uri.parse('$baseUrl/auth/login'),
          body: json.encode(loginData),
          headers: {
            'Content-type': 'application/json',
          });

      final decodedData = jsonDecode(response.body);
      print('post result ${decodedData}');
      if (response.statusCode != 200) {
        throw (decodedData['error'] ?? 'Something went wrong');
      }
      await localStorage.setData(
          name: 'token', data: decodedData['result']['token']);
      var serialized = userDataModel.Result.fromJson(decodedData['result']);

      _userData = serialized.data!;

      _isLoadingAuth = false;
      print('logged in $_userData');
      notifyListeners();
    } catch (error) {
      print('errror occured  $error');
      _isLoadingAuth = false;
      notifyListeners();
      rethrow;
    }
  }

  socialLogin({type, token}) async {
    try {
      _isLoadingAuth = true;

      log('token 2 $token');
      notifyListeners();

      //  call /all if user is logged in
      http.Response response = await http.post(
          Uri.parse('$baseUrl/auth/socialSignIn'),
          body: jsonEncode({type: type}),
          headers: {'Content-type': 'application/json', 'socialtoken': token});

      final decodedData = jsonDecode(response.body);
      print('post result ${decodedData}');
      if (response.statusCode == 404) {
        throw ('signup');
      }

      if (response.statusCode != 200) {
        throw (decodedData['error'] ?? 'Something went wrong');
      }
      await localStorage.setData(
          name: 'token', data: decodedData['result']['token']);
      var serialized = userDataModel.Result.fromJson(decodedData['result']);

      _userData = serialized.data!;

      _isLoadingAuth = false;
      print('logged in $_userData');
      notifyListeners();
    } catch (error) {
      print('errror occured  $error');
      _isLoadingAuth = false;
      notifyListeners();
      rethrow;
    }
  }

  register(RegisterModel registrationData) async {
    try {
      _isLoadingAuth = true;

      notifyListeners();

      //  call /all if user is logged in
      http.Response response = await http.post(
          Uri.parse('$baseUrl/auth/register'),
          body: json.encode(registrationData),
          headers: {
            'Content-type': 'application/json',
          });

      final decodedData = jsonDecode(response.body);
      print('post result ${decodedData}');
      if (response.statusCode != 200) {
        throw (decodedData['error'] ?? 'Something went wrong');
      }
      await localStorage.setData(
          name: 'token', data: decodedData['result']['token']);
      var serialized = userDataModel.Result.fromJson(decodedData['result']);

      _userData = serialized.data!;

      _isLoadingAuth = false;
      print('registration successfull $_userData');
      notifyListeners();
    } catch (error) {
      print('errror occured $error');
      _isLoadingAuth = false;
      notifyListeners();
      rethrow;
    }
  }

  getUserProfie() async {
    try {
      var token = await localStorage.getData(name: 'token');

      headers['Authorization'] = "Bearer $token";

      if (token == null) return;
      _isLoadingAuth = true;

      notifyListeners();

      http.Response response =
          await http.get(Uri.parse('$baseUrl/auth/getMe'), headers: headers);

      final decodedData = jsonDecode(response.body);

      var serialized = userDataModel.Result.fromJson(decodedData['result']);

      _userData = serialized.data!;

      _isLoadingAuth = false;

      notifyListeners();
    } catch (error) {
      print('errror occured 2212 $error');
      _isLoadingAuth = false;
      notifyListeners();
      rethrow;
    }
  }

  socialregister({type, token}) async {
    try {
      _isLoadingAuth = true;

      notifyListeners();

      //  call /all if user is logged in
      http.Response response = await http.post(
          Uri.parse('$baseUrl/auth/socialSignup'),
          body: jsonEncode({type: type}),
          headers: {'Content-type': 'application/json', 'socialtoken': token});

      final decodedData = jsonDecode(response.body);
      print('post result ${decodedData}');
      if (response.statusCode != 200) {
        throw (decodedData['error'] ?? 'Something went wrong');
      }
      await localStorage.setData(
          name: 'token', data: decodedData['result']['token']);
      var serialized = userDataModel.Result.fromJson(decodedData['result']);

      _userData = serialized.data!;

      _isLoadingAuth = false;
      print('registration successfull $_userData');
      notifyListeners();
    } catch (error) {
      print('errror occured $error');
      _isLoadingAuth = false;
      notifyListeners();
      rethrow;
    }
  }

  logout() async {
    try {
      _isLoadingAuth = true;

      notifyListeners();

      //  call /all if user is logged in

      await localStorage.removeData(name: 'token');

      _userData = userDataModel.Data();

      _isLoadingAuth = false;
      print('logged out $_userData');
      notifyListeners();
    } catch (error) {
      print('errror occured  $error');
      _isLoadingAuth = false;
      notifyListeners();
      rethrow;
    }
  }

  // getGameImages() async {
  //   try {
  //     if (_allGameImages.isEmpty) {
  //       _isLoading = true;
  //     }

  //     notifyListeners();

  //     http.Response response =
  //         await http.get(Uri.parse('$baseUrl/game/images'), headers: headers);

  //     final decodedData = jsonDecode(response.body);

  //     var serialized = GamesImages.fromJson(decodedData['result']);

  //     _allGameImages = serialized.imagesData ?? [];
  //     _isLoading = false;
  //     notifyListeners();
  //   } catch (error) {
  //     print('errror occured 2212 $error');
  //     _isLoading = false;
  //     notifyListeners();
  //     rethrow;
  //   }
  // }

  // getAllGenres() async {
  //   try {
  //     if (_allGenres.isEmpty) {
  //       _isLoading = true;
  //     }
  //     notifyListeners();

  //     http.Response response =
  //         await http.get(Uri.parse('$baseUrl/genre/all'), headers: headers);

  //     final decodedData = jsonDecode(response.body);

  //     var serialized = GameGenres.fromJson(decodedData['result']);

  //     _allGenres = serialized.genreData ?? [];

  //     _isLoading = false;
  //     notifyListeners();
  //   } catch (error) {
  //     print('errror occured 2212 $error');
  //     _isLoading = false;
  //     notifyListeners();
  //     rethrow;
  //   }
  // }
}
