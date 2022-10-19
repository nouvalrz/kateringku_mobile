class CustomerRegisterBody {
  String name;
  String phone;
  String email;
  String password;
  String passwordConfirmation;

  CustomerRegisterBody({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["email"] = email;
    data["phone"] = phone;
    data["password"] = password;
    data["password_confirmation"] = passwordConfirmation;
    data["gender"] = "U";
    return data;
  }
}
