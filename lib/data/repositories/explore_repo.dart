import 'package:get/get_connect/http/src/response/response.dart';

import '../../constants/app_constant.dart';
import '../api/api_client.dart';

class ExploreRepo{

  final ApiClient apiClient;
  ExploreRepo({required this.apiClient});

  Future<Response> getSearchResult(Map<String, dynamic> request) async {
    return await apiClient.postData(
        AppConstant.SEARCH, request);
  }

  Future<Response> getCategoryResult(Map<String, dynamic> request) async {
    return await apiClient.postData(
        AppConstant.CATEGORY_SEARCH, request);
  }
}