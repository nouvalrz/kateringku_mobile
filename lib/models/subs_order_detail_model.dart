import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class SubsOrderDetailModel {
  int? id;
  String? cateringName;
  String? cateringPhone;
  String? cateringLocation;
  String? image;
  int? cateringId;
  String? orderType;
  String? invoiceNumber;
  Address? address;
  String? startDate;
  String? endDate;
  int? subtotal;
  int? deliveryPrice;
  int? totalPrice;
  String? paymentExpiry;
  String? orderStatus;
  String? createdAt;
  int useBalance = 0;

  int discount = 0;
  List<Orders>? orders;
  Review? review;

  SubsOrderDetailModel(
      {this.id,
      this.cateringName,
      this.cateringPhone,
      this.cateringLocation,
      this.image,
      this.cateringId,
      this.orderType,
      this.invoiceNumber,
      this.address,
      this.startDate,
      this.endDate,
      this.subtotal,
      this.deliveryPrice,
      this.totalPrice,
      this.paymentExpiry,
      this.orderStatus,
      this.createdAt,
      this.orders});

  SubsOrderDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cateringName = json['catering_name'];
    cateringPhone = json['catering_phone'];
    cateringLocation = json['catering_location'];
    image = json['image'];
    cateringId = json['catering_id'];
    orderType = json['order_type'];
    invoiceNumber = json['invoice_number'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    startDate = json['start_date'];
    endDate = json['end_date'];
    useBalance = json['use_balance'] ?? 0;
    subtotal = json['subtotal'];
    deliveryPrice = json['delivery_price'];
    totalPrice = json['total_price'];
    paymentExpiry = json['payment_expiry'];
    orderStatus = json['order_status'];
    createdAt = json['created_at'];
    if (json["discount"] != null) {
      Map<String, dynamic> discountDecode = jsonDecode(json["discount"]);
      discount = discountDecode["jumlah"];
    }
    review = json['review'] != null ? Review.fromJson(json['review']) : null;
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['catering_name'] = this.cateringName;
    data['catering_phone'] = this.cateringPhone;
    data['catering_location'] = this.cateringLocation;
    data['image'] = this.image;
    data['catering_id'] = this.cateringId;
    data['order_type'] = this.orderType;
    data['invoice_number'] = this.invoiceNumber;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['subtotal'] = this.subtotal;
    data['delivery_price'] = this.deliveryPrice;
    data['total_price'] = this.totalPrice;
    data['payment_expiry'] = this.paymentExpiry;
    data['order_status'] = this.orderStatus;
    data['created_at'] = this.createdAt;
    data['discount'] = this.discount;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String orderTypeWording() {
    return orderType! == "preorder" ? "Pre Order" : "Berlangganan";
  }

  String getDateRangeWording() {
    initializeDateFormatting('id');
    var firstDate = DateTime.parse(startDate!);
    var lastDate = DateTime.parse(endDate!);
    if (firstDate.month == lastDate.month) {
      return "${firstDate.day} - ${DateFormat.MMMMd('id').format(lastDate)}";
    } else {
      return "${DateFormat.MMMMd('id').format(firstDate)} - ${DateFormat.MMMMd('id').format(lastDate)}";
    }
  }
}

class Address {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? customerId;
  String? recipientName;
  String? address;
  String? latitude;
  String? longitude;
  String? phone;

  Address(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.customerId,
      this.recipientName,
      this.address,
      this.latitude,
      this.longitude,
      this.phone});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customerId = json['customer_id'];
    recipientName = json['recipient_name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['customer_id'] = this.customerId;
    data['recipient_name'] = this.recipientName;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['phone'] = this.phone;
    return data;
  }
}

class Orders {
  String? deliveryDatetime;
  int? subtotalPrice;
  Complaint? complaint;
  String? status;
  List<Products>? products;

  Orders({this.deliveryDatetime, this.products});

  Orders.fromJson(Map<String, dynamic> json) {
    subtotalPrice = json["subtotal_price"];
    status = json["status"];
    deliveryDatetime = json['delivery_datetime'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    complaint = json['complaint'] != null
        ? Complaint.fromJson(json['complaint'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivery_datetime'] = this.deliveryDatetime;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String statusWording() {
    if (status! == "pending") {
      return "Diproses";
    } else if (status! == "sending") {
      return "Sedang Diantar";
    } else if (status! == "delivered") {
      return "Telah Diterima";
    } else if (status! == "complaint") {
      return "Komplain";
    } else {
      return "";
    }
  }
}

class Products {
  int? id;
  String? name;
  int? quantity;
  int? price;
  String? customDesc;
  String? image;

  Products(
      {this.id,
      this.name,
      this.quantity,
      this.price,
      this.customDesc,
      this.image});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
    customDesc = json['custom_desc'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['custom_desc'] = this.customDesc;
    data['image'] = this.image;
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
