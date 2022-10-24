import 'package:get/get.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';
import 'package:kateringku_mobile/data/api/api_client.dart';
import 'package:kateringku_mobile/models/otp_validation_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpValidationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OtpValidationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> validate(OtpValidationBody otpValidationBody) async {
    return await apiClient.postData(
        AppConstant.OTP_VALIDATION_URI, otpValidationBody.toJson());
  }

  saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstant.TOKEN, token);
  }
}
