import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/models/pre_order_detail_for_catering_model.dart';
import 'package:kateringku_mobile/models/subs_order_detail_for_catering_model.dart';

import '../data/repositories/order_repo.dart';

class CateringSubsOrderDetailController extends GetxController {
  final OrderRepo orderRepo;

  CateringSubsOrderDetailController({required this.orderRepo});

  var isLoading = true.obs;

  SubsOrderDetailForCateringModel? subsOrderDetailModel;

  Future<void> getOrderDetail(int id) async {
    isLoading.value = true;
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );

    Response response = await orderRepo.getCateringSubsOrderDetail(id);

    if (response.statusCode == 200) {
      subsOrderDetailModel =
          SubsOrderDetailForCateringModel.fromJson(response.body['order']);
    }

    EasyLoading.dismiss();
    isLoading.value = false;
  }

  Future<void> changeOrderStatus(String newStatus) async {
    isLoading.value = true;
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );

    Map<String, dynamic> data = {};

    data["orderId"] = subsOrderDetailModel!.id;
    data["newStatus"] = newStatus;

    Response response = await orderRepo.changeOrderStatusForCatering(data);

    await getOrderDetail(subsOrderDetailModel!.id!);

    EasyLoading.dismiss();
    isLoading.value = false;
  }

  Future<void> changeOrderStatusForOneDay(Map<String, dynamic> data) async {
    isLoading.value = true;
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );

    Response response =
        await orderRepo.changeOrderStatusOneDayForCatering(data);

    await getOrderDetail(subsOrderDetailModel!.id!);

    EasyLoading.dismiss();
    isLoading.value = false;
  }
}
