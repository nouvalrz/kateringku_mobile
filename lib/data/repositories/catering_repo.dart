import 'package:get/get_connect/http/src/response/response.dart';

import '../api/api_client.dart';

class CateringRepo {
  final ApiClient apiClient;
  CateringRepo({required this.apiClient});

  Future<Response> getCateringDeliveryTimeRange(String catering_id) async {
    String url = "api/catering/client/$catering_id/get-delivery-time-range";
    return await apiClient.getData(url);
  }

  Future<Response> getCateringWorkDay(String catering_id) async {
    String url = "api/catering/client/$catering_id/get-catering-work-day";
    return await apiClient.getData(url);
  }
}
