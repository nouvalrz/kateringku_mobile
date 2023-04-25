class AddCartBody{
  String catering_id;
  List<ProductForCart> product_list;

  AddCartBody({required this.catering_id, required this.product_list});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["catering_id"] = catering_id;
    data["products"] = this.product_list!.map((v) => v.toJson()).toList();
    return data;
  }

}

class ProductForCart{
  String product_id;
  int quantity;

  ProductForCart({required this.product_id, required this.quantity});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["product_id"] = product_id;
    data["quantity"] = quantity;
    return data;
  }
}