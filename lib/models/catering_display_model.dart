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
  int? imageId;
  String? isVerified;
  int? userId;
  int? totalSales;
  String? originalPath;
  double? rate;
  List<ProductModel>? recommendationProducts;
  Village? village;
  List<Categories>? categories;

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
      this.imageId,
      this.isVerified,
      this.userId,
      this.totalSales,
      this.originalPath,
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
    imageId = json['image_id'];
    isVerified = json['isVerified'];
    userId = json['user_id'];
    totalSales = json['total_sales'];
    originalPath = json['original_path'];
    rate = json['rate'] ?? null;
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
    data['image_id'] = this.imageId;
    data['isVerified'] = this.isVerified;
    data['user_id'] = this.userId;
    data['total_sales'] = this.totalSales;
    data['original_path'] = this.originalPath;
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
