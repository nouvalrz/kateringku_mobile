class RelevantCateringProductsRequestBody {
  String location;
  double latitude;
  double longitude;
  RelevantCateringProductsRequestBody(
      {required this.location,
      required this.latitude,
      required this.longitude});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["district_name"] = location;
    data["customer_latitude"] = latitude;
    data["customer_longitude"] = longitude;

    return data;
  }
}
