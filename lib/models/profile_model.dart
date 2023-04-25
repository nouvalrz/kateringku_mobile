class ProfileModel {
  String? name;
  String? email;
  String? phone;
  String? gender;
  int? balance;
  int? points;

  ProfileModel(
      {this.name,
        this.email,
        this.phone,
        this.gender,
        this.balance,
        this.points});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    balance = json['balance'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['balance'] = this.balance;
    data['points'] = this.points;
    return data;
  }
}