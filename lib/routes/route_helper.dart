import 'package:get/get.dart';
import 'package:kateringku_mobile/models/catering_display_model.dart';
import 'package:kateringku_mobile/screens/address/add_address_detail_view.dart';
import 'package:kateringku_mobile/screens/address/add_address_map_view.dart';
import 'package:kateringku_mobile/screens/address/address_list_view.dart';
import 'package:kateringku_mobile/screens/catering/catering_review_view.dart';
import 'package:kateringku_mobile/screens/catering/catering_view.dart';
import 'package:kateringku_mobile/screens/catering/product_option_view.dart';
import 'package:kateringku_mobile/screens/catering_client/catering_dashboard_view.dart';
import 'package:kateringku_mobile/screens/catering_client/catering_pre_order_detail_view.dart';
import 'package:kateringku_mobile/screens/catering_client/catering_subs_order_detail_view.dart';
import 'package:kateringku_mobile/screens/chat/chat_list_view.dart';
import 'package:kateringku_mobile/screens/dashboard/dashboard_view.dart';
import 'package:kateringku_mobile/screens/explore/category_view.dart';
import 'package:kateringku_mobile/screens/explore/search_view.dart';
import 'package:kateringku_mobile/screens/home/home_view.dart';
import 'package:kateringku_mobile/screens/order/pre_order_detail_view.dart';
import 'package:kateringku_mobile/screens/order/subs_order_detail_view.dart';
import 'package:kateringku_mobile/screens/payment/midtrans_payment_view.dart';
import 'package:kateringku_mobile/screens/pre_order/pre_order_confirmation_view.dart';
import 'package:kateringku_mobile/screens/login/login_view.dart';
import 'package:kateringku_mobile/screens/onboard/onboard_view.dart';
import 'package:kateringku_mobile/screens/otp/otp_validation_view.dart';
import 'package:kateringku_mobile/screens/register/register_view.dart';
import 'package:kateringku_mobile/screens/chat/chat_view.dart';
import 'package:kateringku_mobile/screens/subs_order/subs_confirmation_view.dart';
import 'package:kateringku_mobile/screens/subs_order/subs_pick_product_option_view.dart';
import 'package:kateringku_mobile/screens/subs_order/subs_pick_product_view.dart';
import 'package:kateringku_mobile/screens/subs_order/subs_set_period_view.dart';

class RouteHelper {
  static const String onboard = "/onboard";
  static const String login = "/login";
  static const String register = "/register";
  static const String otpValidation = "/otp-validation";
  static const String dashboard = "/dashboard";
  static const String mainHome = "/main-home";
  static const String catering = "/catering";
  static const String instantOrderConfirmation = '/instant-order-confirmation';
  static const String addressList = '/address-list';
  static const String addAddressMap = '/add-address-map';
  static const String addAddressDetail = '/add-address-detail';
  static const String productOption = '/product-option';
  static const String midtransPayment = '/midtrans-payment';
  static const String orderDetail = '/order-detail';
  static const String subsOrderDetail = '/subs-order-detail';
  

  static const String search = "/search";
  static const String category = "/category";
  static const String chat = "/chat";
  static const String chatList = "/chat-list";
  static const String cateringReview = "/catering-review";
  static const String subsSetPeriod = '/subs-set-period';
  static const String subsPickProduct = '/subs-pick-product';
  static const String subsPickProductOption = '/subs-pick-product-option';
  static const String subsConfirmationView = '/subs-confirmation-view';
  static const String cateringClientDashboard = '/catering-client-dashboard';
  static const String cateringPreOrderDetail = '/catering-pre-order-detail';
  static const String cateringSubsOrderDetail = '/catering-subs-order-detail';

  static String getIntial() => onboard;
  static String getLogin() => login;
  static String getRegister() => register;
  static String getOtpValidation(String email, String password) =>
      "$otpValidation?email=$email&password=$password";
  static String getDashboard() => dashboard;
  static String getMainHome() => mainHome;
  static String getCatering(
      {required String catering_name,
      required String catering_location,
      required String catering_image,
      required String catering_id,
      required double catering_latitude,
      required double catering_longitude,
      String fromCart = "false"}) {
    return "$catering?cateringId=$catering_id&cateringName=$catering_name&cateringLocation=$catering_location&cateringImage=$catering_image&cateringLatitude=$catering_latitude&cateringLongitude=$catering_longitude&fromCart=$fromCart";
  }

  static String getInstantOrderConfirmation() => instantOrderConfirmation;
  static String getAddressList() => addressList;
  static String getAddAddressMap() => addAddressMap;
  static String getAddAddressDetail() => addAddressDetail;
  static String getProductOption() => productOption;
  static String getMidtransPayment() => midtransPayment;
  static String getOrderDetail() => orderDetail;
  static String getSearch() => search;
  static String getCategory() => category;
  static String getChat() => chat;
  static String getChatList() => chatList;
  static String getCateringReview() => cateringReview;
  static String getSubsPickProduct() => subsSetPeriod;

  static List<GetPage> routes = [
    GetPage(name: onboard, page: () => const OnboardView()),
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
        page: () => HomeView(),
        transition: Transition.cupertino),
    GetPage(
        name: catering,
        page: () {
          var catering_id = Get.parameters["cateringId"];
          var catering_name = Get.parameters["cateringName"];
          var catering_location = Get.parameters["cateringLocation"];
          var catering_image = Get.parameters["cateringImage"];
          var catering_latitude = Get.parameters["cateringLatitude"];
          var catering_longitude = Get.parameters["cateringLongitude"];
          var from_cart = Get.parameters["fromCart"];
          return CateringView(
            catering_name: catering_name!,
            catering_location: catering_location!,
            catering_image: catering_image!,
            catering_id: catering_id!,
            catering_latitude: double.parse(catering_latitude!),
            catering_longitude: double.parse(catering_longitude!),
            fromCart: from_cart!,
          );
        }),
    GetPage(
      name: instantOrderConfirmation,
      page: () => PreOrderConfirmationView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: addressList,
      page: () => AddressListView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: addAddressMap,
      page: () => AddAddressMapView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: addAddressDetail,
      page: () => AddAddressDetailView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: productOption,
      page: () => ProductOptionView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: midtransPayment,
      page: () => MidtransPaymentView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: orderDetail,
      page: () => PreOrderDetailView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: search,
      page: () => SearchView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: category,
      page: () => CategoryView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: chat,
      page: () => ChatView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: chatList,
      page: () => ChatListView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: cateringReview,
      page: () => CateringReviewView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: subsSetPeriod,
      page: () => SubsSetPeriodView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: subsPickProduct,
      page: () => SubsPickProductView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: subsPickProductOption,
      page: () => SubsPickProductOptionView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: subsConfirmationView,
      page: () => SubsConfirmationView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: subsOrderDetail,
      page: () => SubsOrderDetailView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: cateringClientDashboard,
      page: () => CateringDashboardView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: cateringPreOrderDetail,
      page: () => CateringPreOrderDetailView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: cateringSubsOrderDetail,
      page: () => CateringSubsOrderDetailView(),
      transition: Transition.cupertino,
    ),
  ];
}
