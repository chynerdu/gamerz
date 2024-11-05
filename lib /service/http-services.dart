import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../app-providers/main_provider.dart';
import '../data-models.dart/userModel.dart' as userDataModel;
import '../helpers/snackbars.dart';
import 'config.dart';

class HTTPInstances {
  CustomSnackbars customSnackbars = CustomSnackbars();
  final String baseUrl = Config.baseUrl;
  userDataModel.Data userData = userDataModel.Data();

  dynamic handleExceptions(Function request) async {
    try {
      return await request();
    } on SocketException {
      customSnackbars.showSnackbar(
          title: 'Network',
          message: 'No Internet connection',
          icon: const Icon(Icons.network_cell));
      throw 'No Internet connection';
    } on TimeoutException {
      customSnackbars.showSnackbar(
          title: 'Timed out',
          message: 'Connection Timed Out',
          icon: const Icon(Icons.timer));
      throw 'Connection Timed Out';
    } catch (e) {
      print('error heee $e');
      throw {"success": false, "error": e};
    }
  }

  httpGet(path, {bool? byePassToken = false}) async {
    return await handleExceptions(() async {
      var token = await localStorage.getData(name: 'token');
      var headers = {'apikey': 'dfghyru2ed_34gdddsfggddfdqa'};
      if (token == null && byePassToken == false) {
        throw 'Unauthorized';
      } else {
        headers['Authorization'] = "Bearer $token";
      }

      Uri url = Uri.parse('$baseUrl/$path');
      http.Response response = await http.get(url, headers: headers);
      final decodedData = jsonDecode(response.body);
      if (response.statusCode < 200 || response.statusCode > 201) {
        if (response.statusCode == 401) {
          endSession();
        }
        throw decodedData['error'];
      } else {
        return decodedData;
      }
    });
  }

  httpPost({
    required String path,
    dynamic data,
    bool? useCustomHeaders = false,
    dynamic customHeaders,
  }) async {
    return await handleExceptions(() async {
      var token = await localStorage.getData(name: 'token');

      var headers = useCustomHeaders == true
          ? customHeaders
          : {
              'apikey': 'dfghyru2ed_34gdddsfggddfdqa',
              'Content-type': 'application/json',
            };
      headers['Authorization'] = "Bearer $token";

      Uri url = Uri.parse('$baseUrl/$path');

      http.Response response =
          await http.post(url, body: jsonEncode(data), headers: headers);

      final decodedData = jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode > 201) {
        if (response.statusCode == 401) {
          endSession();
        }
        throw decodedData['error'];
      } else {
        return decodedData;
      }
    });
  }

  httpPut({
    required String path,
    dynamic data,
    bool? useCustomHeaders = false,
    dynamic customHeaders,
  }) async {
    return await handleExceptions(() async {
      var token = await localStorage.getData(name: 'token');

      var headers = useCustomHeaders == true
          ? customHeaders
          : {
              'apikey': 'dfghyru2ed_34gdddsfggddfdqa',
              'Content-type': 'application/json',
            };
      headers['Authorization'] = "Bearer $token";

      Uri url = Uri.parse('$baseUrl/$path');

      http.Response response =
          await http.put(url, body: jsonEncode(data), headers: headers);

      final decodedData = jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode > 201) {
        if (response.statusCode == 401) {
          endSession();
        }
        throw decodedData['error'];
      } else {
        return decodedData;
      }
    });
  }

  httpDelete(path) async {
    return await handleExceptions(() async {
      var token = await localStorage.getData(name: 'token');

      if (token == null) return;
      var headers = {
        'apikey': 'dfghyru2ed_34gdddsfggddfdqa',
        'Content-type': 'application/json',
      };
      headers['Authorization'] = "Bearer $token";

      Uri url = Uri.parse('$baseUrl/$path');

      http.Response response = await http.delete(url, headers: headers);

      final decodedData = jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode > 201) {
        if (response.statusCode == 401) {
          endSession();
        }
        throw decodedData['error'];
      } else {
        return decodedData;
      }
    });
  }

  endSession() async {
    try {
      await localStorage.removeData(name: 'token');
      userData = userDataModel.Data();
    } catch (error) {
      rethrow;
    }
  }
}
