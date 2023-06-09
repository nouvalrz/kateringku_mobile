import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kateringku_mobile/base/no_glow.dart';
import 'package:kateringku_mobile/controllers/chat_controller.dart';

import '../../constants/app_constant.dart';
import '../../routes/route_helper.dart';
import '../../themes/app_theme.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  var chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id');
    chatController.getListChat();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        chatController.getListChat();
      },
      child: Scaffold(
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
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pesan",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(child: Obx(() {
                if (chatController.isLoadingList.value) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: AppTheme.primaryGreen,
                  ));
                } else {
                  return ScrollConfiguration(
                    behavior: NoGlow(),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ChatCard(index: index);
                      },
                      itemCount: chatController.listChat.length,
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                    ),
                  );
                }
              }))
            ]),
          ],
        ),
      ),
    );
  }
}

class ChatCard extends StatelessWidget {
  int index;
  ChatCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chatController = Get.find<ChatController>();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.toNamed(RouteHelper.chat, arguments: {
          "cateringId": chatController.listChat[index].catering!.id!.toString(),
          "cateringName": chatController.listChat[index].catering!.name!,
          "cateringImage": chatController.listChat[index].catering!.image!
        });
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 14, bottom: 14),
        child: Container(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipOval(
                      child: FancyShimmerImage(
                          imageUrl:
                              chatController.listChat[index].catering!.image!),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Flexible(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  chatController
                                      .listChat[index].catering!.name!,
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                              Text(
                                  chatController.listChat[index].latestChat!
                                      .dateWording(),
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            chatController.listChat[index].latestChat!.message!,
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.secondaryBlack),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Divider()
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
