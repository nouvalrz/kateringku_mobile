class CustomerLoginBody {
  String email;
  String password;
  String? fcm_token;
  CustomerLoginBody({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["email"] = email;
    data["password"] = password;
    data["fcm_token"] = fcm_token!;
    return data;
  }
}
