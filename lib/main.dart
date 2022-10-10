import 'package:flutter/material.dart';
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
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'KateringKu',
            style: Theme.of(context).textTheme.titleLarge,
          )),
    );
  }
}
