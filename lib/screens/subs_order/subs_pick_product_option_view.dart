import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../base/show_custom_snackbar.dart';
import '../../constants/app_constant.dart';
import '../../controllers/catering_home_controller.dart';
import '../../controllers/subs_order_controller.dart';
import '../../helpers/currency_format.dart';
import '../../themes/app_theme.dart';

class SubsPickProductOptionView extends StatefulWidget {
  const SubsPickProductOptionView({Key? key}) : super(key: key);

  @override
  State<SubsPickProductOptionView> createState() =>
      _SubsPickProductOptionView();
}

class _SubsPickProductOptionView extends State<SubsPickProductOptionView> {
  var subsOrderController = Get.find<SubsOrderController>();
  late int orderIndex;
  late int productId;

  @override
  void initState() {
    orderIndex = Get.arguments!["orderIndex"];
    productId = Get.arguments!["productId"];
  }

  Future<bool> _onWillPop() async {
    // if (cateringProductController.products[index].isAllOptionFulfilled()) {
    //   return true;
    // } else {
    //   showCustomSnackBar(
    //       message: "Harap isi pilihan yang wajib!", title: "BELUM TERPENUHI");
    //   return false;
    // }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: Stack(children: [
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
        Positioned(
          child: SizedBox(
            height: 10,
            child: Container(
              color: Colors.grey[200],
              width: 600,
            ),
          ),
          top: 210,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 46),
            child: Container(
              child: GestureDetector(
                onTap: () {
                  // if (cateringProductController.products[index]
                  //     .isAllOptionFulfilled()) {
                  //   Get.back();
                  // } else {
                  //   showCustomSnackBar(
                  //       message: "Harap isi pilihan yang wajib!",
                  //       title: "BELUM TERPENUHI");
                  // }
                  if (subsOrderController.orderList.values
                      .elementAt(orderIndex)
                      .getProductById(productId)
                      .isAllOptionFulfilled()) {
                    Get.back();
                  } else {
                    showCustomSnackBar(
                        message: "Harap isi pilihan yang wajib!",
                        title: "BELUM TERPENUHI");
                  }
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            subsOrderController.orderList.values
                                .elementAt(orderIndex)
                                .getProductById(productId)
                                .name!,
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(
                          height: 4,
                        ),
                        Text("Kustom Pesanan",
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
            height: 29,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 46),
            child: ProductCardInOption(),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 72),
            child: SingleChildScrollView(
                child: ListView.builder(
              itemBuilder: (context, indexProductOption) {
                return ProductOptionChoice(
                  indexProductOption: indexProductOption,
                  productId: productId,
                  orderIndex: orderIndex,
                );
              },
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: subsOrderController.orderList.values
                  .elementAt(orderIndex)
                  .getProductById(productId)
                  .productOptions!
                  .length!,
              padding: EdgeInsets.only(bottom: 20),
            )),
          ))
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
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  // const Icon(
                  //   Icons.calendar_month_outlined,
                  //   color: Colors.grey,
                  // ),
                  // const SizedBox(
                  //   width: 8,
                  // ),
                  // Text("Pesan\nLangganan",
                  //     style: AppTheme.textTheme.titleLarge!.copyWith(
                  //         fontSize: 13, fontWeight: FontWeight.w500)),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,

                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Harga Kustom",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400)),
                              Obx(() {
                                return Text(
                                    CurrencyFormat.convertToIdr(
                                        subsOrderController.orderList.values
                                            .elementAt(orderIndex)
                                            .getProductById(productId)
                                            .fixPrice(),
                                        0),
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500));
                              })
                            ],
                          ),
                        )
                      ],
                      // mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  ),
                  // SizedBox(
                  //   width: 18,
                  // ),
                  GestureDetector(
                    onTap: () {
                      if (subsOrderController.orderList.values
                          .elementAt(orderIndex)
                          .getProductById(productId)
                          .isAllOptionFulfilled()) {
                        Get.back();
                      } else {
                        showCustomSnackBar(
                            message: "Harap isi pilihan yang wajib!",
                            title: "BELUM TERPENUHI");
                      }
                    },
                    child: Container(
                      height: 72,
                      width: 185,
                      color: AppTheme.primaryOrange,
                      child: Center(
                        child: Text("Tambahkan",
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
      ])),
    );
  }
}

