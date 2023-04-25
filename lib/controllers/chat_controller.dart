import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:kateringku_mobile/data/repositories/chat_repo.dart';
import 'package:kateringku_mobile/models/chat_compact_model.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController{
  var messages = <types.Message>[].obs;
  var isLoading = false.obs;
  var isLoadingList = false.obs;

  late types.User customerUser;
  late types.User cateringUser;

  var listChat = <ChatCompact>[].obs;

  final ChatRepo chatRepo;

  ChatController({required this.chatRepo});

  Future<void> loadMessage({required String cateringId}) async{
    isLoading.value = true;

    messages.clear();

    Response response = await chatRepo.loadMessage(recipientId: cateringId);

    if(response.statusCode == 200){
      for(var i=0; i< response.body["chats"].length ; i++){
        print("catering ID = ${cateringId} || Sender ID = ${response.body["chats"][i]['sender_id']}");
        var chat = types.TextMessage(
          author: response.body["chats"][i]['sender_id'].toString() == cateringId ? cateringUser : customerUser,
          createdAt: DateTime.parse(response.body["chats"][i]['created_at']).millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: response.body["chats"][i]['message'],
        );
        messages.insert(0, chat);
      }
    }

    isLoading.value = false;
  }

  void setUsers({required String cateringId, required String cateringImage}){
    cateringUser = types.User(id: cateringId, imageUrl: cateringImage);
    customerUser = const types.User(id: "customer");
  }

  void addMessage(types.Message message) {
    messages.value.insert(0, message);
    messages.refresh();
  }

  void handleSendPressed(types.PartialText message) async{
    var textMessage = types.TextMessage(
      author: customerUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
      status: types.Status.sending,
    );
    addMessage(textMessage);
    sendMessage(message: textMessage);
  }

  Future<void> sendMessage({required types.TextMessage message}) async{
    Response response = await chatRepo.sendMessage(recipientId: cateringUser.id, recipientType: "catering", message: message.text);
    if(response.statusCode == 200){
      messages[messages.indexWhere((element) => element.id == message.id)] = message.copyWith(status: types.Status.sent);
      messages.refresh();
    }
  }

  Future<void> getListChat() async{
    isLoadingList.value = true;

    listChat.clear();

    Response response = await chatRepo.getListChat();

    if(response.statusCode == 200){
      for(var i = 0 ; i < response.body["chats"].length ; i++){
        ChatCompact chatCompact = ChatCompact.fromJson(response.body['chats'][i]);
        listChat.add(chatCompact);
      }
    }

    listChat.sort((b, a) => DateTime.parse(a.lastChat!.createdAt!).compareTo(DateTime.parse(b.lastChat!.createdAt!)));

    isLoadingList.value = false;
  }

}