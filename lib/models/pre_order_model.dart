import 'package:kateringku_mobile/models/address_model.dart';
import 'package:kateringku_mobile/models/product_model.dart';

class PreOrderModel{
  AddressModel? addressModel;
  DateTime? deliveryDateTime;
  List<ProductModel>? orderProducts;
  int? deliveryPrice;
  int subTotalPrice = 0;
  int totalPrice = 0;

  PreOrderModel({this.addressModel, this.deliveryDateTime,
      this.orderProducts, this.deliveryPrice});

  void setSubTotalPrices(){
    subTotalPrice = 0;
    orderProducts!.forEach((element) {
      subTotalPrice += element.fixPrice() * element.orderQuantity;
    });
  }

  void setTotalPrice(){
    totalPrice = subTotalPrice + deliveryPrice!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressModel != null) {
      data['address'] = this.addressModel!.toJson();
    }
    data['delivery_price'] = this.deliveryPrice;
    data['total_price'] = this.totalPrice;
    data['delivery_date'] = this.deliveryDateTime!.toIso8601String();
    if (this.orderProducts != null) {
      data['products'] = this.orderProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}