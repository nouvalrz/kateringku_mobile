class CateringWithTwoProductModel {
  int cateringId;
  List<Map<String, dynamic>>? cateringProducts;
  String cateringName;
  String cateringImageUrl;
  String cateringVillageName;
  double cateringLatitude;
  double cateringLongitude;

  int productId1;
  String productName1;
  int productPrice1;
  String productImage1;

  int productId2;
  String productName2;
  int productPrice2;
  String productImage2;

  List<Map<String, dynamic>>? relevantCatering;

  CateringWithTwoProductModel({
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
    required this.cateringLatitude,
    required this.cateringLongitude
  });


}
