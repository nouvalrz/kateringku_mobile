import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/models/subs_order_detail_model.dart';

import '../data/repositories/order_repo.dart';

class SubsOrderDetailController extends GetxController {
  final OrderRepo orderRepo;

  SubsOrderDetailController({required this.orderRepo});

  var isLoading = true.obs;

  var orderDetail = SubsOrderDetailModel().obs;

  var isSetOrderToAcceptedLoading = false.obs;

  Future<void> getOrderDetail(int id) async {
    isLoading.value = true;
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );

    Response response = await orderRepo.getSubsOrderDetail(id);

    if (response.statusCode == 200) {
      orderDetail.value = SubsOrderDetailModel.fromJson(response.body['order']);
    }

    EasyLoading.dismiss();
    isLoading.value = false;
  }

  Future<void> setOrderToAccepted({required Map<String, dynamic> date}) async {
    isSetOrderToAcceptedLoading.value = true;
    Response response = await orderRepo.setSubsOrderToAccepted(date);
    isLoading.value = false;
  }
}
