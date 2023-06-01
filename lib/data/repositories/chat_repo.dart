import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constant.dart';
import '../api/api_client.dart';

class ChatRepo {
  final ApiClient apiClient;
  ChatRepo({required this.apiClient});

  Future<Response> loadMessage({required String cateringId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeader(token);
    return await apiClient
        .postData(AppConstant.SHOW_CHAT, {"catering_id": cateringId});
  }

  Future<Response> sendMessage(
      {required String cateringId, required String message}) async {
    Map<String, dynamic> body = {
      "catering_id": cateringId,
      "sender": "customer",
      "message": message
    };

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeader(token);

    return await apiClient.postData(AppConstant.SEND_CHAT, body);
  }

  Future<Response> getListChat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeader(token);

    return await apiClient.getDataWithToken(AppConstant.GET_LIST_CHAT, token);
  }
}
