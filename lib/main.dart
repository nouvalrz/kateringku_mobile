import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';
import 'package:kateringku_mobile/routes/route_helper.dart';
import 'package:kateringku_mobile/screens/catering/catering_view.dart';
import 'package:kateringku_mobile/screens/home/home_view.dart';
import 'package:kateringku_mobile/screens/instant_order/instant_order_confirmation_view.dart';
import 'package:kateringku_mobile/screens/maps_test/google_maps_view.dart';
import 'package:kateringku_mobile/screens/onboard/onboard_view.dart';
// ignore: unused_import
import 'package:kateringku_mobile/themes/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/dependencies.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));

  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString(AppConstant.TOKEN);

  if(token!=null){
    print(token);
    runApp(const KateringKuHomeApp());
  }else{
    runApp(const KateringKuOnboardApp());
  }

}

class KateringKuHomeApp extends StatelessWidget {
  const KateringKuHomeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home:  HomeView(),
      // initialRoute: RouteHelper.initial,
      getPages: RouteHelper.routes,
    );
  }
}

class KateringKuOnboardApp extends StatelessWidget {
  const KateringKuOnboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home:  OnboardView(),
      // initialRoute: RouteHelper.initial,
      getPages: RouteHelper.routes,
    );
  }
}
