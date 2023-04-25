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

  deleteUserToken() async{
    await sharedPreferences.remove(AppConstant.TOKEN);
  }

  void setToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    print("TOKEN FROM REPO " + token!);
    apiClient.token = token!;
    apiClient.updateHeader(token);
    print("HEADER FROM REPO");
    print(apiClient.mainHeaders);
  }

  Future<Response> profile() async{
    setToken();
    // print("HEADER");
    // print(apiClient.mainHeaders);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    return await apiClient.getDataWithToken(
        AppConstant.GET_PROFILE, token!);
  }


  Future<Response> logout() async{
    setToken();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);

    return await apiClient.getDataWithToken(
        AppConstant.LOGOUT_URI, token!);
  }
}
