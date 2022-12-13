import 'package:get/get.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';
import 'package:kateringku_mobile/controllers/auth_controller.dart';
import 'package:kateringku_mobile/controllers/catering_home_controller.dart';
import 'package:kateringku_mobile/controllers/customer_address_controller.dart';
import 'package:kateringku_mobile/controllers/otp_validation_controller.dart';
import 'package:kateringku_mobile/controllers/register_controller.dart';
import 'package:kateringku_mobile/controllers/relevant_catering_products_controller.dart';
import 'package:kateringku_mobile/data/api/api_client.dart';
import 'package:kateringku_mobile/data/repositories/auth_repo.dart';
import 'package:kateringku_mobile/data/repositories/catering_product_repo.dart';
import 'package:kateringku_mobile/data/repositories/customer_address_repo.dart';
import 'package:kateringku_mobile/data/repositories/otp_validation_repo.dart';
import 'package:kateringku_mobile/data/repositories/register_repo.dart';
import 'package:kateringku_mobile/data/repositories/relevant_catering_products_repo.dart';
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

  Get.lazyPut(() => RelevantCateringProductsRepo(apiClient: Get.find()));
  Get.lazyPut(() => CateringProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => CustomerAddressRepo(apiClient: Get.find()));

  // controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => RegisterController(registerRepo: Get.find()));
  Get.lazyPut(() => OtpValidationController(otpValidationRepo: Get.find()));
  Get.lazyPut(() => RelevantCateringProductsController(
      relevantCateringProductsRepo: Get.find()));
  Get.lazyPut(() => CateringHomeController(cateringProductRepo: Get.find()));
  Get.lazyPut(() => CustomerAddressController(customerAddressRepo: Get.find()));

}
