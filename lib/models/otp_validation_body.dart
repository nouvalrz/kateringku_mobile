class OtpValidationBody {
  String email, otp, password;

  OtpValidationBody(
      {required this.otp, required this.email, required this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["email"] = email;
    data["otp"] = otp;
    data["password"] = password;
    return data;
  }
}
