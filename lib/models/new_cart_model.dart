import 'catering_display_model.dart';

class NewCartModel {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? customerId;
  String? orderType;
  int? cateringId;
  String? cateringName;
  Catering? catering;
  List<CartDetails>? cartDetails;

  NewCartModel(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.customerId,
        this.orderType,
        this.cateringId,
        this.cartDetails});

  NewCartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customerId = json['customer_id'];
    orderType = json['order_type'];
    cateringName = json['catering']['name'];
    cateringId = json['catering_id'];
    catering = Catering.fromJson(json['catering']);
    if (json['cart_details'] != null) {
      cartDetails = <CartDetails>[];
      json['cart_details'].forEach((v) {
        cartDetails!.add(new CartDetails.fromJson(v));
      });
    }
  }

  int totalPrice(){
    var totalPrice = 0;
    cartDetails!.forEach((element) {
      totalPrice += element.fixPrice();
    });
    return totalPrice;
  }

  int totalQuantity(){
    var totalQuantity = 0;
    cartDetails!.forEach((element) {
      totalQuantity += element.quantity!;
    });
    return totalQuantity;
  }
}

class Catering {
  int? id;
  String? updatedAt;
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
  Village? village;
  List<Categories>? categories;

  Catering(
      {this.id,
        this.updatedAt,
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
        this.originalPath});

  Catering.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    updatedAt = json['updated_at'];
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
    village = new Village.fromJson(json['village']);
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
    data['updated_at'] = this.updatedAt;
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
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String mergeCategories(){
    List merged = [];
    categories!.forEach((category) {
      merged.add(category.name);
    });
    return merged.join(", ");
  }

}


class CartDetails {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? cartId;
  int? productId;
  int? quantity;
  Product? product;
  List<ProductOptions>? productOptions;

  CartDetails(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.cartId,
        this.productId,
        this.quantity,
        this.product,
        this.productOptions});

  CartDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cartId = json['cart_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    if (json['product_options'] != null) {
      productOptions = <ProductOptions>[];
      json['product_options'].forEach((v) {
        productOptions!.add(new ProductOptions.fromJson(v));
      });
    }
  }

  String concatProductOptions(){
    if(productOptions!.isEmpty || productOptions! == null){
      return "";
    }else{
      var productOptionSummary = [];
      productOptions!.forEach((element) {
        productOptionSummary.add(element.optionChoice!.optionChoiceName);
      });
      return productOptionSummary.join(", ");
    }
  }

  int fixPrice(){
    var additionalPrice = 0;
    if(productOptions!.isEmpty || productOptions! == null){
      return product!.price! * quantity!;
    }else{
      productOptions!.forEach((element) {
        additionalPrice += element.optionChoice!.addtionalPrice!;
      });
      return (additionalPrice + product!.price!) * quantity!;
    }
  }
}

class Product {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? cateringId;
  String? name;
  // String? description;
  // int? weight;
  int? price;
  // int? minimumQuantity;
  // int? maximumQuantity;
  // int? isFreeDelivery;
  // int? isHidden;
  // int? isAvailable;
  // int? imageId;
  // String? isCustomable;
  // int? totalSales;
  // String? originalPath;

  Product(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.cateringId,
        this.name,
        // this.description,
        // this.weight,
        this.price,});
        // this.minimumQuantity,
        // this.maximumQuantity,
        // this.isFreeDelivery,
        // this.isHidden,
        // this.isAvailable,
        // this.imageId,
        // this.isCustomable,
        // this.totalSales,
        // this.originalPath});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cateringId = json['catering_id'];
    name = json['name'];
    // description = json['description'];
    // weight = json['weight'];
    price = json['price'];
    // minimumQuantity = json['minimum_quantity'];
    // maximumQuantity = json['maximum_quantity'];
    // isFreeDelivery = json['is_free_delivery'];
    // isHidden = json['is_hidden'];
    // isAvailable = json['is_available'];
    // imageId = json['image_id'];
    // isCustomable = json['is_customable'];
    // totalSales = json['total_sales'];
    // originalPath = json['original_path'];
  }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['created_at'] = this.createdAt;
  //   data['updated_at'] = this.updatedAt;
  //   data['catering_id'] = this.cateringId;
  //   data['name'] = this.name;
  //   data['description'] = this.description;
  //   data['weight'] = this.weight;
  //   data['price'] = this.price;
  //   data['minimum_quantity'] = this.minimumQuantity;
  //   data['maximum_quantity'] = this.maximumQuantity;
  //   data['is_free_delivery'] = this.isFreeDelivery;
  //   data['is_hidden'] = this.isHidden;
  //   data['is_available'] = this.isAvailable;
  //   data['image_id'] = this.imageId;
  //   data['is_customable'] = this.isCustomable;
  //   data['total_sales'] = this.totalSales;
  //   data['original_path'] = this.originalPath;
  //   return data;
  // }
}

class ProductOptions {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? cartDetailId;
  int? productOptionId;
  int? productOptionDetailId;
  OptionChoice? optionChoice;

  ProductOptions(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.cartDetailId,
        this.productOptionId,
        this.productOptionDetailId,
        this.optionChoice});

  ProductOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cartDetailId = json['cart_detail_id'];
    productOptionId = json['product_option_id'];
    productOptionDetailId = json['product_option_detail_id'];
    optionChoice = json['option_choice'] != null
        ? new OptionChoice.fromJson(json['option_choice'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['cart_detail_id'] = this.cartDetailId;
    data['product_option_id'] = this.productOptionId;
    data['product_option_detail_id'] = this.productOptionDetailId;
    if (this.optionChoice != null) {
      data['option_choice'] = this.optionChoice!.toJson();
    }
    return data;
  }
}

class OptionChoice {
  int? id;
  Null? createdAt;
  Null? updatedAt;
  int? productOptionId;
  String? optionChoiceName;
  int? addtionalPrice;
  String? isAvailable;

  OptionChoice(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.productOptionId,
        this.optionChoiceName,
        this.addtionalPrice,
        this.isAvailable});

  OptionChoice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productOptionId = json['product_option_id'];
    optionChoiceName = json['option_choice_name'];
    addtionalPrice = json['addtional_price'];
    isAvailable = json['is_available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product_option_id'] = this.productOptionId;
    data['option_choice_name'] = this.optionChoiceName;
    data['addtional_price'] = this.addtionalPrice;
    data['is_available'] = this.isAvailable;
    return data;
  }
}
