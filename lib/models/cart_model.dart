class CartModel {
  int id;
  int customerId;
  String orderType;
  String cateringName;
  List<Product> products;

  CartModel(
      { required this.id,
        required this.customerId,
        required this.orderType,
        required this.cateringName,
        required this.products});

  int totalPrice(){
    int total = 0;
    products.forEach((product) {
      total += product.subtotalPrice();
    });
    return total;
  }

}

class Product {
  int productId;
  String name;
  int price;
  int quantity;

  Product({required this.productId, required this.name, required this.price, required this.quantity});

  int subtotalPrice(){
    return price * quantity;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["product_id"] = productId;
    return data;
  }

}

