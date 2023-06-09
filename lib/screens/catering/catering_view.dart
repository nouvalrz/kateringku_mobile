import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:kateringku_mobile/base/no_glow.dart';
import 'package:kateringku_mobile/constants/vector_path.dart';
import 'package:kateringku_mobile/controllers/catering_home_controller.dart';
import 'package:kateringku_mobile/data/repositories/catering_product_repo.dart';
import 'package:kateringku_mobile/models/new_cart_model.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../base/show_custom_snackbar.dart';
import '../../components/primary_button.dart';
import '../../constants/app_constant.dart';
import '../../constants/image_path.dart';
import '../../data/api/api_client.dart';
import '../../helpers/currency_format.dart';
import '../../models/catering_display_model.dart';
import '../../routes/route_helper.dart';
import 'package:intl/date_symbol_data_local.dart';

class CateringView extends StatefulWidget {
  String catering_id;
  String catering_name;
  String catering_location;
  String catering_image;
  double catering_latitude;
  double catering_longitude;
  String fromCart;

  CateringView(
      {Key? key,
      required this.catering_name,
      required this.catering_location,
      required this.catering_image,
      required this.catering_id,
      required this.catering_latitude,
      required this.catering_longitude,
      this.fromCart = "false"})
      : super(key: key);

  @override
  State<CateringView> createState() => _CateringViewState();
}

