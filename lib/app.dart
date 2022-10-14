import 'package:flutter/material.dart';
import 'package:kateringku_mobile/constants/route_name.dart';
import 'package:kateringku_mobile/services/navigation_service.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';

class KateringKuApp extends StatelessWidget {
  const KateringKuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: AppTheme.theme, home: const Wrapper());
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Navigator(
      onGenerateRoute: NavigationService.instance.onGeneratedRoute,
      initialRoute: welcomePath,
      key: NavigationService.instance.navigatorKey,
    ));
  }
}
