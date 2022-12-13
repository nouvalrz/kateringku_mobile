import 'package:get/get.dart';
import 'package:kateringku_mobile/screens/catering/catering_view.dart';
import 'package:kateringku_mobile/screens/dashboard/dashboard_view.dart';
import 'package:kateringku_mobile/screens/home/home_view.dart';
import 'package:kateringku_mobile/screens/instant_order/instant_order_confirmation_view.dart';
import 'package:kateringku_mobile/screens/login/login_view.dart';
import 'package:kateringku_mobile/screens/onboard/onboard_view.dart';
import 'package:kateringku_mobile/screens/otp/otp_validation_view.dart';
import 'package:kateringku_mobile/screens/register/register_view.dart';

class RouteHelper {
  static const String initial = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String otpValidation = "/otp-validation";
  static const String dashboard = "/dashboard";
  static const String mainHome = "/main-home";
  static const String catering = "/catering";
  static const String instantOrderConfirmation = '/instant-order-confirmation';


  static String getIntial() => initial;
  static String getLogin() => login;
  static String getRegister() => register;
  static String getOtpValidation(String email, String password) =>
      "$otpValidation?email=$email&password=$password";
  static String getDashboard() => dashboard;
  static String getMainHome() => mainHome;
  static String getCatering({ required String catering_name, required String catering_location, required String catering_image, required String catering_id}){
    return "$catering?cateringId=$catering_id&cateringName=$catering_name&cateringLocation=$catering_location&cateringImage=$catering_image";
  }
    static String getInstantOrderConfirmation() => instantOrderConfirmation;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const OnboardView()),
    GetPage(
        name: login,
        page: () => const LoginView(),
        transition: Transition.cupertino),
    GetPage(
        name: register,
        page: () => const RegisterView(),
        transition: Transition.cupertino),
    GetPage(
        name: otpValidation,
        page: () {
          var email = Get.parameters["email"];
          var password = Get.parameters["password"];
          return OtpValidationView(
            email: email!,
            password: password!,
          );
        },
        transition: Transition.cupertino),
    GetPage(
        name: dashboard,
        page: () => const DashboardView(),
        transition: Transition.cupertino),
    GetPage(
        name: mainHome,
        page: () => const HomeView(),
        transition: Transition.cupertino),
    GetPage(
        name: catering,
        page: (){
          var catering_id = Get.parameters["cateringId"];
          var catering_name = Get.parameters["cateringName"];
          var catering_location = Get.parameters["cateringLocation"];
          var catering_image = Get.parameters["cateringImage"];
          return CateringView(catering_name: catering_name!, catering_location: catering_location!, catering_image: catering_image!, catering_id: catering_id!,);
        }
    ),
    GetPage(
      name: instantOrderConfirmation,
      page: ()=> InstantOrderConfirmationView(),
      transition: Transition.cupertino,
    )
  ];
}