class _CateringViewState extends State<CateringView> {
  var cateringProductController = Get.find<CateringHomeController>();
  late CateringDisplayModel cateringModel;
  late NewCartModel stateCart;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id');
    var state = Get.arguments[0];
    cateringModel = state;
    cateringProductController
        .getCateringProducts(cateringModel.id.toString())
        .then((value) {
      if (widget.fromCart == "true") {
        stateCart = Get.arguments[1];
        stateCart.cartDetails!.asMap().forEach((index, cartDetail) {
          cateringProductController.products.value
              .asMap()
              .forEach((index, product) {
            if (product.id == cartDetail.productId) {
              for (var i = 0; i < cartDetail!.quantity!; i++) {
                cateringProductController.addProductQuantity(index,
                    fromCart: true);
              }
              if (cartDetail.productOptions!.length > 0) {
                cartDetail.productOptions!.forEach((cartOption) {
                  product.productOptions!.forEach((productOption) {
                    productOption.productOptionDetails!
                        .forEach((productOptionDetail) {
                      if (cartOption.productOptionDetailId ==
                          productOptionDetail.id) {
                        productOptionDetail.isSelected = true;
                        productOption.selectedOption += 1;
                        product.additionalPrice +=
                            productOptionDetail.addtionalPrice!;
                        // cateringProductController.products.refresh();
                      }
                    });
                  });
                });
              }
              cateringProductController.totalPrices();
              cateringProductController.products.refresh();
            }
          });
        });
        // cateringProductController.products.refresh();
      }
    });
    cateringProductController.totalPrice.value = 0;
    cateringProductController.totalQuantity.value = 0;
    cateringProductController.cateringId = cateringModel.id.toString();
  }

  Widget reviewBadge({double? cateringRate}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
        child: Row(
          children: [
            Icon(
              Icons.star,
              color: AppTheme.primaryOrange,
              size: 12,
            ),
            if (cateringRate == null)
              Text("-",
                  style: AppTheme.textTheme.labelMedium!
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 11))
            else
              Text(cateringRate!.toStringAsFixed(1),
                  style: AppTheme.textTheme.labelMedium!
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 11))
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.greyOutline, width: 0.5),
          borderRadius: BorderRadius.circular(100)),
    );
  }

  void showModalDiscounts() async {
    await showModalBottomSheet(
        // isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "Semua Diskon",
                        style: AppTheme.textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Transform.translate(
                                  offset: const Offset(-6, 0.0),
                                  child: Container(
                                    child: SvgPicture.asset(ImagePath.discount),
                                    width: 62,
                                    height: 62,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        cateringModel.discounts![index].title!,
                                        style: AppTheme.textTheme.labelMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        "Min. pembelian ${CurrencyFormat.convertToIdr(cateringModel.discounts![index].minimumSpend, 0)}\nMaks. diskon ${CurrencyFormat.convertToIdr(cateringModel.discounts![index].maximumDisc, 0)}",
                                        style: AppTheme.textTheme.labelMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        "Berlaku s/d ${DateFormat('d MMMM', 'id').format(DateTime.parse(cateringModel.discounts![index].endDate!))}",
                                        style: AppTheme.textTheme.labelMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                      ),
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 0.3,
                              color: Colors.black12,
                            ),
                            SizedBox(
                              height: 8,
                            )
                          ],
                        );
                      },
                      itemCount: cateringModel.discounts!.length,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: SizedBox(
              height: 8,
              child: Container(
                color: Colors.grey[200],
                width: 600,
              ),
            ),
            top: 220,
          ),
          Align(
            child: SvgPicture.asset(VectorPath.greenRadial),
            alignment: Alignment.topRight,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 38, left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FancyShimmerImage(
                                imageUrl: cateringModel!.image!),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    cateringModel.name!,
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(cateringModel.mergeCategories(),
                                      style: AppTheme.textTheme.titleLarge!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400)),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Transform.translate(
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.grey[600],
                                          size: 20,
                                        ),
                                        offset: const Offset(-3, 0),
                                      ),
                                      Text(
                                        cateringModel
                                            .village!.name!.capitalize!,
                                        style: AppTheme.textTheme.labelSmall!
                                            .copyWith(fontSize: 11),
                                      ),
                                      SizedBox(
                                        child: VerticalDivider(
                                          color: Colors.grey[500],
                                          thickness: 0.7,
                                        ),
                                        height: 16,
                                      ),
                                      Text(
                                        "Terjual ${cateringModel.totalSales}",
                                        style: AppTheme.textTheme.labelSmall!
                                            .copyWith(fontSize: 11),
                                      ),
                                      SizedBox(
                                        child: VerticalDivider(
                                          color: Colors.grey[500],
                                          thickness: 0.7,
                                        ),
                                        height: 16,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (cateringModel.rate != null) {
                                            Get.toNamed(
                                                RouteHelper.cateringReview,
                                                arguments: {
                                                  "cateringId":
                                                      cateringModel.id!,
                                                  "cateringName":
                                                      cateringModel.name!
                                                });
                                          }
                                        },
                                        child: reviewBadge(
                                            cateringRate:
                                                cateringModel.rate ?? null),
                                      )
                                    ],
                                  ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // SizedBox(
                                  //   child: PrimaryButton(
                                  //     title: "Pesan Langganan",
                                  //     onTap: () {},
                                  //     titleStyle: AppTheme.textTheme.titleLarge!
                                  //         .copyWith(
                                  //             fontSize: 13,
                                  //             fontWeight: FontWeight.w600,
                                  //             color: Colors.white),
                                  //   ),
                                  //   width: 175,
                                  //   height: 44,
                                  // )
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(RouteHelper.chat, arguments: {
                                  "cateringId": cateringModel.id.toString(),
                                  "cateringName": cateringModel.name,
                                  "cateringImage": cateringModel.image!
                                });
                              },
                              child: Container(
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.message_outlined,
                                    color: AppTheme.primaryGreen,
                                    size: 18,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: AppTheme.primaryGreen),
                                    borderRadius: BorderRadius.circular(7)),
                              ),
                            )
                          ],
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.subsSetPeriod, arguments: {
                          "cateringId": cateringModel.id!,
                          "cateringLatitude": cateringModel.latitude,
                          "cateringLongitude": cateringModel.longitude,
                          "cateringDiscount": cateringModel.discounts,
                          "cateringDeliveryCost": cateringModel.deliveryCost,
                          "cateringMinDistanceDelivery":
                              cateringModel.minDistanceDelivery
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: AppTheme.primaryGreen,
                                borderRadius: BorderRadius.circular(9),
                                border:
                                    Border.all(color: AppTheme.primaryGreen)),
                            child: Row(),
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(9),
                                      border: Border.all(
                                          color: AppTheme.primaryGreen)),
                                  height: 60,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            "Mau pesanan berlangganan dan terjadwal? Klik Ini",
                                            style: AppTheme
                                                .textTheme.labelSmall!
                                                .copyWith(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          const Icon(
                                            Icons.calendar_today_outlined,
                                            color: Colors.black54,
                                            size: 16,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            "Pesan Berlangganan",
                                            style: AppTheme
                                                .textTheme.labelSmall!
                                                .copyWith(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 36,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (cateringModel.discountsCount != 0)
                        GestureDetector(
                          onTap: () {
                            showModalDiscounts();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black12)),
                            height: 55,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 18,
                                    ),
                                    Icon(
                                      Icons.discount_rounded,
                                      color: AppTheme.primaryOrange,
                                    ),
                                    SizedBox(
                                      width: 18,
                                    ),
                                    Text(
                                        'Lihat Ada ${cateringModel.discountsCount} Diskon untuk kamu',
                                        style: AppTheme.textTheme.titleLarge!
                                            .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_circle_right_outlined,
                                      color: Colors.black26,
                                    ),
                                    SizedBox(
                                      width: 18,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text('Produk Katering',
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(
                        height: 13,
                      ),
                      Obx(
                        () => cateringProductController.isLoading.value
                            ? Center(
                                child: LoadingAnimationWidget.prograssiveDots(
                                    color: AppTheme.primaryGreen, size: 50),
                              )
                            : ScrollConfiguration(
                                behavior: NoGlow(),
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return ProductCard(
                                        product_desc: cateringProductController
                                            .products[index].description!,
                                        product_image: cateringProductController
                                            .products[index].image!,
                                        product_name: cateringProductController
                                            .products[index].name!,
                                        product_price: cateringProductController
                                            .products[index]
                                            .fixPrice()
                                            .toString(),
                                        total_sales: cateringProductController
                                            .products[index].totalSales!
                                            .toString(),
                                        index: index,
                                        product_is_customable:
                                            cateringProductController
                                                .products[index]
                                                .isProductCustomable(),
                                      );
                                    },
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cateringProductController
                                        .products.value.length,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(
                  height: 72,
                )
              ],
            ),
          ),
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
                        children: [
                          Column(
                            children: [
                              Obx(
                                () => Text(
                                    CurrencyFormat.convertToIdr(
                                        cateringProductController
                                            .totalPrice.value,
                                        0),
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500)),
                              ),
                              Obx(
                                () => Text(
                                    cateringProductController
                                            .totalQuantity.value
                                            .toString() +
                                        " Item",
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w300)),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (cateringProductController.totalQuantity.value ==
                            0) {
                          showCustomSnackBar(
                              message: "Tambahkan produk terlebih dahulu",
                              title: "Produk Kosong!");
                        } else {
                          return await showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 400,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 16,
                                        top: 20,
                                        bottom: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  "Konfirmasi Pesanan",
                                                  style: AppTheme
                                                      .textTheme.labelMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                // Get.back();
                                                // Get.offAllNamed(RouteHelper.getMainHome());
                                                Get.until((route) =>
                                                    Get.currentRoute ==
                                                    RouteHelper.mainHome);
                                                // Get.back();
                                              },
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8,
                                                          bottom: 8,
                                                          left: 14,
                                                          right: 14),
                                                  child: Text(
                                                    "Batalkan Pesanan",
                                                    style: AppTheme
                                                        .textTheme.labelMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                              ),
                                            )
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Container(
                                          child: SvgPicture.asset(
                                              ImagePath.addToCart),
                                          width: 250,
                                          height: 200,
                                        ),
                                        Text(
                                          "Yah, anda belum menyelesaikan pesanan...\nIngin menyimpan ke Keranjang?",
                                          textAlign: TextAlign.center,
                                          style: AppTheme.textTheme.labelMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Container(
                                                child: Center(
                                                  child: Text(
                                                    "Ubah\nPesanan",
                                                    textAlign: TextAlign.center,
                                                    style: AppTheme
                                                        .textTheme.labelMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                            color: AppTheme
                                                                .primaryGreen),
                                                  ),
                                                ),
                                                width: 120,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: AppTheme
                                                          .primaryGreen),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                              child: Obx(() {
                                                return PrimaryButton(
                                                    title:
                                                        'Simpan ke Keranjang',
                                                    onTap: () {
                                                      cateringProductController
                                                          .postCart();
                                                      // var product_list = <ProductForCart>[];
                                                      // allOrderList.forEach((element) {
                                                      //   ProductForCart product = ProductForCart(
                                                      //       product_id: element.product_id,
                                                      //       quantity: element.quantity);
                                                      //   product_list.add(product);
                                                      // });
                                                      // AddCartBody addCartBody = AddCartBody(
                                                      //     catering_id: cateringId.toString(),
                                                      //     product_list: product_list);
                                                      // cartController.saveCart(addCartBody);
                                                    },
                                                    state:
                                                        cateringProductController
                                                                .isCartLoading
                                                                .value
                                                            ? ButtonState
                                                                .loading
                                                            : ButtonState.idle);
                                              }),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                      child: Container(
                        height: 72,
                        width: 72,
                        color: AppTheme.primaryGreen,
                        child: const Center(
                            child: Icon(
                          Icons.add_shopping_cart_rounded,
                          color: Colors.white,
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (cateringProductController.totalQuantity == 0) {
                          showCustomSnackBar(
                              message: "Harap memilih minimal 1 produk",
                              title: "ORDER KOSONG");
                        } else {
                          var allOrderList =
                              cateringProductController.collectAllOrder();
                          Get.toNamed(RouteHelper.getInstantOrderConfirmation(),
                              arguments: [
                                allOrderList,
                                widget.catering_id,
                                widget.catering_latitude,
                                widget.catering_longitude,
                                widget.fromCart == "true" ? stateCart : null,
                                cateringModel.discounts
                              ]);
                        }
                      },
                      child: Container(
                        height: 72,
                        width: 150,
                        color: AppTheme.primaryOrange,
                        child: Center(
                          child: Text("Pesan Pre Order",
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
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  String product_name;
  String product_desc;
  String product_price;
  String product_image;
  String total_sales;
  bool product_is_customable;
  int index;

  ProductCard(
      {Key? key,
      required this.product_name,
      required this.product_desc,
      required this.product_image,
      required this.product_price,
      required this.product_is_customable,
      required this.total_sales,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cateringProductController = Get.find<CateringHomeController>();
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
                  child: FancyShimmerImage(imageUrl: product_image!),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(product_name,
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    Text(
                        product_desc.length > 32
                            ? '${product_desc.substring(0, 32)}...'
                            : product_desc,
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
                              Text(
                                  CurrencyFormat.convertToIdr(
                                      int.parse(product_price), 0),
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
                              Text("Terjual $total_sales",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                        Obx(() {
                          if (cateringProductController
                                  .products[index].orderQuantity ==
                              0) {
                            return GestureDetector(
                              onTap: () async {
                                if (cateringProductController.products[index]
                                    .isProductCustomable()) {
                                  await Get.toNamed(
                                      RouteHelper.getProductOption(),
                                      arguments: [index]);
                                  cateringProductController.totalPrices();
                                }
                                cateringProductController
                                    .addProductQuantity(index);
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
                                        onTap: () => cateringProductController
                                            .minusProductQuantity(index),
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
                                        child: Obx(
                                          () => TextFormField(
                                              key: Key(cateringProductController
                                                  .products[index].orderQuantity
                                                  .toString()),
                                              initialValue:
                                                  cateringProductController
                                                      .products[index]
                                                      .orderQuantity
                                                      .toString(),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    3),
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
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
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      GestureDetector(
                                        onTap: () => cateringProductController
                                            .addProductQuantity(index),
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
                                  if (cateringProductController
                                              .products[index].orderQuantity ==
                                          cateringProductController
                                              .products[index]
                                              .minimumQuantity! &&
                                      cateringProductController.products[index]
                                              .minimumQuantity! !=
                                          1)
                                    Text("Min. " + cateringProductController.products[index].minimumQuantity.toString(),
                                        style: AppTheme.textTheme.titleLarge!
                                            .copyWith(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300))
                                  else if (cateringProductController
                                          .products[index].orderQuantity >=
                                      cateringProductController
                                          .products[index].maximumQuantity!)
                                    Text("Max. " + cateringProductController.products[index].maximumQuantity.toString(),
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
                        if (cateringProductController.products[index]
                            .isProductCustomable())
                          GestureDetector(
                            onTap: () async {
                              await Get.toNamed(RouteHelper.getProductOption(),
                                  arguments: [index]);
                              cateringProductController.totalPrices();
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
                                  "Bisa Custom",
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
