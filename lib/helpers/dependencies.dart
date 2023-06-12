import 'package:get/get.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';
import 'package:kateringku_mobile/controllers/add_address_controller.dart';
import 'package:kateringku_mobile/controllers/address_controller.dart';
import 'package:kateringku_mobile/controllers/auth_controller.dart';
import 'package:kateringku_mobile/controllers/cart_controller.dart';
import 'package:kateringku_mobile/controllers/category_controller.dart';
import 'package:kateringku_mobile/controllers/catering_dashboard_controller.dart';
import 'package:kateringku_mobile/controllers/catering_home_controller.dart';
import 'package:kateringku_mobile/controllers/catering_pre_order_detail_controller.dart';
import 'package:kateringku_mobile/controllers/catering_review_controller.dart';
import 'package:kateringku_mobile/controllers/chat_controller.dart';
import 'package:kateringku_mobile/controllers/complaint_controller.dart';
import 'package:kateringku_mobile/controllers/customer_address_controller.dart';
import 'package:kateringku_mobile/controllers/customer_address_list_controller.dart';
import 'package:kateringku_mobile/controllers/instant_confirmation_controller.dart';
import 'package:kateringku_mobile/controllers/pre_order_detail_controller.dart';
import 'package:kateringku_mobile/controllers/order_list_controller.dart';
import 'package:kateringku_mobile/controllers/otp_validation_controller.dart';
import 'package:kateringku_mobile/controllers/pre_order_controller.dart';
import 'package:kateringku_mobile/controllers/profile_controller.dart';
import 'package:kateringku_mobile/controllers/register_controller.dart';
import 'package:kateringku_mobile/controllers/customer_dashboard_controller.dart';
import 'package:kateringku_mobile/controllers/review_controller.dart';
import 'package:kateringku_mobile/controllers/save_address_controller.dart';
import 'package:kateringku_mobile/controllers/search_controller.dart';
import 'package:kateringku_mobile/controllers/subs_order_controller.dart';
import 'package:kateringku_mobile/controllers/subs_order_detail_controller.dart';
import 'package:kateringku_mobile/data/api/api_client.dart';
import 'package:kateringku_mobile/data/repositories/auth_repo.dart';
import 'package:kateringku_mobile/data/repositories/cart_repo.dart';
import 'package:kateringku_mobile/data/repositories/catering_client_repo.dart';
import 'package:kateringku_mobile/data/repositories/catering_product_repo.dart';
import 'package:kateringku_mobile/data/repositories/catering_repo.dart';
import 'package:kateringku_mobile/data/repositories/chat_repo.dart';
import 'package:kateringku_mobile/data/repositories/customer_address_repo.dart';
import 'package:kateringku_mobile/data/repositories/explore_repo.dart';
import 'package:kateringku_mobile/data/repositories/instant_confirmation_repo.dart';
import 'package:kateringku_mobile/data/repositories/otp_validation_repo.dart';
import 'package:kateringku_mobile/data/repositories/order_repo.dart';
import 'package:kateringku_mobile/data/repositories/register_repo.dart';
import 'package:kateringku_mobile/data/repositories/relevant_catering_products_repo.dart';
import 'package:kateringku_mobile/data/repositories/review_repo.dart';
import 'package:kateringku_mobile/data/repositories/save_address_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/catering_subs_order_detail_controller.dart';
import '../screens/home/home_view.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences, fenix: true);

  // api client
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstant.BASE_URL));

  // repos
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);
  Get.lazyPut(
      () => RegisterRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() =>
      OtpValidationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  Get.lazyPut(() => RelevantCateringProductsRepo(apiClient: Get.find()));
  Get.lazyPut(() => CateringProductRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => CustomerAddressRepo(apiClient: Get.find()));
  Get.lazyPut(() => SaveAddressRepo(apiClient: Get.find()));
  Get.lazyPut(() => CartRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => InstantConfirmationRepo(apiClient: Get.find()));
  Get.lazyPut(() => CateringRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => OrderRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => ExploreRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => ChatRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => ReviewRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => CateringClientRepo(apiClient: Get.find()), fenix: true);

  // controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => RegisterController(registerRepo: Get.find()));
  Get.lazyPut(() => OtpValidationController(otpValidationRepo: Get.find()));
  Get.lazyPut(() =>
      CustomerDashboardController(relevantCateringProductsRepo: Get.find()));
  Get.lazyPut(() => CateringHomeController(
      cateringProductRepo: Get.find(), cartRepo: Get.find()));
  Get.lazyPut(() => CustomerAddressController(customerAddressRepo: Get.find()));
  Get.lazyPut(() => SaveAddressController(saveAddressRepo: Get.find()));
  Get.lazyPut(
      () => CustomerAddressListController(customerAddressRepo: Get.find()));
  Get.lazyPut(() => AddAddressController());
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => ProfileController(authRepo: Get.find()));
  Get.lazyPut(() =>
      PreOrderController(cateringRepo: Get.find(), preOrderRepo: Get.find()));
  Get.lazyPut(() => AddressController(customerAddressRepo: Get.find()));
  Get.lazyPut(() => HomeController(), fenix: true);
  Get.lazyPut(() => OrderListController(orderRepo: Get.find()), fenix: true);
  Get.lazyPut(() => PreOrderDetailController(orderRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => SubsOrderDetailController(orderRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => SearchController(exploreRepo: Get.find()));
  Get.lazyPut(() => CategoryController(exploreRepo: Get.find()));
  Get.lazyPut(() => ReviewController(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => CateringPreOrderDetailController(orderRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => CateringSubsOrderDetailController(orderRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => ComplaintController(apiClient: Get.find()), fenix: true);
  Get.lazyPut(
      () => CateringDashboardController(
          cateringClientRepo: Get.find(), authRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => ChatController(chatRepo: Get.find()), fenix: true);
  Get.lazyPut(
      () => SubsOrderController(
          cateringRepo: Get.find(),
          cateringProductRepo: Get.find(),
          orderRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => CateringReviewController(reviewRepo: Get.find()),
      fenix: true);
  // Get.lazyPut(() => InstantConfirmationController(instantConfirmationRepo: Get.find()));
}
