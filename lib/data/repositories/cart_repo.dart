import 'package:get/get_connect/http/src/response/response.dart';
import 'package:kateringku_mobile/models/add_cart_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constant.dart';
import '../api/api_client.dart';

class CartRepo {
  final ApiClient apiClient;
  CartRepo({required this.apiClient});

  void setToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeader(token);
  }

  Future<Response> getCarts() async{
    setToken();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    return await apiClient.getDataWithToken(
        AppConstant.GET_ALL_CART, token!);
  }

  Future<Response> deleteCart(int id) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeader(token);
    return await apiClient.getData(
        AppConstant.DELETE_CART_PREORDER(id));
  }

  Future<Response> saveCart(AddCartBody addCartBody) async{
    setToken();
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // var token = preferences.getString(AppConstant.TOKEN);
    return await apiClient.postData(
        AppConstant.POST_CART, addCartBody.toJson());
  }

  Future<Response> postCart(Map<String, dynamic> cartRequest)async{
    setToken();
    return await apiClient.postData(
        AppConstant.POST_CART_PREORDER, cartRequest);
  }
}