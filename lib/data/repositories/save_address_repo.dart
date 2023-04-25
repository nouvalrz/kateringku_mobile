import 'package:get/get_connect/http/src/response/response.dart';
import 'package:kateringku_mobile/models/add_customer_address_body.dart';

import '../../constants/app_constant.dart';
import '../api/api_client.dart';

class SaveAddressRepo{

  final ApiClient apiClient;
  SaveAddressRepo({required this.apiClient});

  Future<Response> saveAddress(AddCustomerAddressBody addCustomerAddressBody) async {
    return await apiClient.postData(
        AppConstant.POST_CUSTOMER_ADDRESS, addCustomerAddressBody.toJson());
  }
}