class CustomerAddressModel{
  String id;
  String customer_id;
  String recipient_name;
  String address;
  double latitude;
  double longitude;

  CustomerAddressModel({
      required this.id,
    required this.customer_id,
    required this.recipient_name,
    required this.address,
    required this.latitude,
    required this.longitude});
}