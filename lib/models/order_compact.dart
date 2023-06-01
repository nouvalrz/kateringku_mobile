import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../themes/app_theme.dart';

class OrderCompact {
  int? id;
  String? orderType;
  String? startDate;
  String? endDate;
  String? cateringName;
  String? orderStatus;
  int? orderQuantity;
  String? itemSummary;
  int? totalPrice;

  OrderCompact(
      {this.id,
      this.orderType,
      this.startDate,
      this.endDate,
      this.cateringName,
      this.orderQuantity,
      this.itemSummary,
      this.totalPrice});

  OrderCompact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderType = json['order_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    cateringName = json['catering_name'];
    orderQuantity = json['order_quantity'];
    itemSummary = json['item_summary'];
    totalPrice = json['total_price'];
    orderStatus = json['order_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_type'] = this.orderType;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['catering_name'] = this.cateringName;
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
      return "Diantar " +
          DateFormat('d MMMM', 'id').format(DateTime.parse(startDate!));
    } else {
      return "Diantar " +
          DateFormat('d MMMM', 'id').format(DateTime.parse(startDate!)) +
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
