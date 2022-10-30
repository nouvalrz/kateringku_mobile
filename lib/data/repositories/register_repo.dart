import 'package:get/get.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';
import 'package:kateringku_mobile/models/customer_check_email_body.dart';
import 'package:kateringku_mobile/models/customer_check_phone_body.dart';
import 'package:kateringku_mobile/models/customer_register_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kateringku_mobile/data/api/api_client.dart';

class RegisterRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  RegisterRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> registration(
      CustomerRegisterBody customerRegisterBody) async {
    return await apiClient.postData(
        AppConstant.REGISTER_URI, customerRegisterBody.toJson());
  }

  Future<Response> checkEmailAvail(
      CustomerCheckEmailBody customerCheckEmailBody) async {
    return await apiClient.postData(
        AppConstant.CHECK_EMAIL_URI, customerCheckEmailBody.toJson());
  }

  Future<Response> checkPhoneAvail(
      CustomerCheckPhoneBody customerCheckPhoneBody) async {
    return await apiClient.postData(
        AppConstant.CHECK_PHONE_URI, customerCheckPhoneBody.toJson());
  }
}
