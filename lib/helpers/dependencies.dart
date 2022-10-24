import 'package:get/get.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';
import 'package:kateringku_mobile/controllers/auth_controller.dart';
import 'package:kateringku_mobile/controllers/otp_validation_controller.dart';
import 'package:kateringku_mobile/controllers/register_controller.dart';
import 'package:kateringku_mobile/data/api/api_client.dart';
import 'package:kateringku_mobile/data/repositories/auth_repo.dart';
import 'package:kateringku_mobile/data/repositories/otp_validation_repo.dart';
import 'package:kateringku_mobile/data/repositories/register_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  // api client
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstant.BASE_URL));

  // repos
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(
      () => RegisterRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() =>
      OtpValidationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  // controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => RegisterController(registerRepo: Get.find()));
  Get.lazyPut(() => OtpValidationController(otpValidationRepo: Get.find()));
}
