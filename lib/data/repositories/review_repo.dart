import 'package:get/get_connect/http/src/response/response.dart';

import '../../constants/app_constant.dart';
import '../api/api_client.dart';

class ReviewRepo {
  final ApiClient apiClient;
  ReviewRepo({required this.apiClient});

  Future<Response> getCateringReview(int cateringId) async {
    return await apiClient.getData(AppConstant.GET_CATERING_REVIEW(cateringId));
  }
}
