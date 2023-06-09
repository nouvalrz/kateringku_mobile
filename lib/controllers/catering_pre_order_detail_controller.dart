import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/models/pre_order_detail_for_catering_model.dart';

import '../data/repositories/order_repo.dart';

class CateringPreOrderDetailController extends GetxController {
  final OrderRepo orderRepo;

  CateringPreOrderDetailController({required this.orderRepo});

  var isLoading = true.obs;

  PreOrderDetailForCateringModel? preOrderDetailModel;

  Future<void> getOrderDetail(int id) async {
    isLoading.value = true;
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );

    Response response = await orderRepo.getCateringPreOrderDetail(id);

    if (response.statusCode == 200) {
      preOrderDetailModel =
          PreOrderDetailForCateringModel.fromJson(response.body['order']);
    }

    EasyLoading.dismiss();
    isLoading.value = false;
  }
}
