import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ChatCompact {
  String? cateringName;
  String? cateringImage;
  int? cateringId;
  LastChat? lastChat;

  ChatCompact(
      {this.cateringName, this.cateringImage, this.cateringId, this.lastChat});

  ChatCompact.fromJson(Map<String, dynamic> json) {
    cateringName = json['catering_name'];
    cateringImage = json['catering_image'];
    cateringId = json['catering_id'];
    lastChat = json['last_chat'] != null
        ? new LastChat.fromJson(json['last_chat'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catering_name'] = this.cateringName;
    data['catering_image'] = this.cateringImage;
    data['catering_id'] = this.cateringId;
    if (this.lastChat != null) {
      data['last_chat'] = this.lastChat!.toJson();
    }
    return data;
  }
}

class LastChat {
  int? id;
  int? senderId;
  int? recipientId;
  String? message;
  String? createdAt;
  String? updatedAt;

  LastChat(
      {this.id,
        this.senderId,
        this.recipientId,
        this.message,
        this.createdAt,
        this.updatedAt});

  LastChat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    recipientId = json['recipient_id'];
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'] ?? null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['recipient_id'] = this.recipientId;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  String dateWording() {
    initializeDateFormatting('id');
    var now  = DateTime.now().toUtc();
    var createdAt = DateTime.parse(this.createdAt!);

    if(now.day >= createdAt.day &&
        now.month >= createdAt.month &&
        now.year >= createdAt.year){
      return DateFormat('jm', 'id').format(createdAt.toLocal());
    }else{
      return DateFormat('d MMMM', 'id').format(createdAt.toLocal());
    }
  }
}
