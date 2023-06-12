import 'package:get/get_connect/http/src/response/response.dart';
import 'package:kateringku_mobile/models/pre_order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constant.dart';
import '../api/api_client.dart';

class OrderRepo {
  final ApiClient apiClient;

  OrderRepo({required this.apiClient});

  Future<Response> postPreOrder(PreOrderModel preOrderModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeader(token);
    return await apiClient.postData(
        AppConstant.POST_PRE_ORDER, preOrderModel.toJson());
  }

  Future<Response> postSubsOrder(Map<String, dynamic> data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeader(token);
    return await apiClient.postData(AppConstant.POST_SUBS_ORDER, data);
  }

  Future<Response> deleteCart(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeader(token);
    return await apiClient.getData(AppConstant.DELETE_CART_PREORDER(id));
  }

  void setToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    apiClient.token = token!;
    apiClient.updateHeader(token);
  }

  Future<Response> getOrders() async {
    setToken();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    return await apiClient.getDataWithToken(AppConstant.GET_ALL_ORDER, token!);
  }

  Future<Response> getPreOrderDetail(int id) async {
    return await apiClient.getData(AppConstant.GET_PREORDER_DETAIL(id));
  }

  Future<Response> getCateringPreOrderDetail(int id) async {
    return await apiClient
        .getData(AppConstant.GET_CATERING_PREORDER_DETAIL(id));
  }

  Future<Response> getCateringSubsOrderDetail(int id) async {
    return await apiClient
        .getData(AppConstant.GET_CATERING_SUBSORDER_DETAIL(id));
  }

  Future<Response> getSubsOrderDetail(int id) async {
    return await apiClient.getData(AppConstant.GET_SUBSORDER_DETAIL(id));
  }

  Future<Response> getOrderPaidStatus(int id) async {
    return await apiClient.getData(AppConstant.GET_ORDER_PAID_STATUS(id));
  }

  Future<Response> setOrderToAccepted(int id) async {
    return await apiClient.getData(AppConstant.SET_ORDER_TO_ACCEPTED(id));
  }

  Future<Response> setOrderToRequestCancel(int id) async {
    return await apiClient.getData(AppConstant.SET_ORDER_TO_REQUEST_CANCEL(id));
  }

  Future<Response> setSubsOrderToAccepted(Map<String, dynamic> data) async {
    return await apiClient.postData(
        AppConstant.SET_SUBSORDER_TO_ACCEPTED, data);
  }

  Future<Response> changeOrderStatusForCatering(
      Map<String, dynamic> data) async {
    return await apiClient.postData(
        AppConstant.CHANGE_ORDER_STATUS_FOR_CATERING, data);
  }

  Future<Response> changeOrderStatusOneDayForCatering(
      Map<String, dynamic> data) async {
    return await apiClient.postData(
        AppConstant.CHANGE_SUBSORDER_STATUS_ONE_DAY_FOR_CATERING, data);
  }
}
