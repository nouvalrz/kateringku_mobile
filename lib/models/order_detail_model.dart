import 'package:kateringku_mobile/models/address_model.dart';

class OrderDetailModel {
  int? id;
  String? orderType;
  String? invoiceNumber;
  AddressModel? address;
  String? deliveryDatetime;
  List<OrderProduct>? products;
  int? subtotal;
  int? deliveryPrice;
  int? totalPrice;
  String? paidStatus;
  String? orderStatus;
  String? createdAt;
  String? cateringName;
  String? cateringPhone;
  String? cateringLocation;
  String? cateringOriginalPath;
  String? cateringId;
  String? paymentExpiry;
  Review? review;

  OrderDetailModel(
      {this.id,
        this.orderType,
        this.invoiceNumber,
        this.address,
        this.deliveryDatetime,
        this.products,
        this.subtotal,
        this.deliveryPrice,
        this.totalPrice,
        this.paidStatus,
        this.orderStatus,
        this.createdAt});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderType = json['order_type'];
    invoiceNumber = json['invoice_number'];
    address =
    json['address'] != null ? AddressModel.fromJson(json['address']) : null;
    review = json['review'] != null ? Review.fromJson(json['review']) : null;
    deliveryDatetime = json['delivery_datetime'];
    if (json['products'] != null) {
      products = <OrderProduct>[];
      json['products'].forEach((v) {
        products!.add(OrderProduct.fromJson(v));
      });
    }
    subtotal = json['subtotal'];
    deliveryPrice = json['delivery_price'];
    totalPrice = json['total_price'];
    paidStatus = json['paid_status'];
    orderStatus = json['order_status'];
    createdAt = json['created_at'];
    cateringName = json['catering_name'];
    cateringPhone = json['catering_phone'];
    cateringLocation = json['catering_location'];
    cateringOriginalPath = json['catering_original_path'];
    cateringId = json['catering_id'].toString();
    paymentExpiry = json['payment_expiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['order_type'] = this.orderType;
    data['invoice_number'] = this.invoiceNumber;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['delivery_datetime'] = this.deliveryDatetime;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['subtotal'] = this.subtotal;
    data['delivery_price'] = this.deliveryPrice;
    data['total_price'] = this.totalPrice;
    data['paid_status'] = this.paidStatus;
    data['order_status'] = this.orderStatus;
    data['created_at'] = this.createdAt;
    return data;
  }
}


class OrderProduct {
  int? id;
  String? name;
  int? quantity;
  int? price;
  String? originalPath;
  String? productOptionSummary;

  OrderProduct(
      {this.id,
        this.name,
        this.quantity,
        this.price,
        this.originalPath,
        this.productOptionSummary});

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
    originalPath = json['original_path'];
    productOptionSummary = json['product_option_summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['original_path'] = this.originalPath;
    data['product_option_summary'] = this.productOptionSummary;
    return data;
  }
}

class Review {
  int? id;
  int? orderId;
  int? customerId;
  int? star;
  String? hasImage;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? cateringId;

  Review(
      {this.id,
        this.orderId,
        this.customerId,
        this.star,
        this.hasImage,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.cateringId});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    customerId = json['customer_id'];
    star = json['star'];
    hasImage = json['has_image'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cateringId = json['catering_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['customer_id'] = this.customerId;
    data['star'] = this.star;
    data['has_image'] = this.hasImage;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['catering_id'] = this.cateringId;
    return data;
  }
}