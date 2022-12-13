import 'package:get/get.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';
import 'package:kateringku_mobile/data/api/api_client.dart';
import 'package:kateringku_mobile/models/relevant_catering_products_request_body.dart';

class RelevantCateringProductsRepo {
  final ApiClient apiClient;

  RelevantCateringProductsRepo({required this.apiClient});

  Future<Response> getRelevantCateringProducts(
      RelevantCateringProductsRequestBody
          relevantCateringProductsRequestBody) async {
    return await apiClient.postData(AppConstant.GET_RELEVANT_CATERING_PRODUCTS,
        relevantCateringProductsRequestBody.toJson());
  }
}
