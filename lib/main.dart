import 'package:flutter/material.dart';
import 'package:kateringku_mobile/screens/onboard/onboard_view.dart';
// ignore: unused_import
import 'package:kateringku_mobile/themes/app_theme.dart';

void main() {
  runApp(const KateringKuApp());
}

class KateringKuApp extends StatelessWidget {
  const KateringKuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: const OnboardView(),
    );
  }
}
