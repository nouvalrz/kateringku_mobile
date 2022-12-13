class RelevantCateringProductsRequestBody {
  String location;
  RelevantCateringProductsRequestBody({required this.location});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["district_name"] = location;
    return data;
  }
}
