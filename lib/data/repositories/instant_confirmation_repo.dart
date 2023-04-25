import 'package:get/get_connect/http/src/response/response.dart';
import 'package:kateringku_mobile/models/add_cart_body.dart';
import 'package:kateringku_mobile/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constant.dart';
import '../api/api_client.dart';

class InstantConfirmationRepo{
  final ApiClient apiClient;
  InstantConfirmationRepo({required this.apiClient});

  void setToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConstant.TOKEN);
    print("TOKEN FROM REPO " + token!);
    apiClient.token = token!;
    apiClient.updateHeader(token);
    print("HEADER FROM REPO");
    print(apiClient.mainHeaders);
  }

  Future<Response> getProductDetail(Product product) async{
    return await apiClient.postData(
        AppConstant.GET_PRODUCT_DETAIL, product.toJson());
  }

}