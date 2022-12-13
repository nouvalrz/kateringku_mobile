class AppConstant {
  // static const BASE_URL = "https://catering-marketplace.nouvalrz.my.id/";
  static const BASE_URL = "http://127.0.0.1:8000/";
  static const TOKEN = "token";
  static const MAIN_ADDRESS = "main_address";

  // auth endpoint
  static const LOGIN_URI = "api/customer/login";
  static const REGISTER_URI = "api/customer/register";
  static const OTP_VALIDATION_URI = "api/customer/register/validate-otp";
  static const CHECK_EMAIL_URI = "api/customer/register/check-email";
  static const CHECK_PHONE_URI = "api/customer/register/check-phone";
  static const GET_RELEVANT_CATERING_PRODUCTS =
      "api/catering/client/get-relevant";

  static String GET_CATERING_PRODUCT(int id){
    return "api/catering/client/2/get-products";
  }

  static const GET_ALL_ADDRESS = "api/customer/address";
}
