import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kateringku_mobile/controllers/chat_controller.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';
import 'package:uuid/uuid.dart';

import '../../constants/app_constant.dart';
import '../../controllers/order_detail_controller.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  var chatController = Get.find<ChatController>();
  late String cateringId, cateringName, cateringImage;
  // var orderDetailController = Get.find<OrderDetailController>();

  @override
  void initState() {
    super.initState();
    cateringId = Get.arguments!["cateringId"];
    cateringName = Get.arguments!["cateringName"];
    cateringImage = Get.arguments!["cateringImage"];
    chatController.setUsers(cateringId: cateringId, cateringImage: cateringImage);
    chatController.loadMessage(cateringId: cateringId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: SizedBox(
              height: 10,
              child: Container(
                color: Colors.grey[200],
                width: 600,
              ),
            ),
            top: 90,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 46),
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    Get.back();

                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: ClipOval(child: Image(
                            image: NetworkImage(cateringImage)),),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Chat",
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(
                            height: 4,
                          ),
                          Text(cateringName,
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 11, fontWeight: FontWeight.w400)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Obx(() {
                if (chatController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primaryGreen,),
                  );
                } else {
                  return Chat(
                    messages: chatController.messages.value,
                    dateHeaderThreshold: 60000,
                    onSendPressed: chatController.handleSendPressed,
                    user: chatController.customerUser,
                    theme:  DefaultChatTheme(
                        inputTextStyle: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w500),
                        dateDividerTextStyle: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w500),
                        receivedMessageBodyTextStyle: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w500),
                        sentMessageBodyTextStyle: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
                        primaryColor: AppTheme.primaryGreen,
                        inputBorderRadius: BorderRadius.zero,
                        inputTextColor: Colors.black,
                        inputPadding: EdgeInsets.all(20),
                        inputTextDecoration: InputDecoration(contentPadding: EdgeInsets.all(18)),
                        inputContainerDecoration: BoxDecoration(color: AppTheme.primaryWhite, border: Border.all(color: AppTheme.greyOutline, width: 0.6),),
                        sendButtonIcon: Icon(Icons.send_rounded, color: AppTheme.primaryGreen,)
                        ),
                    showUserAvatars: true,
                    showUserNames: true,
                  );
                }
              }),
            ),
          ]),
        ],
      ),
    );
  }

  // void _addMessage(types.Message message) {
  //   setState(() {
  //     _messages.insert(0, message);
  //   });
  // }


// void _loadMessages() async {
//   final response = await rootBundle.loadString('assets/messages.json');
//   final messages = (jsonDecode(response) as List)
//       .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
//       .toList();
//
//   setState(() {
//     _messages = messages;
//   });
// }
}
