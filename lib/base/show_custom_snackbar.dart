import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';

void showCustomSnackBar(
    {bool isError = true, String title = "Error", required String message}) {
  Get.snackbar(title, message,
      titleText: Text(title, style: AppTheme.textTheme.bodyLarge),
      duration: const Duration(milliseconds: 4000),
      messageText: Text(
        message,
      ));
}
