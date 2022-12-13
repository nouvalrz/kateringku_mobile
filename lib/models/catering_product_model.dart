class CateringProductModel {
  String product_id;
  String product_name;
  String product_description;
  int product_weight;
  int minimum_quantity;
  int maximum_quantity;
  int is_free_delivery;
  int is_available;
  int product_price;
  String product_image;
  int quantity = 0;

  CateringProductModel({
      required this.product_id,
    required this.product_price,
    required this.product_name,
    required this.product_description,
    required this.product_weight,
    required this.minimum_quantity,
    required this.maximum_quantity,
    required this.is_free_delivery,
    required this.is_available,
    required this.product_image});

  void addQuantity(){
    quantity += 1;
  }
}