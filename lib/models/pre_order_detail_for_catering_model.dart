import 'dart:convert';

class PreOrderDetailForCateringModel {
  int? id;
  String? orderType;
  String? invoiceNumber;
  Address? address;
  String? deliveryDatetime;
  List<Products>? products;
  int? subtotal;
  int? deliveryPrice;
  int? totalPrice;
  String? paymentExpiry;
  int useBalance = 0;
  String? orderStatus;
  String? createdAt;
  Customer? customer;
  int? discount;
  Review? review;
  Complaint? complaint;

  PreOrderDetailForCateringModel(
      {this.id,
      this.orderType,
      this.invoiceNumber,
      this.address,
      this.deliveryDatetime,
      this.products,
      this.subtotal,
      this.deliveryPrice,
      this.totalPrice,
      this.paymentExpiry,
      this.orderStatus,
      this.createdAt,
      this.discount,
      this.customer});

  String orderTypeWording() {
    return orderType! == "preorder" ? "Pre Order" : "Berlangganan";
  }

  PreOrderDetailForCateringModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderType = json['order_type'];
    invoiceNumber = json['invoice_number'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    deliveryDatetime = json['delivery_datetime'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    subtotal = json['subtotal'];
    deliveryPrice = json['delivery_price'];
    totalPrice = json['total_price'];
    paymentExpiry = json['payment_expiry'];
    useBalance = json['use_balance'] ?? 0;
    orderStatus = json['order_status'];
    createdAt = json['created_at'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    review =
        json['review'] != null ? new Review.fromJson(json['review']) : null;
    complaint = json['complaint'] != null
        ? new Complaint.fromJson(json['complaint'])
        : null;

    if (json["discount"] != null) {
      Map<String, dynamic> discountDecode = jsonDecode(json["discount"]);
      var discount_string = discountDecode["jumlah"].toString();
      discount = int.parse(discount_string);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['payment_expiry'] = this.paymentExpiry;
    data['use_balance'] = this.useBalance;
    data['order_status'] = this.orderStatus;
    data['created_at'] = this.createdAt;
    data['discount'] = this.discount;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
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

class Products {
  int? id;
  String? name;
  int? quantity;
  int? price;
  String? image;
  String? productOptionSummary;

  Products(
      {this.id,
      this.name,
      this.quantity,
      this.price,
      this.image,
      this.productOptionSummary});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
    image = json['image'];
    productOptionSummary = json['product_option_summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['image'] = this.image;
    data['product_option_summary'] = this.productOptionSummary;
    return data;
  }
}

class Customer {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  int? points;
  String? phone;
  String? image;
  int? userId;
  int? balance;

  Customer(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.points,
      this.phone,
      this.image,
      this.userId,
      this.balance});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    points = json['points'];
    phone = json['phone'];
    image = json['image'];
    userId = json['user_id'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['points'] = this.points;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['user_id'] = this.userId;
    data['balance'] = this.balance;
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
    status = json['status'];
    problem = json['problem'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
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
