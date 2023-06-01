import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:kateringku_mobile/controllers/subs_order_controller.dart';

import '../../constants/app_constant.dart';
import '../../helpers/currency_format.dart';
import '../../routes/route_helper.dart';
import '../../themes/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

class SubsPickProductView extends StatefulWidget {
  const SubsPickProductView({Key? key}) : super(key: key);

  @override
  State<SubsPickProductView> createState() => _SubsPickProductViewState();
}

class _SubsPickProductViewState extends State<SubsPickProductView> {
  var subsOrderController = Get.find<SubsOrderController>();
  late int orderIndex;

  void initState() {
    initializeDateFormatting('id');
    super.initState();
    orderIndex = Get.arguments!["index"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 46),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Get.back();
                      },
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Produk Untuk " +
                                DateFormat.MMMMd('id').format(
                                    subsOrderController.orderList.values
                                        .elementAt(orderIndex)
                                        .deliveryDateTime!),
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(
                          height: 4,
                        ),
                        Text("Pilih Produk",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 11, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    subsOrderController.resetOrderInDay(orderIndex: orderIndex);
                  },
                  child: Text("Reset",
                      style: AppTheme.textTheme.titleLarge!.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryRed)),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Expanded(
            child: ListView.builder(
          padding: EdgeInsets.only(left: 25, right: 25, top: 20),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return ProductCardForSubs(
              productIndex: index,
              orderIndex: orderIndex,
            );
          },
          itemCount: subsOrderController.cateringProducts.length,
        )),
        SizedBox(
          height: 72,
        )
      ]),
      Align(
        child: SizedBox(
          height: 72,
          child: Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[350]!)),
                color: Colors.white),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Obx(() {
                        return Column(
                          children: [
                            Text(
                                CurrencyFormat.convertToIdr(
                                    subsOrderController.orderList.values
                                        .elementAt(orderIndex)
                                        .totalPrice,
                                    0),
                                // "Rp. 20.000",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 13, fontWeight: FontWeight.w500)),
                            Text(
                                subsOrderController.orderList.values
                                        .elementAt(orderIndex)
                                        .totalQuantity
                                        .toString() +
                                    " Item",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 11, fontWeight: FontWeight.w300)),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                        );
                      })
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
                const SizedBox(
                  width: 18,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 72,
                    width: 150,
                    color: AppTheme.primaryOrange,
                    child: Center(
                      child: Text("Simpan",
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        alignment: Alignment.bottomCenter,
      )
    ]));
  }
}

class ProductCardForSubs extends StatefulWidget {
  int productIndex;
  int orderIndex;

  ProductCardForSubs(
      {Key? key, required this.productIndex, required this.orderIndex})
      : super(key: key);

  @override
  State<ProductCardForSubs> createState() => _ProductCardForSubsState();
}

