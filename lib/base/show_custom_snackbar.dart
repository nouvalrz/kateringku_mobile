import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';

void showCustomSnackBar(
    {bool isError = true, String title = "Error", required String message}) {
  Get.snackbar(title, message,
      titleText: Text(title, style: AppTheme.textTheme.bodyLarge),
      duration: const Duration(milliseconds: 5000),
      messageText: Text(
        message,
      ),
      snackPosition: SnackPosition.TOP,
      leftBarIndicatorColor: AppTheme.primaryOrange,
      borderRadius: 2,
      snackStyle: SnackStyle.FLOATING,
      overlayColor: AppTheme.primaryGreen,
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      icon: Icon(Icons.notifications_outlined),
      backgroundColor: Colors.white);
  // borderColor: Colors.white,
  // borderWidth: 1);
}
