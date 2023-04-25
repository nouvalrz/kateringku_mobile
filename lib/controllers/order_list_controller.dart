import 'package:get/get.dart';
import 'package:kateringku_mobile/models/order_compact.dart';

import '../data/repositories/order_repo.dart';
import '../models/order_detail_model.dart';

class OrderListController extends GetxController{
  final OrderRepo orderRepo;

  OrderListController({required this.orderRepo});

  var isLoading = false.obs;

  var orders = <OrderCompact>[];

  var orderDetail = OrderDetailModel().obs;

  Future<void> getAllOrders() async{
    isLoading.value = true;

    orders = [];
    orders.clear();
    Response response = await orderRepo.getOrders();

    print("lenght " + response.body['orders'].length.toString());

    for(var j = 0 ; j < response.body['orders'].length ; j++){
      // if(response.body['orders'].length == orders.length){
      //   break;
      // }
      orders.add(OrderCompact.fromJson(response.body['orders'][j]));
    }

    // orders.refresh();
    // update();
    isLoading.value = false;
  }

  Future<void> getOrderDetail(int id) async{
    isLoading.value = true;

    Response response = await orderRepo.getOrderDetail(id);
    print("response" + response.toString());

    if(response.statusCode == 200){
      orderDetail.value = OrderDetailModel.fromJson(response.body['order']);
    }

    isLoading.value = false;
  }
}