import 'package:flutter/cupertino.dart';

import '../themes/app_theme.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CateringDashboardModel {
  Catering? catering;
  List<Orders>? orders;

  CateringDashboardModel({this.catering, this.orders});

  CateringDashboardModel.fromJson(Map<String, dynamic> json) {
    catering = json['catering'] != null
        ? new Catering.fromJson(json['catering'])
        : null;
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.catering != null) {
      data['catering'] = this.catering!.toJson();
    }
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Catering {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? email;
  String? description;
  String? phone;
  String? address;
  int? balance;
  Null? provinceId;
  Null? regencyId;
  Null? districtId;
  int? villageId;
  int? zipcode;
  String? latitude;
  String? longitude;
  String? deliveryStartTime;
  String? deliveryEndTime;
  String? image;
  String? isVerified;
  int? userId;
  int? totalSales;
  String? workday;
  int? deliveryCost;
  int? minDistanceDelivery;
  int? rate;
  Null? isOpen;

  Catering(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.email,
      this.description,
      this.phone,
      this.address,
      this.balance,
      this.provinceId,
      this.regencyId,
      this.districtId,
      this.villageId,
      this.zipcode,
      this.latitude,
      this.longitude,
      this.deliveryStartTime,
      this.deliveryEndTime,
      this.image,
      this.isVerified,
      this.userId,
      this.totalSales,
      this.workday,
      this.deliveryCost,
      this.minDistanceDelivery,
      this.rate,
      this.isOpen});

  Catering.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    email = json['email'];
    description = json['description'];
    phone = json['phone'];
    address = json['address'];
    balance = json['balance'];
    provinceId = json['province_id'];
    regencyId = json['regency_id'];
    districtId = json['district_id'];
    villageId = json['village_id'];
    zipcode = json['zipcode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deliveryStartTime = json['delivery_start_time'];
    deliveryEndTime = json['delivery_end_time'];
    image = json['image'];
    isVerified = json['isVerified'];
    userId = json['user_id'];
    totalSales = json['total_sales'];
    workday = json['workday'];
    deliveryCost = json['delivery_cost'];
    minDistanceDelivery = json['min_distance_delivery'];
    rate = json['rate'];
    isOpen = json['is_open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['email'] = this.email;
    data['description'] = this.description;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['balance'] = this.balance;
    data['province_id'] = this.provinceId;
    data['regency_id'] = this.regencyId;
    data['district_id'] = this.districtId;
    data['village_id'] = this.villageId;
    data['zipcode'] = this.zipcode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['delivery_start_time'] = this.deliveryStartTime;
    data['delivery_end_time'] = this.deliveryEndTime;
    data['image'] = this.image;
    data['isVerified'] = this.isVerified;
    data['user_id'] = this.userId;
    data['total_sales'] = this.totalSales;
    data['workday'] = this.workday;
    data['delivery_cost'] = this.deliveryCost;
    data['min_distance_delivery'] = this.minDistanceDelivery;
    data['rate'] = this.rate;
    data['is_open'] = this.isOpen;
    return data;
  }
}

class Orders {
  int? id;
  String? orderType;
  String? startDate;
  String? endDate;
  String? orderStatus;
  int useBalance = 0;
  int? orderQuantity;
  String? itemSummary;
  int? totalPrice;

  Orders(
      {this.id,
      this.orderType,
      this.startDate,
      this.endDate,
      this.orderStatus,
      this.orderQuantity,
      this.itemSummary,
      this.totalPrice});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderType = json['order_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    orderStatus = json['order_status'];
    useBalance = json['use_balance'] ?? 0;
    orderQuantity = json['order_quantity'];
    itemSummary = json['item_summary'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_type'] = this.orderType;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['order_status'] = this.orderStatus;
    data['use_balance'] = this.useBalance;
    data['order_quantity'] = this.orderQuantity;
    data['item_summary'] = this.itemSummary;
    data['total_price'] = this.totalPrice;
    return data;
  }

  String orderTypeWording() {
    if (isPreOrder()) {
      return "Pre Order";
    } else {
      return "Berlangganan";
    }
  }

  bool isPreOrder() {
    return orderType == "preorder";
  }

  String deliveryDateWording() {
    initializeDateFormatting('id');
    if (isPreOrder()) {
      return DateFormat('d MMMM', 'id').format(DateTime.parse(startDate!));
    } else {
      return DateFormat('d MMMM', 'id').format(DateTime.parse(startDate!)) +
          " - " +
          DateFormat('d MMMM', 'id').format(DateTime.parse(endDate!));
    }
  }

  Container? getOrderStatusBadge() {
    if (orderStatus == "UNPAID" || orderStatus == "PENDING") {
      return orderStatusBadge(
          text: "Belum Dibayar",
          bgColor: Color(0xFFFFE6FD),
          textColor: Color(0xff9d118f));
    } else if (orderStatus == "VOID") {
      return orderStatusBadge(
          text: "Pembayaran Kadaluarsa",
          bgColor: Color(0xFFFFF1DB),
          textColor: Color(0xffE49A2A));
    } else {
      if (orderStatus == "PAID") {
        return orderStatusBadge(
            text: "Menunggu Konfirmasi",
            bgColor: Color(0xFFF5FFE0),
            textColor: Color(0xff6a9316));
      } else if (orderStatus == "NOT_APPROVED") {
        return orderStatusBadge(
            text: "Dibatalkan Katering",
            bgColor: Color(0xFFFFEBEB),
            textColor: Color(0xffD72E2E));
      } else if (orderStatus == "PROCESSED") {
        return orderStatusBadge(
            text: "Diproses",
            bgColor: Color(0xFFE8EAFF),
            textColor: Color(0xff2D3BBC));
      } else if (orderStatus == "SEND") {
        return orderStatusBadge(
            text: "Sedang Dikirim",
            bgColor: Color(0xFFE6FFE2),
            textColor: Color(0xff34A023));
      } else if (orderStatus == "ONGOING") {
        return orderStatusBadge(
            text: "Sedang Berlangsung",
            bgColor: Color(0xFFE6FFE2),
            textColor: Color(0xff34A023));
      } else if (orderStatus == "ACCEPTED") {
        return orderStatusBadge(
            text: "Diterima",
            bgColor: Color(0xFFE5F3FF),
            textColor: Color(0xff2569A8));
      } else if (orderStatus == "COMPLAINT") {
        return orderStatusBadge(
            text: "Komplain",
            bgColor: Color(0xFFFFEEEE),
            textColor: Color(0xffC63939));
      }
    }
  }

  Container orderStatusBadge(
      {required String text,
      required Color bgColor,
      required Color textColor}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Text(
          text,
          style: AppTheme.textTheme.titleLarge!.copyWith(
              fontSize: 10, fontWeight: FontWeight.w600, color: textColor),
        ),
      ),
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(3)),
    );
  }
}
