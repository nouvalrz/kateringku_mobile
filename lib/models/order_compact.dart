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
  int useBalance = 0;
  int deliveryPrice = 0;
  int discount = 0;

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
    useBalance = json["use_balance"] ?? 0;
    deliveryPrice = json["delivery_cost"] ?? 0;
    discount = json["discount"] ?? 0;
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
      return DateFormat('d MMMM', 'id').format(DateTime.parse(startDate!));
    } else {
      return DateFormat('d MMMM', 'id').format(DateTime.parse(startDate!)) +
          " - " +
          DateFormat('d MMMM', 'id').format(DateTime.parse(endDate!));
    }
  }

  Container? getOrderStatusBadge() {
    if (orderStatus == "UNPAID") {
      return orderStatusBadge(
          text: "Belum Dibayar",
          bgColor: const Color(0xFFFFE6FD),
          textColor: const Color(0xff9d118f));
    } else if (orderStatus == "VOID") {
      return orderStatusBadge(
          text: "Pembayaran Kadaluarsa",
          bgColor: const Color(0xFFFFF1DB),
          textColor: const Color(0xffE49A2A));
    } else {
      if (orderStatus == "PAID") {
        return orderStatusBadge(
            text: "Menunggu Konfirmasi",
            bgColor: const Color(0xFFF5FFE0),
            textColor: const Color(0xff6a9316));
      } else if (orderStatus == "ACCEPTED") {
        return orderStatusBadge(
            text: "Pesanan Diterima",
            bgColor: const Color(0xFFE5F3FF),
            textColor: const Color(0xff2569A8));
      } else if (orderStatus == "NOT_APPROVED") {
        return orderStatusBadge(
            text: "Dibatalkan Katering",
            bgColor: const Color(0xFFFFEBEB),
            textColor: const Color(0xffD72E2E));
      } else if (orderStatus == "PROCESSED") {
        return orderStatusBadge(
            text: "Sedang Diproses",
            bgColor: const Color(0xFFE8EAFF),
            textColor: const Color(0xff2D3BBC));
      } else if (orderStatus == "SEND") {
        return orderStatusBadge(
            text: "Sedang Dikirim",
            bgColor: const Color(0xFFE6FFE2),
            textColor: const Color(0xff34A023));
      } else if (orderStatus == "ONGOING") {
        return orderStatusBadge(
            text: "Sedang Berlangsung",
            bgColor: const Color(0xFFE6FFE2),
            textColor: const Color(0xff34A023));
      } else if (orderStatus == "RECEIVED") {
        return orderStatusBadge(
            text: "Diterima",
            bgColor: const Color(0xFFE5F3FF),
            textColor: const Color(0xff2569A8));
      } else if (orderStatus == "COMPLAINT") {
        return orderStatusBadge(
            text: "Komplain",
            bgColor: const Color(0xFFFFEEEE),
            textColor: const Color(0xffC63939));
      } else if (orderStatus == "CANCEL_BY_SISTEM") {
        return orderStatusBadge(
            text: "Dibatalkan Otomatis",
            bgColor: const Color(0xFFFFEBEB),
            textColor: const Color(0xffD72E2E));
      } else if (orderStatus == "REQUEST_CANCEL") {
        return orderStatusBadge(
            text: "Pengajuan Cancel",
            bgColor: const Color(0xFFFFEBEB),
            textColor: const Color(0xffD72E2E));
      } else if (orderStatus == "APPROVED_CANCEL") {
        return orderStatusBadge(
            text: "Pembatalan Disetujui",
            bgColor: const Color(0xFFFFEBEB),
            textColor: const Color(0xffD72E2E));
      } else if (orderStatus == "CANCEL_REJECTED") {
        return orderStatusBadge(
            text: "Pembatalan Gagal",
            bgColor: const Color(0xFFFFEBEB),
            textColor: const Color(0xffD72E2E));
      } else if (orderStatus == "PENDING") {
        return orderStatusBadge(
            text: "Pending",
            bgColor: const Color(0xFFFFEBEB),
            textColor: const Color(0xffD72E2E));
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
