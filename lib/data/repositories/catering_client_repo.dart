import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constant.dart';
import '../api/api_client.dart';

class CateringClientRepo {
  final ApiClient apiClient;
  CateringClientRepo({required this.apiClient});

  void setToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeader(token);
  }

  Future<Response> getCateringDashboard() async {
    setToken();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    return await apiClient.getDataWithToken(
        AppConstant.GET_CATERING_DASHBOARD, token!);
  }
}
