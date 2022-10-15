import 'package:get/get.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';
import 'package:kateringku_mobile/data/api/api_client.dart';
import 'package:kateringku_mobile/models/customer_login_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> login(CustomerLoginBody customerLoginBody) async {
    return await apiClient.postData(
        AppConstant.LOGIN_URI, customerLoginBody.toJson());
  }

  saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstant.TOKEN, token);
  }
}
