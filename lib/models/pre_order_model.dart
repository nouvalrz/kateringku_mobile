import 'dart:convert';

import 'package:kateringku_mobile/models/address_model.dart';
import 'package:kateringku_mobile/models/catering_display_model.dart';
import 'package:kateringku_mobile/models/product_model.dart';

class PreOrderModel {
  AddressModel? addressModel;
  DateTime? deliveryDateTime;
  List<ProductModel>? orderProducts;
  int? deliveryPrice;
  int subTotalPrice = 0;
  int totalPrice = 0;
  int discount = 0;
  int useBalance = 0;
  int? discountId;
  String? discountName;
  int? discountPercentage;
  int? discountCateringId;
  String? cateringId;

  PreOrderModel(
      {this.addressModel,
      this.deliveryDateTime,
      this.orderProducts,
      this.deliveryPrice});

  void setSubTotalPrices() {
    subTotalPrice = 0;
    orderProducts!.forEach((element) {
      subTotalPrice += element.fixPrice() * element.orderQuantity;
    });
  }

  void setTotalPrice() {
    totalPrice = (subTotalPrice + deliveryPrice!) - discount - useBalance;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressModel != null) {
      data['address'] = this.addressModel!.toJson();
    }
    if (this.discount != 0) {
      Map<String, dynamic> discountData = {
        "nama": "${discountName!}",
        "persenan": discountPercentage!,
        "jumlah": discount,
        "catering_id": discountCateringId,
        "id": discountId
      };
      data["discount"] = json.encode(discountData);
    } else {
      data["discount"] = null;
    }
    if (this.useBalance != 0) {
      data["use_balance"] = this.useBalance;
    }
    data['catering_id'] = cateringId;
    data['delivery_price'] = this.deliveryPrice;
    data['total_price'] = (this.totalPrice + this.useBalance + this.discount) -
        this.deliveryPrice!;
    data['delivery_date'] = this.deliveryDateTime!.toIso8601String();
    if (this.orderProducts != null) {
      data['products'] = this.orderProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  void setDiscount({required Discount discountModel, bool reset = false}) {
    // discountId = discountModel.id;
    if (!reset) {
      var discountReducePrice =
          (subTotalPrice * (discountModel.percentage! / 100)).toInt();
      if (discountReducePrice > discountModel.maximumDisc!) {
        discount = discountModel.maximumDisc!;
      } else {
        discount = discountReducePrice;
      }
      discountName = discountModel.title;
      discountPercentage = discountModel.percentage;
      discountCateringId = discountModel.cateringId;
    } else {
      discount = 0;
      discountName = null;
      discountPercentage = null;
      discountCateringId = null;
    }
    setTotalPrice();
  }
}
