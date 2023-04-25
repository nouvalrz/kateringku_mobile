import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/models/order_compact.dart';

import '../data/repositories/order_repo.dart';
import '../models/order_detail_model.dart';

class OrderDetailController extends GetxController{
  final OrderRepo orderRepo;

  OrderDetailController({required this.orderRepo});

  var isLoading = true.obs;

  var isSetOrderToAcceptedLoading = false.obs;

  var orderDetail = OrderDetailModel().obs;


  Future<void> getOrderDetail(int id) async{
    isLoading.value = true;
    EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.black,);

    Response response = await orderRepo.getOrderDetail(id);

    if(response.statusCode == 200){
      orderDetail.value = OrderDetailModel.fromJson(response.body['order']);
    }

    EasyLoading.dismiss();
    isLoading.value = false;
  }

  Future<void> setOrderToAccepted() async{
    isSetOrderToAcceptedLoading.value = true;
    Response response = await orderRepo.setOrderToAccepted(orderDetail.value.id!);

    isLoading.value = false;
  }
}