import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/models/order_compact.dart';

import '../data/repositories/order_repo.dart';
import '../models/pre_order_detail_model.dart';

class PreOrderDetailController extends GetxController {
  final OrderRepo orderRepo;

  PreOrderDetailController({required this.orderRepo});

  var isLoading = true.obs;

  var isSetOrderToAcceptedLoading = false.obs;

  var orderDetail = PreOrderDetailModel().obs;

  Future<void> getOrderDetail(int id) async {
    isLoading.value = true;
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );

    Response response = await orderRepo.getPreOrderDetail(id);

    if (response.statusCode == 200) {
      orderDetail.value = PreOrderDetailModel.fromJson(response.body['order']);
    }

    EasyLoading.dismiss();
    isLoading.value = false;
  }

  Future<void> setOrderToAccepted() async {
    isSetOrderToAcceptedLoading.value = true;
    Response response =
        await orderRepo.setOrderToAccepted(orderDetail.value.id!);

    isSetOrderToAcceptedLoading.value = false;
    isLoading.value = false;
  }

  Future<void> setOrderToRequestCancel() async {
    isLoading.value = true;
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );

    Response response =
        await orderRepo.setOrderToRequestCancel(orderDetail.value.id!);
    await getOrderDetail(orderDetail.value.id!);

    EasyLoading.dismiss();
    isLoading.value = false;
  }
}
