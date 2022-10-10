import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kateringku_mobile/screens/authentication/authentication_view.dart';
// ignore: unused_import
import 'package:kateringku_mobile/themes/app_theme.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const KateringKuApp());
}

class KateringKuApp extends StatelessWidget {
  const KateringKuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: const AuthenticationView(),
    );
  }
}
