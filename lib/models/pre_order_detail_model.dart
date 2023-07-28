import 'dart:convert';

import 'package:kateringku_mobile/models/address_model.dart';

class PreOrderDetailModel {
  int? id;
  String? orderType;
  String? invoiceNumber;
  AddressModel? address;
  String? deliveryDatetime;
  List<OrderProduct>? products;
  int? subtotal;
  int? deliveryPrice;
  int? totalPrice;
  String? orderStatus;
  String? createdAt;
  String? cateringName;
  String? cateringPhone;
  String? cateringLocation;
  String? image;
  String? cateringId;
  String? paymentExpiry;
  int discount = 0;
  Review? review;
  Complaint? complaint;
  int useBalance = 0;

  PreOrderDetailModel(
      {this.id,
      this.orderType,
      this.invoiceNumber,
      this.address,
      this.deliveryDatetime,
      this.products,
      this.subtotal,
      this.deliveryPrice,
      this.totalPrice,
      this.orderStatus,
      this.createdAt});

  PreOrderDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderType = json['order_type'];
    invoiceNumber = json['invoice_number'];
    address =
        json['address'] != null ? AddressModel.fromJson(json['address']) : null;
    review = json['review'] != null ? Review.fromJson(json['review']) : null;
    complaint = json['complaint'] != null
        ? Complaint.fromJson(json['complaint'])
        : null;
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
    orderStatus = json['order_status'];
    createdAt = json['created_at'];
    cateringName = json['catering_name'];
    cateringPhone = json['catering_phone'];
    cateringLocation = json['catering_location'];
    useBalance = json["use_balance"] ?? 0;
    image = json['image'];
    cateringId = json['catering_id'].toString();
    paymentExpiry = json['payment_expiry'];
    if (json["discount"] != null) {
      Map<String, dynamic> discountDecode = jsonDecode(json["discount"]);
      discount = discountDecode["jumlah"];
    }
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
    data['order_status'] = this.orderStatus;
    data['created_at'] = this.createdAt;
    return data;
  }

  String orderTypeWording() {
    return orderType! == "preorder" ? "Pre Order" : "Berlangganan";
  }
}

class OrderProduct {
  int? id;
  String? name;
  int? quantity;
  int? price;
  String? image;
  String? productOptionSummary;

  OrderProduct(
      {this.id,
      this.name,
      this.quantity,
      this.price,
      this.image,
      this.productOptionSummary});

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
    image = json['image'];
    productOptionSummary = json['product_option_summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['original_path'] = this.image;
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

class Complaint {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? ordersId;
  String? status;
  String? problem;
  String? solutionType;
  List<Images>? images;

  Complaint(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.ordersId,
      this.status,
      this.problem,
      this.images});

  Complaint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    ordersId = json['orders_id'];
    solutionType = json['solution_type'];
    status = json['status'];
    problem = json['problem'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  String solutionWording() {
    if (solutionType == "refund") {
      return "Pengembalian Dana";
    } else {
      return "Pengiriman Ulang";
    }
  }

  String? problemWording() {
    if (problem == "damaged") {
      return "Makanan Rusak";
    } else if (problem == "not_received") {
      return "Tidak Sampai";
    } else if (problem == "incomplete") {
      return "Ada yang Kurang";
    }
  }

  String? statusWording() {
    if (status == "pending") {
      return "Sedang Ditinjau";
    } else if (status == "approve") {
      return "Komplain Diterima";
    } else if (problem == "reject") {
      return "Komplain Ditolak";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['orders_id'] = this.ordersId;
    data['status'] = this.status;
    data['problem'] = this.problem;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? complaintId;
  String? image;

  Images(
      {this.id, this.createdAt, this.updatedAt, this.complaintId, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    complaintId = json['complaint_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['complaint_id'] = this.complaintId;
    data['image'] = this.image;
    return data;
  }
}
