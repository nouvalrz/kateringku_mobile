import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constant.dart';
import '../api/api_client.dart';

class CustomerAddressRepo {
  final ApiClient apiClient;
  CustomerAddressRepo({required this.apiClient});

  void setToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    print("TOKEN FROM REPO " + token!);
    apiClient.token = token!;
    apiClient.updateHeader(token);
    print("HEADER FROM REPO");
    print(apiClient.mainHeaders);
  }

  Future<Response> getAllAddress() async{
    setToken();
    print("HEADER");
    // print(apiClient.mainHeaders);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    return await apiClient.getDataWithToken(
        AppConstant.GET_ALL_ADDRESS, token!);
  }
}