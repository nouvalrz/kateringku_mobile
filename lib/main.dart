import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/base/show_custom_snackbar.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';
import 'package:kateringku_mobile/controllers/chat_controller.dart';
import 'package:kateringku_mobile/routes/route_helper.dart';
import 'package:kateringku_mobile/screens/address/add_address_detail_view.dart';
import 'package:kateringku_mobile/screens/address/add_address_map_view.dart';
import 'package:kateringku_mobile/screens/address/address_list_view.dart';
import 'package:kateringku_mobile/screens/catering/catering_review_view.dart';
import 'package:kateringku_mobile/screens/catering/catering_view.dart';
import 'package:kateringku_mobile/screens/catering/product_option_view.dart';
import 'package:kateringku_mobile/screens/catering_client/catering_dashboard_view.dart';
import 'package:kateringku_mobile/screens/chat/chat_list_view.dart';
import 'package:kateringku_mobile/screens/explore/search_view.dart';
import 'package:kateringku_mobile/screens/home/home_view.dart';
import 'package:kateringku_mobile/screens/order/pre_order_detail_view.dart';
import 'package:kateringku_mobile/screens/payment/midtrans_payment_view.dart';
import 'package:kateringku_mobile/screens/pre_order/pre_order_confirmation_view.dart';
import 'package:kateringku_mobile/screens/maps_test/google_maps_view.dart';
import 'package:kateringku_mobile/screens/onboard/onboard_view.dart';
import 'package:kateringku_mobile/screens/chat/chat_view.dart';
import 'package:kateringku_mobile/screens/sample/datepicker_sample_view.dart';
// ignore: unused_import
import 'package:kateringku_mobile/themes/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/order_list_controller.dart';
import 'helpers/dependencies.dart' as dep;
import 'firebase_options.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications();
  await dep.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    // TODO: handle the received notifications
  } else {
    print('User declined or has not accepted permission');
  }

  print('User granted permission: ${settings.authorizationStatus}');

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'kateringku',
      'kateringku',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
      payload: 'your_payload',
    );
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    // showNotification(message);

    if (message.data != null) {
      print(message.data);
    }

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      RemoteNotification notification = message.notification!;

      showCustomSnackBar(
          message: notification.body!, title: notification.title!);

      if (message.data["type"] == "chat") {
        var currentRoute = Get.currentRoute;
        if (currentRoute == "/chat") {
          var chatController = Get.find<ChatController>();
          if (message.data["catering_id"] == chatController.cateringUser.id) {
            var chat = types.TextMessage(
              author: message.data["catering_id"].toString() ==
                      chatController.cateringUser.id
                  ? chatController.cateringUser
                  : chatController.customerUser,
              createdAt: DateTime.parse(message.data['created_at'])
                  .millisecondsSinceEpoch,
              id: const Uuid().v4(),
              text: message.data["message"],
            );
            chatController.addMessage(chat);
          }
        }
      }

      if (message.data["type"] == "PAYMENT_SUCCESS") {
        var homeController = Get.find<HomeController>();
        // var orderListController = Get.find<OrderListController>();
        // orderListController.isLoading.value = true;
        // orderListController.getAllOrders();
        homeController.tabController.value.index = 2;
        Get.until((route) => Get.currentRoute == RouteHelper.mainHome);
      }
      // showCustomSnackBar(message: "mau");
    }
  });

  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString(AppConstant.TOKEN);
  var type = preferences.getString(AppConstant.TYPE);

  if (token != null) {
    print(token);
    if (type == "customer") {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) {
        runApp(KateringKuHomeApp());
      });
    } else if (type == "catering") {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) {
        runApp(KateringKuCateringHomeApp());
      });
    }
  } else {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(KateringKuOnboardApp());
    });
  }
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await FlutterLocalNotificationsPlugin().initialize(
    initializationSettings,
  );
}

class KateringKuHomeApp extends StatelessWidget {
  KateringKuHomeApp({Key? key}) : super(key: key);
  final routeObserver = MyRouteObserver();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: HomeView(),
      initialRoute: RouteHelper.mainHome,
      getPages: RouteHelper.routes,
      navigatorObservers: [routeObserver],
      builder: EasyLoading.init(),
    );
  }
}

class KateringKuCateringHomeApp extends StatelessWidget {
  KateringKuCateringHomeApp({Key? key}) : super(key: key);
  final routeObserver = MyRouteObserver();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: CateringDashboardView(),
      initialRoute: RouteHelper.cateringClientDashboard,
      getPages: RouteHelper.routes,
      navigatorObservers: [routeObserver],
      builder: EasyLoading.init(),
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
      home: OnboardView(),
      initialRoute: RouteHelper.onboard,
      getPages: RouteHelper.routes,
      builder: EasyLoading.init(),
    );
  }
}

class MyRouteObserver extends NavigatorObserver {
  final Set<RouteAware> _listeners = <RouteAware>{};

  void subscribe(RouteAware routeAware) {
    _listeners.add(routeAware);
  }

  void unsubscribe(RouteAware routeAware) {
    _listeners.remove(routeAware);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    for (var listener in _listeners) {
      listener.didPop();
    }
  }
}
