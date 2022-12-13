class RelevantCateringProductsResponseBody {
  int cateringId;
  List<Map<String, dynamic>>? cateringProducts;
  String cateringName;
  String cateringImageUrl;
  String cateringVillageName;

  int productId1;
  String productName1;
  int productPrice1;
  String productImage1;

  int productId2;
  String productName2;
  int productPrice2;
  String productImage2;

  List<Map<String, dynamic>>? relevantCatering;

  RelevantCateringProductsResponseBody({
    required this.cateringId,
    required this.cateringName,
    required this.cateringImageUrl,
    required this.cateringVillageName,
    required this.productId1,
    required this.productName1,
    required this.productPrice1,
    required this.productImage1,
    required this.productId2,
    required this.productName2,
    required this.productPrice2,
    required this.productImage2,
  });

  // RelevantCateringProductsResponseBody.fromJson(Response data) {
  //   data.body['caterings'].forEach((key, value) {
  //     relevantCatering!.add({
  //       "catering_name": value['catering']['name'],
  //       "catering_id": value['catering']['id'],
  //       "catering_image": value['catering']['original_path'],
  //       "catering_products": [
  //         {
  //           "product_id": value["products"][0]["id"],
  //           "product_name": value["products"][0]["name"],
  //           "product_price": value["products"][0]["price"],
  //           "product_image": value["products"][0]["original_path"],
  //         },
  //         {
  //           "product_id": value["products"][1]["id"],
  //           "product_name": value["products"][1]["name"],
  //           "product_price": value["products"][1]["price"],
  //           "product_image": value["products"][1]["original_path"],
  //         },
  //       ]
  //     });
  //   });
  // cateringId = catering["id"];
  // cateringName = catering["name"];
  // cateringImageUrl = catering["original_path"];
  // products.forEach((key, value) {
  //   cateringProducts!.add({
  //     "product_id": value["id"],
  //     "product_name": value["name"],
  //     "product_price": value["price"],
  //     "product_image": value["original_path"]
  //   });
  // });

}
