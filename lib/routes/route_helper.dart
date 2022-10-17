import 'package:get/get.dart';
import 'package:kateringku_mobile/screens/login/login_view.dart';
import 'package:kateringku_mobile/screens/onboard/onboard_view.dart';
import 'package:kateringku_mobile/screens/otp/otp_validation_view.dart';
import 'package:kateringku_mobile/screens/register/register_view.dart';

class RouteHelper {
  static const String initial = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String otpValidation = "/otp-validation";

  static String getIntial() => initial;
  static String getLogin() => login;
  static String getRegister() => register;
  static String getOtpValidation(String email) => "$otpValidation?email=$email";

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
          return OtpValidationView(email: email!);
        },
        transition: Transition.cupertino),
  ];
}
