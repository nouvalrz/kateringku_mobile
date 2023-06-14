import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kateringku_mobile/constants/image_path.dart';
import 'package:kateringku_mobile/controllers/order_list_controller.dart';
import 'package:kateringku_mobile/routes/route_helper.dart';

import '../../helpers/currency_format.dart';
import '../../themes/app_theme.dart';

class OrderView extends StatefulWidget {
  OrderView({Key? key}) : super(key: key);

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  var orderListController = Get.find<OrderListController>();

  @override
  void initState() {
    super.initState();
    orderListController.getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        // orderListController.isLoading.value = true;
        orderListController.getAllOrders();
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
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.feed_outlined,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text("Pesanan",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                orderListController.getAllOrders();
                              },
                              child: Icon(
                                Icons.refresh_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Obx(() {
                if (orderListController.isLoading.value) {
                  return Expanded(
                      child: Center(
                    child:
                        CircularProgressIndicator(color: AppTheme.primaryGreen),
                  ));
                } else {
                  if (orderListController.orders.isEmpty) {
                    return Expanded(
                        child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: SvgPicture.asset(ImagePath.emptyOrder),
                            height: 260,
                            width: 260,
                          ),
                          SizedBox(
                            height: 26,
                          ),
                          Text("Pesanan Anda Masih Kosong",
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ));
                  } else {
                    return Expanded(
                        child: RefreshIndicator(
                      onRefresh: () async {
                        orderListController.getAllOrders();
                      },
                      color: Colors.white,
                      backgroundColor: AppTheme.primaryGreen,
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemBuilder: (context, index) {
                          return OrderCard(
                            index: index,
                          );
                        },
                        itemCount: orderListController.orders.length,
                        padding: EdgeInsets.only(top: 12),
                      ),
                    ));
                  }
                }
              }),
            ])
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  int index;

  OrderCard({Key? key, required this.index}) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  var orderListController = Get.find<OrderListController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (orderListController.orders[widget.index].isPreOrder()) {
          Get.toNamed(RouteHelper.orderDetail,
              arguments: orderListController.orders[widget.index].id!);
        } else {
          Get.toNamed(RouteHelper.subsOrderDetail,
              arguments: orderListController.orders[widget.index].id!);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: 25, right: 25, bottom: 20),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!, width: 0.5),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Container(
                    //   height: 35,
                    //   width: 35,
                    //   color: Colors.grey,
                    // ),
                    if (orderListController.orders[widget.index].isPreOrder())
                      Image.asset(
                        ImagePath.preOrderIcon,
                        height: 35,
                      )
                    else
                      Image.asset(
                        ImagePath.subsOrderIcon,
                        height: 35,
                      ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      children: [
                        Text(
                            orderListController.orders[widget.index]
                                .orderTypeWording(),
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 11, fontWeight: FontWeight.w400)),
                        Text(
                            orderListController.orders[widget.index]
                                .deliveryDateWording(),
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w500))
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          orderListController.orders[widget.index]
                              .getOrderStatusBadge()!,
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                    )
                  ],
                ),
                Divider(),
                Text(orderListController.orders[widget.index].cateringName!,
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w500)),
                Text(
                    "${orderListController.orders[widget.index].orderQuantity!} Item",
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 11, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 8,
                ),
                Text(orderListController.orders[widget.index].itemSummary!,
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 11, fontWeight: FontWeight.w300)),
                SizedBox(
                  height: 6,
                ),
                Text(
                    CurrencyFormat.convertToIdr(
                        orderListController.orders[widget.index].totalPrice! -
                            orderListController.orders[widget.index].useBalance,
                        0),
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
