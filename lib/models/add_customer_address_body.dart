class AddCustomerAddressBody{
  String recipientName;
  String address;
  String villageName;
  double latitude;
  double longitude;
  String phone;

  AddCustomerAddressBody({required this.longitude, required this.latitude, required this.address, required this.phone, required this.recipientName, required this.villageName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["recipient_name"] = recipientName;
    data["address"] = address;
    data["village_name"] = villageName;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["phone"] = phone;
    return data;
  }
}