import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbars {
  showSnackbar({String? title, Icon? icon, required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        title: title ?? '',
        message: message,
        icon: icon,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
