import 'package:get/get.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';
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
}
