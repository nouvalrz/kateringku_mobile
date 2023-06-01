import 'package:kateringku_mobile/models/product_model.dart';

class CateringDisplayModel {
  int? id;
  String? name;
  String? email;
  String? description;
  String? phone;
  String? address;
  int? villageId;
  int? zipcode;
  String? latitude;
  String? longitude;
  String? deliveryStartTime;
  String? deliveryEndTime;
  int? discountsCount;
  // int? imageId;
  String? isVerified;
  int? deliveryCost;
  int? minDistanceDelivery;
  int? userId;
  int? totalSales;
  String? image;
  double? rate;
  List<ProductModel>? recommendationProducts;
  Village? village;
  List<Categories>? categories;
  List<Discount>? discounts;

  CateringDisplayModel(
      {this.id,
      this.name,
      this.email,
      this.description,
      this.phone,
      this.address,
      this.villageId,
      this.zipcode,
      this.latitude,
      this.longitude,
      this.deliveryStartTime,
      this.deliveryEndTime,
      this.isVerified,
      this.userId,
      this.totalSales,
      this.image,
      this.recommendationProducts,
      this.village,
      this.categories});

  CateringDisplayModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    description = json['description'];
    phone = json['phone'];
    address = json['address'];
    villageId = json['village_id'];
    zipcode = json['zipcode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deliveryStartTime = json['delivery_start_time'];
    deliveryEndTime = json['delivery_end_time'];
    deliveryCost = json["delivery_cost"];
    minDistanceDelivery = json["min_distance_delivery"];
    isVerified = json['isVerified'];
    userId = json['user_id'];
    totalSales = json['total_sales'];
    discountsCount = json['discounts_count'];
    image = json['image'];
    if (json['discounts'] != null) {
      discounts = <Discount>[];
      json['discounts'].forEach((v) {
        discounts!.add(new Discount.fromJson(v));
      });
    }
    rate = json['rate'] != null ? double.parse("${json['rate']}") : null;
    if (json['recommendation_products'] != null) {
      recommendationProducts = <ProductModel>[];
      json['recommendation_products'].forEach((v) {
        recommendationProducts!.add(new ProductModel.fromJson(v));
      });
    }
    village =
        json['village'] != null ? new Village.fromJson(json['village']) : null;
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['description'] = this.description;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['village_id'] = this.villageId;
    data['zipcode'] = this.zipcode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['delivery_start_time'] = this.deliveryStartTime;
    data['delivery_end_time'] = this.deliveryEndTime;
    data['isVerified'] = this.isVerified;
    data['user_id'] = this.userId;
    data['total_sales'] = this.totalSales;
    data['original_path'] = this.image;
    if (this.recommendationProducts != null) {
      data['recommendation_products'] =
          this.recommendationProducts!.map((v) => v.toJson()).toList();
    }
    if (this.village != null) {
      data['village'] = this.village!.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String mergeCategories() {
    List merged = [];
    categories!.forEach((category) {
      merged.add(category.name);
    });
    return merged.join(", ");
  }
}

class Village {
  int? id;
  int? districtId;
  String? name;
  District? district;

  Village({this.id, this.districtId, this.name, this.district});

  Village.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    districtId = json['district_id'];
    name = json['name'];
    district = json['district'] != null
        ? new District.fromJson(json['district'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['district_id'] = this.districtId;
    data['name'] = this.name;
    if (this.district != null) {
      data['district'] = this.district!.toJson();
    }
    return data;
  }
}

class District {
  int? id;
  int? regencyId;
  String? name;

  District({this.id, this.regencyId, this.name});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    regencyId = json['regency_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['regency_id'] = this.regencyId;
    data['name'] = this.name;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? description;

  Categories({this.id, this.name, this.description});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}

class Discount {
  int? id;
  int? cateringId;
  String? title;
  String? description;
  int? minimumSpend;
  int? maximumDisc;
  String? startDate;
  String? endDate;
  int? percentage;

  Discount(
      {this.id,
      this.cateringId,
      this.title,
      this.description,
      this.minimumSpend,
      this.maximumDisc,
      this.startDate,
      this.endDate});

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cateringId = json['catering_id'];
    title = json['title'];
    description = json['description'];
    minimumSpend = json['minimum_spend'];
    maximumDisc = json['maximum_disc'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['catering_id'] = this.cateringId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['minimum_spend'] = this.minimumSpend;
    data['maximum_disc'] = this.maximumDisc;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}
