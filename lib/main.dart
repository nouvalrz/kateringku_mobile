import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:kateringku_mobile/themes/app_theme.dart';

import 'app.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const KateringKuApp());
}
