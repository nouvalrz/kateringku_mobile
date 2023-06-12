import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/models/product_model.dart';

import '../../base/show_custom_snackbar.dart';
import '../../constants/app_constant.dart';
import '../../controllers/catering_home_controller.dart';
import '../../helpers/currency_format.dart';
import '../../themes/app_theme.dart';

class ProductOptionView extends StatefulWidget {
  const ProductOptionView({Key? key}) : super(key: key);

  @override
  State<ProductOptionView> createState() => _ProductOptionViewState();
}

class _ProductOptionViewState extends State<ProductOptionView> {
  var cateringProductController = Get.find<CateringHomeController>();
  late int index;

  @override
  void initState() {
    var state = Get.arguments;
    index = state[0];
  }

  Future<bool> _onWillPop() async {
    if (cateringProductController.products[index].isAllOptionFulfilled()) {
      return true;
    } else {
      showCustomSnackBar(
          message: "Harap isi pilihan yang wajib!", title: "BELUM TERPENUHI");
      return false;
    }
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
                  if (cateringProductController.products[index]
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
                        Text(cateringProductController.products[index].name!,
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
                  indexProduct: index,
                );
              },
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cateringProductController
                  .products[index].productOptions!.length,
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
                                        cateringProductController
                                            .products[index]
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
                      if (cateringProductController.products[index]
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
                        child: Text("Tambahkan ke Keranjang",
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
  var cateringProductController = Get.find<CateringHomeController>();
  late int index;
  @override
  void initState() {
    var state = Get.arguments;
    index = state[0];
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
                    imageUrl: cateringProductController.products[index].image!,
                  ),
                ),
              ),
              SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(cateringProductController.products[index].name!,
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
                                          cateringProductController
                                              .products[index].price,
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
                                          cateringProductController
                                              .products[index].totalSales
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
  int indexProduct;
  int indexProductOption;
  ProductOptionChoice(
      {Key? key, required this.indexProductOption, required this.indexProduct})
      : super(key: key);

  @override
  State<ProductOptionChoice> createState() => _ProductOptionChoiceState();
}

class _ProductOptionChoiceState extends State<ProductOptionChoice> {
  var cateringProductController = Get.find<CateringHomeController>();
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
                    cateringProductController.products[widget.indexProduct]
                        .productOptions![widget.indexProductOption].optionName!,
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 4,
                ),
                Text(
                    cateringProductController.products[widget.indexProduct]
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
                indexProduct: widget.indexProduct,
                indexProductOption: widget.indexProductOption,
                indexProductOptionDetail: indexProductOptionDetail,
              );
            },
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cateringProductController
                .products[widget.indexProduct]
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
  int indexProduct;
  int indexProductOption;
  int indexProductOptionDetail;
  ProductOptionDetail(
      {Key? key,
      required this.indexProduct,
      required this.indexProductOption,
      required this.indexProductOptionDetail})
      : super(key: key);

  @override
  State<ProductOptionDetail> createState() => _ProductOptionDetailState();
}

class _ProductOptionDetailState extends State<ProductOptionDetail> {
  var cateringProductController = Get.find<CateringHomeController>();
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
                        cateringProductController
                            .products[widget.indexProduct]
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
                        if (cateringProductController
                                .products[widget.indexProduct]
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
                                      cateringProductController
                                          .products[widget.indexProduct]
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
                              value: cateringProductController
                                  .products[widget.indexProduct]
                                  .productOptions![widget.indexProductOption]
                                  .productOptionDetails![
                                      widget.indexProductOptionDetail]
                                  .isSelected,
                              onChanged: (value) {
                                cateringProductController.products.refresh();
                                if (value!) {
                                  if (cateringProductController
                                      .products[widget.indexProduct]
                                      .productOptions![
                                          widget.indexProductOption]
                                      .isOptionMax()) {
                                    return;
                                  }
                                  cateringProductController
                                      .products[widget.indexProduct]
                                      .productOptions![
                                          widget.indexProductOption]
                                      .productOptionDetails![
                                          widget.indexProductOptionDetail]
                                      .isSelected = value!;
                                  cateringProductController
                                      .products[widget.indexProduct]
                                      .productOptions![
                                          widget.indexProductOption]
                                      .selectedOption += 1;
                                  cateringProductController
                                          .products[widget.indexProduct]
                                          .additionalPrice +=
                                      cateringProductController
                                          .products[widget.indexProduct]
                                          .productOptions![
                                              widget.indexProductOption]
                                          .productOptionDetails![
                                              widget.indexProductOptionDetail]
                                          .addtionalPrice!;
                                  // cateringProductController.totalPrices();
                                } else {
                                  cateringProductController
                                      .products[widget.indexProduct]
                                      .productOptions![
                                          widget.indexProductOption]
                                      .selectedOption -= 1;
                                  cateringProductController
                                      .products[widget.indexProduct]
                                      .productOptions![
                                          widget.indexProductOption]
                                      .productOptionDetails![
                                          widget.indexProductOptionDetail]
                                      .isSelected = value!;
                                  cateringProductController
                                          .products[widget.indexProduct]
                                          .additionalPrice -=
                                      cateringProductController
                                          .products[widget.indexProduct]
                                          .productOptions![
                                              widget.indexProductOption]
                                          .productOptionDetails![
                                              widget.indexProductOptionDetail]
                                          .addtionalPrice!;
                                  // cateringProductController.totalPrices();
                                }
                                cateringProductController.products.refresh();
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
