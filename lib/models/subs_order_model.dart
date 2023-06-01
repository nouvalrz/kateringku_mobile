import 'package:kateringku_mobile/models/product_model.dart';

class SubsOrderModel {
  List<ProductModel> orderProducts = [];
  int totalPrice = 0;
  int totalQuantity = 0;
  DateTime? deliveryDateTime;

  void setTotalPrices() {
    totalPrice = 0;
    orderProducts!.forEach((element) {
      totalPrice += element.fixPrice() * element.orderQuantity;
    });
  }

  void setTotalQuantity() {
    totalQuantity = 0;
    orderProducts!.forEach((element) {
      totalQuantity += element.orderQuantity;
    });
  }

  void changeTime({required DateTime newTime}) {
    deliveryDateTime = DateTime(
        deliveryDateTime!.year,
        deliveryDateTime!.month,
        deliveryDateTime!.day,
        newTime.hour,
        newTime.minute,
        deliveryDateTime!.second,
        deliveryDateTime!.millisecond,
        deliveryDateTime!.microsecond);
  }

  ProductModel getProductById(int id) {
    return orderProducts.firstWhere((element) => element.id == id);
  }
}
