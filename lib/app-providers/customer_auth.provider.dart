
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class CustomerAuth with ChangeNotifier{
    final String baseUrl = "http://192.168.1.101:3333";

  Future <Map<String, dynamic>> customerRegister(fname, lname, phone, email, gender, password) async{
    print("submitting $fname");
    try {
      var requestPayload = {
        "first_name": fname,
        "last_name": lname,
        "phone": phone,
        "email": email,
        "gender": 1,
        "password": password,
        "setup_reason_id": 1
      };
     print("payload $requestPayload");
      http.Response response = await http.post(
        "$baseUrl/CustomerRegistration",
        body: json.encode(requestPayload),
        headers: {
          'Content-type' : 'application/json',
        }
      );
      print('response body raw ${response.body}');
      final Map<String, dynamic> decodedData = jsonDecode(response.body);
      print('successful $decodedData');
      return {'success' : true, 'message': 'Registration successful'};
  
    } catch(error) {
      print('error occured $error');
      return {'success' : false, 'message': 'Registration failed'};
    }
  }

  // tempCustomerRegistrationData(fname, lname, phone, email,gender) async {

  // }
}