class ProductCardInOption extends StatefulWidget {
  const ProductCardInOption({Key? key}) : super(key: key);

  @override
  State<ProductCardInOption> createState() => _ProductCardInOptionState();
}

class _ProductCardInOptionState extends State<ProductCardInOption> {
  var subsOrderController = Get.find<SubsOrderController>();
  late int productId;
  late int orderIndex;
  @override
  void initState() {
    productId = Get.arguments["productId"];
    orderIndex = Get.arguments["orderIndex"];
  }

  @override
  Widget build(BuildContext context) {
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
                      imageUrl: subsOrderController.orderList.values
                          .elementAt(orderIndex)
                          .getProductById(productId)
                          .image!),
                ),
              ),
              SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                        subsOrderController.orderList.values
                            .elementAt(orderIndex)
                            .getProductById(productId)
                            .name!,
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 18,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Harga Dasar",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 11, fontWeight: FontWeight.w300)),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                      CurrencyFormat.convertToIdr(
                                          subsOrderController.orderList.values
                                              .elementAt(orderIndex)
                                              .getProductById(productId)
                                              .price,
                                          0),
                                      style: AppTheme.textTheme.titleLarge!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    child: VerticalDivider(
                                      color: Colors.grey[500],
                                      thickness: 0.7,
                                    ),
                                    height: 16,
                                  ),
                                  Text(
                                      "Terjual " +
                                          subsOrderController.orderList.values
                                              .elementAt(orderIndex)
                                              .getProductById(productId)
                                              .totalSales
                                              .toString(),
                                      style: AppTheme.textTheme.titleLarge!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
        ],
      ),
    );
  }
}

class ProductOptionChoice extends StatefulWidget {
  // ProductOption productOption;
  int orderIndex;
  int productId;
  int indexProductOption;
  ProductOptionChoice(
      {Key? key,
      required this.indexProductOption,
      required this.productId,
      required this.orderIndex})
      : super(key: key);

  @override
  State<ProductOptionChoice> createState() => _ProductOptionChoiceState();
}