class _ProductCardForSubsState extends State<ProductCardForSubs> {
  @override
  Widget build(BuildContext context) {
    var subsOrderController = Get.find<SubsOrderController>();
    TextEditingController quantityEdtingController = TextEditingController();
    quantityEdtingController.text = subsOrderController
        .getOrderProductQuantity(
            orderIndex: widget.orderIndex,
            productId:
                subsOrderController.cateringProducts[widget.productIndex].id!)
        .toString();
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FancyShimmerImage(
                      imageUrl: AppConstant.BASE_URL +
                          subsOrderController
                              .cateringProducts[widget.productIndex].image!
                              .substring(1)),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                        subsOrderController
                            .cateringProducts[widget.productIndex].name!,
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    Text(
                        subsOrderController
                                    .cateringProducts[widget.productIndex]
                                    .description!
                                    .length >
                                32
                            ? '${subsOrderController.cateringProducts[widget.productIndex].description!.substring(0, 32)}...'
                            : subsOrderController
                                .cateringProducts[widget.productIndex]
                                .description!,
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 11, fontWeight: FontWeight.w300)),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Obx(() {
                                return Text(
                                    CurrencyFormat.convertToIdr(
                                        subsOrderController.orderList.values
                                            .elementAt(widget.orderIndex)
                                            .orderProducts
                                            .firstWhere(
                                                (element) =>
                                                    element.id ==
                                                    subsOrderController
                                                        .cateringProducts[
                                                            widget.productIndex]
                                                        .id,
                                                orElse: () =>
                                                    subsOrderController
                                                            .cateringProducts[
                                                        widget.productIndex])
                                            .fixPrice()!,
                                        0),
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500));
                              }),
                              SizedBox(
                                child: VerticalDivider(
                                  color: Colors.grey[500],
                                  thickness: 0.7,
                                ),
                                height: 16,
                              ),
                              Text(
                                  "Terjual ${subsOrderController.cateringProducts[widget.productIndex].totalSales}",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                        Obx(() {
                          if (subsOrderController.getOrderProductQuantity(
                                  orderIndex: widget.orderIndex,
                                  productId: subsOrderController
                                      .cateringProducts[widget.productIndex]
                                      .id!) ==
                              0) {
                            return GestureDetector(
                              onTap: () async {
                                subsOrderController.addProductQuantity(
                                    orderIndex: widget.orderIndex,
                                    productId: subsOrderController
                                        .cateringProducts[widget.productIndex]
                                        .id!);
                                quantityEdtingController.text =
                                    subsOrderController
                                        .getOrderProductQuantity(
                                            orderIndex: widget.orderIndex,
                                            productId: subsOrderController
                                                .cateringProducts[
                                                    widget.productIndex]
                                                .id!)
                                        .toString();
                                if (subsOrderController
                                    .cateringProducts[widget.productIndex]
                                    .isProductCustomable()) {
                                  await Get.toNamed(
                                      RouteHelper.subsPickProductOption,
                                      arguments: {
                                        "productId": subsOrderController
                                            .cateringProducts[
                                                widget.productIndex]
                                            .id!,
                                        "orderIndex": widget.orderIndex
                                      });
                                  // cateringProductController.totalPrices();
                                  subsOrderController.orderList.values
                                      .elementAt(widget.orderIndex)
                                      .setTotalPrices();
                                  subsOrderController.orderList.values
                                      .elementAt(widget.orderIndex)
                                      .getProductById(subsOrderController
                                          .cateringProducts[widget.productIndex]
                                          .id!)
                                      .setProductOptionSummary();
                                  subsOrderController.orderList.refresh();
                                }
                                // cateringProductController
                                //     .addProductQuantity(index);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppTheme.primaryGreen,
                                    borderRadius: BorderRadius.circular(4)),
                                height: 28,
                                width: 28,
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          subsOrderController
                                              .minusProductQuantity(
                                                  orderIndex: widget.orderIndex,
                                                  productId: subsOrderController
                                                      .cateringProducts[
                                                          widget.productIndex]
                                                      .id!);
                                          quantityEdtingController.text =
                                              subsOrderController
                                                  .getOrderProductQuantity(
                                                      orderIndex:
                                                          widget.orderIndex,
                                                      productId: subsOrderController
                                                          .cateringProducts[
                                                              widget
                                                                  .productIndex]
                                                          .id!)
                                                  .toString();
                                        },
                                        // onTap: () => cateringProductController
                                        //     .minusProductQuantity(index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppTheme.primaryGreen,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          height: 28,
                                          width: 28,
                                          child: const Center(
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      SizedBox(
                                        width: 32,
                                        height: 28,
                                        child: TextFormField(
                                            controller:
                                                quantityEdtingController,
                                            // initialValue: "0",
                                            // cateringProductController
                                            //     .products[index]
                                            //     .orderQuantity
                                            //     .toString(),
                                            // inputFormatters: [
                                            //   LengthLimitingTextInputFormatter(
                                            //       3),
                                            // ],
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            style: AppTheme
                                                .textTheme.titleLarge!
                                                .copyWith(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          subsOrderController
                                              .addProductQuantity(
                                                  orderIndex: widget.orderIndex,
                                                  productId: subsOrderController
                                                      .cateringProducts[
                                                          widget.productIndex]
                                                      .id!);
                                          quantityEdtingController.text =
                                              subsOrderController
                                                  .getOrderProductQuantity(
                                                      orderIndex:
                                                          widget.orderIndex,
                                                      productId: subsOrderController
                                                          .cateringProducts[
                                                              widget
                                                                  .productIndex]
                                                          .id!)
                                                  .toString();
                                        },
                                        // onTap: () => cateringProductController
                                        //     .addProductQuantity(index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppTheme.primaryGreen,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          height: 28,
                                          width: 28,
                                          child: const Center(
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (subsOrderController.cateringProducts[widget.productIndex].orderQuantity ==
                                          subsOrderController
                                              .cateringProducts[
                                                  widget.productIndex]
                                              .minimumQuantity &&
                                      subsOrderController.cateringProducts[widget.productIndex].minimumQuantity! !=
                                          1)
                                    Text("Min. " + subsOrderController.cateringProducts[widget.productIndex].minimumQuantity.toString(),
                                        style: AppTheme.textTheme.titleLarge!
                                            .copyWith(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300))
                                  else if (subsOrderController
                                          .cateringProducts[widget.productIndex]
                                          .orderQuantity >=
                                      subsOrderController
                                          .cateringProducts[widget.productIndex]
                                          .maximumQuantity!)
                                    Text("Max. " + subsOrderController.cateringProducts[widget.productIndex].maximumQuantity!.toString(),
                                        style: AppTheme.textTheme.titleLarge!
                                            .copyWith(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300)),
                                ],
                              ),
                            );
                          }
                        })
                      ],
                    ),
                    Row(
                      children: [
                        if (subsOrderController
                            .cateringProducts[widget.productIndex]
                            .isProductCustomable())
                          GestureDetector(
                            onTap: () async {
                              await Get.toNamed(
                                  RouteHelper.subsPickProductOption,
                                  arguments: {
                                    "productId": subsOrderController
                                        .cateringProducts[widget.productIndex]
                                        .id!,
                                    "orderIndex": widget.orderIndex
                                  });
                              // cateringProductController.totalPrices();
                              subsOrderController.orderList.values
                                  .elementAt(widget.orderIndex)
                                  .setTotalPrices();
                              subsOrderController.orderList.values
                                  .elementAt(widget.orderIndex)
                                  .getProductById(subsOrderController
                                      .cateringProducts[widget.productIndex]
                                      .id!)
                                  .setProductOptionSummary();
                              subsOrderController.orderList.refresh();
                            },
                            child: Row(
                              children: [
                                Transform.translate(
                                  child: Icon(
                                    Icons.dashboard_customize_rounded,
                                    size: 18,
                                    color: Colors.grey[500],
                                  ),
                                  offset: const Offset(-3, 0),
                                ),
                                Text(
                                  "Bisa Kustom",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          )
                      ],
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              // Expanded(
              //     child: Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     SizedBox(height: 32,),
              //
              //   ],
              // ))
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Divider(
            color: Colors.grey[300],
          ),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}
