class AppConstant {
  // static const BASE_URL = "https://catering-marketplace.nouvalrz.my.id/";
  // static const BASE_URL = "http://10.0.2.2:8080/";
  // static const BASE_URL = "http://127.0.0.1:8080/";
  static const BASE_URL = "https://api.katering-ku.com/";
  static const TOKEN = "token";
  static const TYPE = "type";
  static const MAIN_ADDRESS = "main_address";

  // NGROK for midtrans
  static const BASE_URL_NGROK = "https://api.katering-ku.com/";

  // auth endpoint
  static const LOGIN_URI = "api/customer/login";
  static const LOGOUT_URI = "api/customer/logout";
  static const REGISTER_URI = "api/customer/register";
  static const OTP_VALIDATION_URI = "api/customer/register/validate-otp";
  static const CHECK_EMAIL_URI = "api/customer/register/check-email";
  static const CHECK_PHONE_URI = "api/customer/register/check-phone";
  static const GET_RELEVANT_CATERING_PRODUCTS =
      "api/catering/client/get-relevant";

  static const POST_CUSTOMER_ADDRESS = "api/customer/address/add";

  static String GET_CATERING_PRODUCT(int id) {
    return "api/catering/client/2/get-products";
  }

  static String GET_CATERING_DASHBOARD = "api/catering-mobile/get-dashboard";

  static String GET_PRODUCT_DETAIL = "api/catering/product/get";
  static const GET_ALL_ORDER = "api/customer/order/index";
  static String POST_PRE_ORDER = "api/customer/preorder/create";
  static String POST_SUBS_ORDER = "api/customer/subsorder/create";

  static const GET_PROFILE = "api/customer/profile";
  static const GET_ALL_ADDRESS = "api/customer/address";
  static const GET_ALL_CART = "api/customer/cart/index";
  static const POST_CART = "api/customer/cart/add-instant";
  static const POST_CART_PREORDER = "api/customer/cart/preorder/add";

  static String DELETE_CART_PREORDER(int id) {
    return "api/customer/cart/preorder/$id/delete";
  }

  static String GET_PREORDER_DETAIL(int id) {
    return "api/customer/preorder/$id/show";
  }

  static String GET_CATERING_PREORDER_DETAIL(int id) {
    return "api/catering-mobile/preorder/$id/show";
  }

  static String GET_SUBSORDER_DETAIL(int id) {
    return "api/customer/subsorder/$id/show";
  }

  static String GET_ORDER_PAID_STATUS(int id) {
    return "api/customer/order/$id/show-paid-status";
  }

  static String SET_ORDER_TO_ACCEPTED(int id) {
    return "api/customer/order/$id/set-to-accepted";
  }

  static String SET_SUBSORDER_TO_ACCEPTED =
      "api/customer/subsorder/set-to-accepted";

  static const SHOW_CHAT = "api/customer/chat/show";
  static const SEND_CHAT = "api/customer/chat/send";
  static const GET_LIST_CHAT = "api/customer/chat/index";

  static const SEARCH = "api/catering/client/get-search-result";
  static const CATEGORY_SEARCH = "api/catering/client/get-category-result";

  static const POST_REVIEW = "api/customer/review/create";
  static const POST_COMPLAINT = "api/customer/complaint/create";
  static const POST_COMPLAINT_SUBS = "api/customer/complaint-subs/create";

  static String GET_CATERING_REVIEW(int cateringId) {
    return "api/catering/client/${cateringId}/reviews";
  }
}
