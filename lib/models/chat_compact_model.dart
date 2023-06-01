import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ChatCompactModel {
  int? id;
  String? updatedAt;
  int? customerId;
  int? cateringId;
  LatestChat? latestChat;
  Catering? catering;

  ChatCompactModel(
      {this.id,
      this.updatedAt,
      this.customerId,
      this.cateringId,
      this.latestChat,
      this.catering});

  ChatCompactModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    updatedAt = json['updated_at'];
    customerId = json['customer_id'];
    cateringId = json['catering_id'];
    latestChat = json['latest_chat'] != null
        ? new LatestChat.fromJson(json['latest_chat'])
        : null;
    catering = json['catering'] != null
        ? new Catering.fromJson(json['catering'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['updated_at'] = this.updatedAt;
    data['customer_id'] = this.customerId;
    data['catering_id'] = this.cateringId;
    if (this.latestChat != null) {
      data['latest_chat'] = this.latestChat!.toJson();
    }
    if (this.catering != null) {
      data['catering'] = this.catering!.toJson();
    }
    return data;
  }
}

class LatestChat {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? roomchatsId;
  String? message;
  String? sender;
  Null? orderId;

  LatestChat(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.roomchatsId,
      this.message,
      this.sender,
      this.orderId});

  LatestChat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roomchatsId = json['roomchats_id'];
    message = json['message'];
    sender = json['sender'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['roomchats_id'] = this.roomchatsId;
    data['message'] = this.message;
    data['sender'] = this.sender;
    data['order_id'] = this.orderId;
    return data;
  }

  String dateWording() {
    initializeDateFormatting('id');
    var now = DateTime.now().toUtc();
    var createdAt = DateTime.parse(this.createdAt!);

    if (now.day >= createdAt.day &&
        now.month >= createdAt.month &&
        now.year >= createdAt.year) {
      return DateFormat('jm', 'id').format(createdAt.toLocal());
    } else {
      return DateFormat('d MMMM', 'id').format(createdAt.toLocal());
    }
  }
}

class Catering {
  int? id;
  String? name;
  String? image;

  Catering({this.id, this.name, this.image});

  Catering.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
