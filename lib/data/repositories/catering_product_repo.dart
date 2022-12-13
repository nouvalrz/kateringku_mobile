import 'package:kateringku_mobile/data/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class CateringProductRepo{

  final ApiClient apiClient;
  CateringProductRepo({required this.apiClient});

  Future<Response> getProductsFromCatering(String catering_id) async{
    String url = "api/catering/client/$catering_id/get-products";
    return await apiClient.getData(url);
  }
}