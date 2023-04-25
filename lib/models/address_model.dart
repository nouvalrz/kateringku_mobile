class AddressModel {
  int? id;
  int? customerId;
  String? recipientName;
  String? address;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  String? phone;
  int? villageId;
  bool? isSelected;
  String? districtName;
  String? villageName;

  AddressModel(
      {this.id,
        this.customerId,
        this.recipientName,
        this.address,
        this.latitude,
        this.longitude,
        this.createdAt,
        this.updatedAt,
        this.phone,
        this.villageId, this.districtName, this.villageName});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    recipientName = json['recipient_name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    phone = json['phone'];
    villageId = json['village_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['recipient_name'] = this.recipientName;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['phone'] = this.phone;
    data['village_id'] = this.villageId;
    data['village_name'] = this.villageName;
    return data;
  }
}