class _ProductOptionChoiceState extends State<ProductOptionChoice> {
  // var cateringProductController = Get.find<CateringHomeController>();
  var subsOrderController = Get.find<SubsOrderController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    subsOrderController.orderList.values
                        .elementAt(widget.orderIndex)
                        .getProductById(widget.productId)
                        .productOptions![widget.indexProductOption]
                        .optionName!,
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 4,
                ),
                Text(
                    subsOrderController.orderList.values
                        .elementAt(widget.orderIndex)
                        .getProductById(widget.productId)
                        .productOptions![widget.indexProductOption]
                        .termsWording(),
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 11, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          SizedBox(
            height: 6,
          ),
          ListView.builder(
            itemBuilder: (context, indexProductOptionDetail) {
              return ProductOptionDetail(
                productId: widget.productId,
                indexProductOption: widget.indexProductOption,
                indexProductOptionDetail: indexProductOptionDetail,
                orderIndex: widget.orderIndex,
              );
            },
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: subsOrderController.orderList.values
                .elementAt(widget.orderIndex)
                .getProductById(widget.productId)
                .productOptions![widget.indexProductOption]
                .productOptionDetails!
                .length,
            padding: EdgeInsets.only(bottom: 12),
          ),
          SizedBox(
            height: 10,
            child: Container(
              color: Colors.grey[200],
              width: 600,
            ),
          ),
          SizedBox(
            height: 24,
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}

class ProductOptionDetail extends StatefulWidget {
  int orderIndex;
  int productId;
  int indexProductOption;
  int indexProductOptionDetail;
  ProductOptionDetail(
      {Key? key,
      required this.orderIndex,
      required this.productId,
      required this.indexProductOption,
      required this.indexProductOptionDetail})
      : super(key: key);

  @override
  State<ProductOptionDetail> createState() => _ProductOptionDetailState();
}

class _ProductOptionDetailState extends State<ProductOptionDetail> {
  var subsOrderController = Get.find<SubsOrderController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 25, right: 25),
      child: Container(
        child: Column(
          children: [
            Divider(
              color: Colors.grey[400],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        subsOrderController.orderList.values
                            .elementAt(widget.orderIndex)
                            .getProductById(widget.productId)
                            .productOptions![widget.indexProductOption]
                            .productOptionDetails![
                                widget.indexProductOptionDetail]
                            .optionChoiceName!,
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w400)),
                  ],
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        if (subsOrderController.orderList.values
                                .elementAt(widget.orderIndex)
                                .getProductById(widget.productId)
                                .productOptions![widget.indexProductOption]
                                .productOptionDetails![
                                    widget.indexProductOptionDetail]
                                .addtionalPrice ==
                            0)
                          Text("Gratis",
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w400))
                        else
                          Text(
                              "+" +
                                  CurrencyFormat.convertToIdr(
                                      subsOrderController.orderList.values
                                          .elementAt(widget.orderIndex)
                                          .getProductById(widget.productId)
                                          .productOptions![
                                              widget.indexProductOption]
                                          .productOptionDetails![
                                              widget.indexProductOptionDetail]
                                          .addtionalPrice,
                                      0),
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w400)),
                        SizedBox(
                          width: 12,
                        ),
                        Obx(() {
                          return SizedBox(
                            child: Checkbox(
                              activeColor: AppTheme.primaryGreen,
                              value: subsOrderController.orderList.values
                                  .elementAt(widget.orderIndex)
                                  .getProductById(widget.productId)
                                  .productOptions![widget.indexProductOption]
                                  .productOptionDetails![
                                      widget.indexProductOptionDetail]
                                  .isSelected,
                              onChanged: (value) {
                                // cateringProductController.products.refresh();
                                subsOrderController.orderList.refresh();
                                if (value!) {
                                  if (subsOrderController.orderList.values
                                      .elementAt(widget.orderIndex)
                                      .getProductById(widget.productId)
                                      .productOptions![
                                          widget.indexProductOption]
                                      .isOptionMax()) {
                                    return;
                                  }
                                  subsOrderController.orderList.values
                                      .elementAt(widget.orderIndex)
                                      .getProductById(widget.productId)
                                      .productOptions![
                                          widget.indexProductOption]
                                      .productOptionDetails![
                                          widget.indexProductOptionDetail]
                                      .isSelected = value!;
                                  subsOrderController.orderList.values
                                      .elementAt(widget.orderIndex)
                                      .getProductById(widget.productId)
                                      .productOptions![
                                          widget.indexProductOption]
                                      .selectedOption += 1;
                                  subsOrderController.orderList.values
                                          .elementAt(widget.orderIndex)
                                          .getProductById(widget.productId)
                                          .additionalPrice +=
                                      subsOrderController.orderList.values
                                          .elementAt(widget.orderIndex)
                                          .getProductById(widget.productId)
                                          .productOptions![
                                              widget.indexProductOption]
                                          .productOptionDetails![
                                              widget.indexProductOptionDetail]
                                          .addtionalPrice!;
                                  // cateringProductController.totalPrices();
                                } else {
                                  subsOrderController.orderList.values
                                      .elementAt(widget.orderIndex)
                                      .getProductById(widget.productId)
                                      .productOptions![
                                          widget.indexProductOption]
                                      .selectedOption -= 1;
                                  subsOrderController.orderList.values
                                      .elementAt(widget.orderIndex)
                                      .getProductById(widget.productId)
                                      .productOptions![
                                          widget.indexProductOption]
                                      .productOptionDetails![
                                          widget.indexProductOptionDetail]
                                      .isSelected = value!;
                                  subsOrderController.orderList.values
                                          .elementAt(widget.orderIndex)
                                          .getProductById(widget.productId)
                                          .additionalPrice -=
                                      subsOrderController.orderList.values
                                          .elementAt(widget.orderIndex)
                                          .getProductById(widget.productId)
                                          .productOptions![
                                              widget.indexProductOption]
                                          .productOptionDetails![
                                              widget.indexProductOptionDetail]
                                          .addtionalPrice!;
                                  // cateringProductController.totalPrices();
                                }
                                subsOrderController.orderList.refresh();
                                // cateringProductController.products.refresh();
                                // print("DEBUG ${cateringProductController.products[widget.indexProduct].productOptions![widget.indexProduct].productOptionDetails![widget.indexProductOptionDetail].isSelected}");
                              },
                            ),
                            height: 25,
                            width: 25,
                          );
                        })
                      ],
                    )
                  ],
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
