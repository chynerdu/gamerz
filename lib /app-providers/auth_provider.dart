import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

import '../data-models.dart/login.dart';
import '../data-models.dart/postModel.dart';
import '../data-models.dart/register.dart';
import '../service/config.dart';
import '../data-models.dart/userModel.dart' as userDataModel;
import '../service/http-services.dart';
import 'main_provider.dart';
import 'post_provider.dart';

class UserAuthProvider with ChangeNotifier {
  String _message = 'From Provider';
  final String baseUrl = Config.baseUrl;
  HTTPInstances hTTPInstances = HTTPInstances();

  userDataModel.Data _userData = userDataModel.Data();
  userDataModel.Data _otherUserData = userDataModel.Data();

  bool _isLoadingAuth = true;

  userDataModel.Data get userData {
    return _userData;
  }

  userDataModel.Data get otherUserData {
    return _otherUserData;
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
      dynamic decodedData =
          await hTTPInstances.httpPost(path: 'auth/login', data: loginData);

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
      dynamic decodedData = await hTTPInstances.httpPost(
        path: 'auth/socialSignIn',
        data: {"type": type},
        useCustomHeaders: true,
        customHeaders: {
          'Content-type': 'application/json',
          'socialtoken': '$token'
        },
      );

      print('decord $decodedData');
      await localStorage.setData(
          name: 'token', data: decodedData['result']['token']);
      var serialized = userDataModel.Result.fromJson(decodedData['result']);

      _userData = serialized.data!;

      _isLoadingAuth = false;
      print('logged in $_userData');
      notifyListeners();
    } catch (error) {
      _isLoadingAuth = false;
      print('errror occured  $error');
      if (error.toString().contains('sign up')) {
        throw ('signup');
      }

      notifyListeners();
      rethrow;
    }
  }

  register(RegisterModel registrationData) async {
    try {
      _isLoadingAuth = true;

      notifyListeners();

      //  call /all if user is logged in

      dynamic decodedData = await hTTPInstances.httpPost(
        path: 'auth/register',
        data: registrationData,
      );

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
      print('token $token');
      if (token == null) return;

      // show loading when userData is null
      if (_userData.sId == null) _isLoadingAuth = true;

      notifyListeners();

      dynamic decodedData = await hTTPInstances.httpGet('auth/getMe');

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

  getOtherUserProfie(String userId) async {
    try {
      var token = await localStorage.getData(name: 'token');
      // Reset other user data
      // if calling a different user
      if (_otherUserData.sId != userId) {
        _otherUserData = userDataModel.Data();
        _isLoadingAuth = true;
      }

      headers['Authorization'] = "Bearer $token";
      print('token $token');
      if (token == null) return;

      notifyListeners();

      dynamic decodedData =
          await hTTPInstances.httpGet('auth/getOtherUser/$userId');

      var serialized = userDataModel.Result.fromJson(decodedData['result']);

      _otherUserData = serialized.data!;

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

      dynamic decodedData = await hTTPInstances.httpPost(
          path: 'auth/socialSignup',
          data: {type: type},
          useCustomHeaders: true,
          customHeaders: {
            'Content-type': 'application/json',
            'socialtoken': token
          });
      await localStorage.setData(
          name: 'token', data: decodedData['result']['token']);
      var serialized = userDataModel.Result.fromJson(decodedData['result']);

      _userData = serialized.data!;

      _isLoadingAuth = false;

      notifyListeners();
    } catch (error) {
      _isLoadingAuth = false;
      notifyListeners();
      rethrow;
    }
  }

  updateUserProfile({required String key, required String value}) async {
    try {
      print('submittinh $key');
      _isLoadingAuth = true;
      SmartDialog.showLoading();
      notifyListeners();

      await hTTPInstances.httpPut(
          path: 'auth/updateProfile', data: {"data": value, "key": key});
      SmartDialog.dismiss();
      await getUserProfie();
    } catch (error) {
      _isLoadingAuth = false;
      notifyListeners();
      SmartDialog.showToast(error as String,
          displayTime: const Duration(seconds: 3));
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

  subscribeToFirebase(String firebaseToken) async {
    try {
      _isLoadingAuth = true;

      notifyListeners();
      final payload = {
        "firebaseDeviceToken": firebaseToken,
      };
      //  call /all if user is logged in
      await hTTPInstances.httpPost(
          path: 'auth/subscribeFirebase', data: payload);

      _isLoadingAuth = false;

      notifyListeners();
      print('subscribed to firebase');
    } catch (error) {
      print('errror occured  $error');
      _isLoadingAuth = false;
      notifyListeners();
      rethrow;
    }
  }
}
