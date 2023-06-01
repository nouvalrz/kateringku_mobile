import 'package:get/get.dart';

class ProductModel {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? cateringId;
  String? name;
  String? description;
  int? weight;
  int price = 0;
  int? minimumQuantity;
  int? maximumQuantity;
  int? isFreeDelivery;
  int? isHidden;
  int? isAvailable;
  String? isCustomable;
  int? totalSales;
  String? image;
  List<ProductOption>? productOptions;
  int orderQuantity = 0;
  int additionalPrice = 0;
  String productOptionSummary = "";

  ProductModel(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.cateringId,
      this.name,
      this.description,
      this.weight,
      required this.price,
      this.minimumQuantity,
      this.maximumQuantity,
      this.isFreeDelivery,
      this.isHidden,
      this.isAvailable,
      this.isCustomable,
      this.totalSales,
      this.image,
      this.productOptions,
      this.productOptionSummary = "",
      this.orderQuantity = 0,
      this.additionalPrice = 0});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cateringId = json['catering_id'];
    name = json['name'];
    description = json['description'];
    weight = json['weight'];
    price = json['price'];
    minimumQuantity = json['minimum_quantity'];
    maximumQuantity = json['maximum_quantity'];
    isFreeDelivery = json['is_free_delivery'];
    isHidden = json['is_hidden'];
    isAvailable = json['is_available'];
    isCustomable = json['is_customable'];
    totalSales = json['total_sales'];
    image = json['image'];
    if (json['product_options'] != null) {
      productOptions = <ProductOption>[];
      json['product_options'].forEach((v) {
        productOptions!.add(new ProductOption.fromJson(v));
      });
    }

    void setProductOptionSummary() {
      var choices = <String>[];
      productOptions!.forEach((productOption) {
        productOption.productOptionDetails!.forEach((productOptionDetail) {
          if (productOptionDetail.isSelected) {
            choices.add(productOptionDetail.optionChoiceName!);
          }
        });
      });
      productOptionSummary = choices.join(", ");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.fixPrice();
    data['quantity'] = this.orderQuantity;
    if (this.productOptions != null) {
      List<ProductOption> productOptionsTemp = [];
      productOptions!.forEach((element) {
        if (element.selectedOption > 0) {
          productOptionsTemp.add(element);
        }
      });
      // data['product_options'] =
      //     this.productOptions!.map((v) => v.toJson()).toList();
      data['product_options'] = productOptionsTemp.toList();
    }
    return data;
  }

  bool isProductCustomable() {
    return productOptions!.isNotEmpty;
  }

  void addQuantity({int quantity = 0, bool fromCart = false}) {
    if (minimumQuantity! >= 1 && orderQuantity == 0 && !fromCart) {
      orderQuantity = minimumQuantity!;
      return;
    }
    if (quantity != 0) {
      orderQuantity += quantity!;
      return;
    } else {
      orderQuantity += 1;
    }
  }

  void subtractQuantity() {
    if (orderQuantity == 0) {
      return;
    }
    if (orderQuantity <= minimumQuantity!) {
      orderQuantity = 0;
      return;
    }
    orderQuantity -= 1;
  }

  int fixPrice() {
    return price + additionalPrice;
  }

  bool isAllOptionFulfilled() {
    var falseTotal = 0;
    productOptions!.forEach((productOption) {
      if (!productOption.isOptionChoiceFulfilled()) {
        falseTotal += 1;
      }
    });
    if (falseTotal > 0) {
      return false;
    } else {
      return true;
    }
  }

  void setProductOptionSummary() {
    productOptionSummary = "";
    var productOptionChoice = <String>[];

    productOptions!.forEach((productOption) {
      productOption.productOptionDetails!.forEach((productOptionDetail) {
        if (productOptionDetail.isSelected) {
          productOptionChoice.add(productOptionDetail.optionChoiceName!);
        }
      });
    });

    productOptionSummary = productOptionChoice.join(", ");
  }
}

class ProductOption {
  int? id;
  String? optionName;
  String? optionType;
  int? maximumSelection;
  int? minimumSelection;
  String? isActive;
  int? productId;
  int selectedOption = 0;
  List<ProductOptionDetail>? productOptionDetails;

  ProductOption(
      {this.id,
      this.optionName,
      this.optionType,
      this.maximumSelection,
      this.isActive,
      this.productId,
      this.productOptionDetails,
      this.minimumSelection});

  ProductOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    optionName = json['option_name'];
    optionType = json['option_type'];
    maximumSelection = json['maximum_selection'];
    minimumSelection = json['minimum_selection'];
    isActive = json['is_active'].toString();
    productId = json['product_id'];
    if (json['product_option_details'] != null) {
      productOptionDetails = <ProductOptionDetail>[];
      json['product_option_details'].forEach((v) {
        productOptionDetails!.add(new ProductOptionDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    // if (this.productOptionDetails != null) {
    //   data['product_option_details'] =
    //       this.productOptionDetails!.map((v) => v.toJson()).toList();
    // }
    if (this.productOptionDetails != null) {
      List<ProductOptionDetail> productOptionDetailsTemp = [];
      productOptionDetails!.forEach((element) {
        if (element.isSelected) {
          productOptionDetailsTemp.add(element);
        }
      });
      // data['product_options'] =
      //     this.productOptions!.map((v) => v.toJson()).toList();
      data['product_option_details'] = productOptionDetailsTemp.toList();
    }
    return data;
  }

  String termsWording() {
    var termType = "";
    if (minimumSelection == 0) {
      termType = "Opsional";
    } else {
      termType = "Wajib";
    }
    return "${termType} | Pilih maks. ${maximumSelection}";
  }

  void clearSelection() {
    productOptionDetails!.forEach((productOptionDetail) {
      productOptionDetail.isSelected = false;
    });
  }

  bool isOptionMax() {
    var totalSelected = 0;
    productOptionDetails!.forEach((productOptionDetail) {
      if (productOptionDetail.isSelected) {
        totalSelected += 1;
      }
    });
    return totalSelected >= maximumSelection!;
  }

  bool isOptionChoiceFulfilled() {
    if (minimumSelection == 0) {
      return true;
    } else {
      var totalSelected = 0;
      productOptionDetails!.forEach((productOptionDetail) {
        if (productOptionDetail.isSelected) {
          totalSelected += 1;
        }
      });
      if (totalSelected > 0) {
        return true;
      } else {
        return false;
      }
    }
  }
}

class ProductOptionDetail {
  int? id;
  int? productOptionId;
  String? optionChoiceName;
  int? addtionalPrice;
  String? isAvailable;
  bool isSelected = false;

  ProductOptionDetail({
    this.id,
    this.productOptionId,
    this.optionChoiceName,
    this.addtionalPrice,
    this.isAvailable,
  });

  ProductOptionDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productOptionId = json['product_option_id'];
    optionChoiceName = json['option_choice_name'];
    addtionalPrice = json['additional_price'];
    isAvailable = json['is_available'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }

  void activateOption() {
    this.isSelected = true;
  }

  void deactivateOption() {
    this.isSelected = false;
  }
}
