import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constant.dart';
import '../api/api_client.dart';

class ChatRepo{

  final ApiClient apiClient;
  ChatRepo({required this.apiClient});

  Future<Response> loadMessage({required String recipientId}) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeader(token);
    return await apiClient.postData(
        AppConstant.SHOW_CHAT, {"recipient_id" : recipientId});
  }

  Future<Response> sendMessage({required String recipientId, required String recipientType, required String message}) async{
    Map<String, dynamic> body = {
      "recipient_id" : recipientId,
      "recipient_type" : recipientType,
      "message" : message
    };

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeader(token);

    return await apiClient.postData(
        AppConstant.SEND_CHAT, body);

  }

  Future<Response> getListChat() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeader(token);

    return await apiClient.getDataWithToken(
        AppConstant.GET_LIST_CHAT, token);
  }

}