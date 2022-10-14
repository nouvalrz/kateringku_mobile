import 'package:flutter/material.dart';
import 'package:kateringku_mobile/constants/route_name.dart';
import 'package:kateringku_mobile/screens/authentication/authentication_view.dart';
import 'package:kateringku_mobile/screens/onboard/onboard_view.dart';
import 'package:kateringku_mobile/screens/register/register_view.dart';

class NavigationService {
  NavigationService._();

  static NavigationService? _instance;

  static NavigationService get instance {
    _instance ??= NavigationService._();
    return _instance!;
  }

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Route? onGeneratedRoute(RouteSettings settings) {
    final routeName = settings.name;
    switch (routeName) {
      case authPath:
        return navigateToMaterialPageRoute(
            settings, const AuthenticationView());
      case welcomePath:
        return navigateToMaterialPageRoute(settings, const OnboardView());
      case registrationPath:
        return navigateToMaterialPageRoute(settings, const RegisterView());
      default:
        return navigateToMaterialPageRoute(settings, const Scaffold());
    }
  }

  MaterialPageRoute navigateToMaterialPageRoute(
      RouteSettings settings, Widget page,
      {bool maintainState = true, bool fullscreen = false}) {
    return MaterialPageRoute(
        maintainState: maintainState,
        fullscreenDialog: fullscreen,
        settings: settings,
        builder: (_) => page);
  }
}
