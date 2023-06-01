class CateringReviewModel {
  double? rate;
  List<Reviews>? reviews;
  List<RateCount>? rateCount;

  CateringReviewModel({this.rate, this.reviews, this.rateCount});

  CateringReviewModel.fromJson(Map<String, dynamic> json) {
    rate = json['rate'] != null ? double.parse("${json['rate']}") : null;
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
    if (json['rate_count'] != null) {
      rateCount = <RateCount>[];
      json['rate_count'].forEach((v) {
        rateCount!.add(new RateCount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    if (this.rateCount != null) {
      data['rate_count'] = this.rateCount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  int? id;
  int? orderId;
  int? customerId;
  int? star;
  String? hasImage;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? cateringId;
  Customer? customer;

  Reviews(
      {this.id,
      this.orderId,
      this.customerId,
      this.star,
      this.hasImage,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.cateringId,
      this.customer});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    customerId = json['customer_id'];
    star = json['star'];
    hasImage = json['has_image'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cateringId = json['catering_id'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['customer_id'] = this.customerId;
    data['star'] = this.star;
    data['has_image'] = this.hasImage;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['catering_id'] = this.cateringId;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? gender;
  int? balance;
  int? points;
  String? phone;
  int? userId;
  User? user;

  Customer(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.gender,
      this.balance,
      this.points,
      this.phone,
      this.userId,
      this.user});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    gender = json['gender'];
    balance = json['balance'];
    points = json['points'];
    phone = json['phone'];
    userId = json['user_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['gender'] = this.gender;
    data['balance'] = this.balance;
    data['points'] = this.points;
    data['phone'] = this.phone;
    data['user_id'] = this.userId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;

  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class RateCount {
  int? star;
  int? total;

  RateCount({this.star, this.total});

  RateCount.fromJson(Map<String, dynamic> json) {
    star = json['star'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['star'] = this.star;
    data['total'] = this.total;
    return data;
  }
}
