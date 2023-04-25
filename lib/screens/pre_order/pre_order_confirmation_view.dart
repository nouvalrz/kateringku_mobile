import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:kateringku_mobile/base/show_custom_snackbar.dart';
import 'package:kateringku_mobile/constants/image_path.dart';
import 'package:kateringku_mobile/controllers/cart_controller.dart';
import 'package:kateringku_mobile/controllers/customer_address_controller.dart';
import 'package:kateringku_mobile/controllers/instant_confirmation_controller.dart';
import 'package:kateringku_mobile/controllers/pre_order_controller.dart';
import 'package:kateringku_mobile/data/api/api_client.dart';
import 'package:kateringku_mobile/data/repositories/instant_confirmation_repo.dart';
import 'package:kateringku_mobile/models/add_cart_body.dart';
import 'package:kateringku_mobile/models/cart_model.dart';
import 'package:kateringku_mobile/models/catering_product_model.dart';
import 'package:kateringku_mobile/models/new_cart_model.dart';
import 'package:kateringku_mobile/models/product_model.dart';
import 'package:kateringku_mobile/screens/home/home_view.dart';

import '../../components/primary_button.dart';
import '../../constants/app_constant.dart';
import '../../constants/vector_path.dart';
import '../../helpers/currency_format.dart';
import '../../routes/route_helper.dart';
import '../../themes/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

class PreOrderConfirmationView extends StatefulWidget {
  bool? fromCart;

  PreOrderConfirmationView({Key? key, this.fromCart = false}) : super(key: key);

  @override
  State<PreOrderConfirmationView> createState() =>
      _PreOrderConfirmationViewState();
}

class _PreOrderConfirmationViewState extends State<PreOrderConfirmationView> {
  var preOrderController = Get.find<PreOrderController>();
  late NewCartModel stateCart;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id');
    var state = Get.arguments;
    var allOrderList = state[0];
    var cateringId = state[1];
    var cateringLatitude = state[2];
    var cateringLongitude = state[3];
    stateCart = state[4];

    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    preOrderController.preOrderModel.value.orderProducts = allOrderList;
    preOrderController.cateringId = cateringId;
    preOrderController.cateringLatitude = cateringLatitude;
    preOrderController.cateringLongitude = cateringLongitude;

    preOrderController.deliveryDateTime = Rxn<DateTime>();

    preOrderController.onInit();
    preOrderController.getDeliveryTimeRange();
    EasyLoading.dismiss();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<CustomerAddressController>();
  }

  @override
  Widget build(BuildContext context) {
    var cartController = Get.find<CartController>();

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 46),
                child: Container(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text("Konfirmasi Pesanan Pre Order",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w600))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 29,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Alamat Pengantaran",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                              SizedBox(
                                height: 12,
                              ),
                              GestureDetector(
                                onTap: () {
                                  preOrderController.setSelectedAddress(
                                      preOrderController.currentAddress!, true);
                                  preOrderController.recalculatePrice();
                                },
                                child: Row(
                                  children: [
                                    Expanded(child: Obx(() {
                                      return Container(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 25,
                                            ),
                                            Icon(Icons.location_on_outlined,
                                                color: (() {
                                                  // your code here
                                                  if (preOrderController
                                                      .isCurrentAddress.value) {
                                                    return AppTheme
                                                        .primaryGreen;
                                                  } else {
                                                    return Colors.grey;
                                                  }
                                                }())),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Column(
                                              children: [
                                                Text("Gunakan Lokasi Saat Ini",
                                                    style: AppTheme
                                                        .textTheme.titleLarge!
                                                        .copyWith(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                Obx(() {
                                                  if (preOrderController
                                                      .isLoading.value) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 2),
                                                      child: SizedBox(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: AppTheme
                                                              .primaryGreen,
                                                          strokeWidth: 2,
                                                        ),
                                                        height: 12,
                                                        width: 12,
                                                      ),
                                                    );
                                                  } else {
                                                    return Text(
                                                        preOrderController
                                                            .currentAddress!
                                                            .address!,
                                                        style: AppTheme
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400));
                                                  }
                                                })
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                            )
                                          ],
                                        ),
                                        height: 65,
                                        decoration: BoxDecoration(
                                            border: (() {
                                              // your code here
                                              if (preOrderController
                                                  .isCurrentAddress.value) {
                                                return Border.all(
                                                    color:
                                                        AppTheme.primaryGreen);
                                              } else {
                                                return Border.all(
                                                    color: Colors.grey);
                                              }
                                            }()),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      );
                                    })),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(RouteHelper.getAddressList());
                                },
                                child: Row(
                                  children: [
                                    Expanded(child: Obx(() {
                                      return Container(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 25,
                                            ),
                                            Icon(Icons.map_outlined,
                                                color: (() {
                                                  // your code here
                                                  if (!preOrderController
                                                      .isCurrentAddress.value) {
                                                    return AppTheme
                                                        .primaryGreen;
                                                  } else {
                                                    return Colors.grey;
                                                  }
                                                }())),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Column(
                                              children: [
                                                Text("Pakai Alamat Lain",
                                                    style: AppTheme
                                                        .textTheme.titleLarge!
                                                        .copyWith(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                if (!preOrderController
                                                    .isCurrentAddress.value)
                                                  Text(
                                                      preOrderController
                                                          .customAddress!
                                                          .value
                                                          .address!,
                                                      style: AppTheme
                                                          .textTheme.titleLarge!
                                                          .copyWith(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                            )
                                          ],
                                        ),
                                        height: 65,
                                        decoration: BoxDecoration(
                                            border: (() {
                                              // your code here
                                              if (!preOrderController
                                                  .isCurrentAddress.value) {
                                                return Border.all(
                                                    color:
                                                        AppTheme.primaryGreen);
                                              } else {
                                                return Border.all(
                                                    color: Colors.grey);
                                              }
                                            }()),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      );
                                    })),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Divider(
                          color: Colors.grey[200],
                          thickness: 10,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 25, right: 25, top: 12),
                          child: Column(
                            children: [
                              Text("Jadwal Pengantaran",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      preOrderController.chooseDate();
                                    },
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.calendar_today_outlined,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Obx(() {
                                                if (preOrderController
                                                        .deliveryDateTime
                                                        .value ==
                                                    null) {
                                                  return Text("Atur Tanggal",
                                                      style: AppTheme
                                                          .textTheme.titleLarge!
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400));
                                                } else {
                                                  return Text(
                                                      DateFormat.MMMMEEEEd('id')
                                                          .format(
                                                              preOrderController
                                                                  .deliveryDateTime
                                                                  .value!),
                                                      style: AppTheme
                                                          .textTheme.titleLarge!
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400));
                                                }
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: VerticalDivider(
                                      color: Colors.grey[300],
                                      thickness: 1,
                                    ),
                                    height: 40,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      preOrderController.chooseTime();
                                    },
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.access_time,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Obx(() {
                                                if (preOrderController
                                                            .deliveryDateTime
                                                            .value
                                                            ?.hour ==
                                                        null ||
                                                    preOrderController
                                                            .deliveryDateTime
                                                            .value
                                                            ?.hour ==
                                                        0) {
                                                  return Text("Atur Waktu",
                                                      style: AppTheme
                                                          .textTheme.titleLarge!
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400));
                                                } else {
                                                  return Text(
                                                      DateFormat.Hm().format(
                                                          preOrderController
                                                              .deliveryDateTime
                                                              .value!),
                                                      style: AppTheme
                                                          .textTheme.titleLarge!
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400));
                                                }
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Divider(
                          color: Colors.grey[200],
                          thickness: 10,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 25, right: 25, bottom: 16),
                          child: Row(
                            children: [
                              Text("Pesanan Anda",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Text("Ubah",
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500)),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                        ),
                        if (widget.fromCart!)
                          Obx(() => false
                              ? Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  itemBuilder: (context, index) {
                                    return ProductCard(
                                      productName: preOrderController
                                          .preOrderModel
                                          .value
                                          .orderProducts![index]
                                          .name!,
                                      productDesc: preOrderController
                                          .preOrderModel
                                          .value
                                          .orderProducts![index]
                                          .description!,
                                      productImage: preOrderController
                                          .preOrderModel
                                          .value
                                          .orderProducts![index]
                                          .originalPath!,
                                      productPrice: preOrderController
                                          .preOrderModel
                                          .value
                                          .orderProducts![index]
                                          .fixPrice(),
                                      productQuantity: preOrderController
                                          .preOrderModel
                                          .value
                                          .orderProducts![index]
                                          .orderQuantity!,
                                    );
                                  },
                                  itemCount: preOrderController.preOrderModel
                                      .value.orderProducts!.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(top: 4),
                                ))
                        else
                          ListView.builder(
                            itemBuilder: (context, index) {
                              return ProductCard(
                                productName: preOrderController.preOrderModel
                                    .value.orderProducts![index].name!,
                                productDesc: preOrderController.preOrderModel
                                    .value.orderProducts![index].description!,
                                productImage: preOrderController.preOrderModel
                                    .value.orderProducts![index].originalPath!,
                                productPrice: preOrderController
                                    .preOrderModel.value.orderProducts![index]
                                    .fixPrice(),
                                productQuantity: preOrderController
                                    .preOrderModel
                                    .value
                                    .orderProducts![index]
                                    .orderQuantity!,
                              );
                            },
                            itemCount: preOrderController
                                .preOrderModel.value.orderProducts!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(top: 4),
                          ),
                        Divider(
                          color: Colors.grey[200],
                          thickness: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25, right: 25, bottom: 16, top: 14),
                          child: Text("Ringkasan Pembayaran",
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Subtotal Harga",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300)),
                              Obx(() {
                                if (preOrderController.isLoading.value) {
                                  return Text("...");
                                } else {
                                  return Text(
                                      CurrencyFormat.convertToIdr(
                                          preOrderController.preOrderModel.value
                                              .subTotalPrice,
                                          0),
                                      style: AppTheme.textTheme.titleLarge!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400));
                                }
                              })
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Ongkos Kirim",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300)),
                              Obx(() => preOrderController.isLoading.value
                                  ? Text("...")
                                  : preOrderController.preOrderModel.value
                                              .deliveryPrice ==
                                          null
                                      ? Text("!")
                                      : Text(
                                          CurrencyFormat.convertToIdr(
                                              preOrderController.preOrderModel
                                                  .value.deliveryPrice!,
                                              0),
                                          style: AppTheme.textTheme.titleLarge!
                                              .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400)))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Harga",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                              Obx(() => preOrderController.isLoading.value
                                  ? Text("...")
                                  : preOrderController
                                              .preOrderModel.value.totalPrice ==
                                          null
                                      ? Text("!")
                                      : Text(
                                          CurrencyFormat.convertToIdr(
                                              preOrderController.preOrderModel
                                                  .value.totalPrice,
                                              0),
                                          style: AppTheme.textTheme.titleLarge!
                                              .copyWith(
                                                  fontSize: 13,
                                                  fontWeight:
                                                      FontWeight.w600))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 36,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 72,
              )
            ],
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
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text("Total Harga",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400)),
                              SizedBox(
                                height: 1,
                              ),
                              Obx(() => preOrderController.isLoading.value
                                  ? Text("...")
                                  : preOrderController
                                              .preOrderModel.value.totalPrice ==
                                          null
                                      ? Text("Anda perlu tambah alamat!",
                                          style: AppTheme.textTheme.titleLarge!
                                              .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600))
                                      : Text(
                                          CurrencyFormat.convertToIdr(
                                              preOrderController.preOrderModel
                                                  .value.totalPrice,
                                              0),
                                          style: AppTheme.textTheme.titleLarge!
                                              .copyWith(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.w600))),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (preOrderController.isAllFilled()) {
                          preOrderController.postPreOrder();
                          if(stateCart != null){
                            preOrderController.deleteCart(stateCart.id!);
                          }
                        } else {
                          showCustomSnackBar(
                              message: "Isi Semua Data",
                              title: "Data Pesanan Belum Lengkap");
                        }
                      },
                      child: Obx(() {
                        return Container(
                          height: 72,
                          width: 150,
                          color: AppTheme.primaryOrange,
                          child: Center(
                            child: preOrderController.isLoadingPostPreOrder.value ? CircularProgressIndicator(color: Colors.white,) : Text("Pilih Pembayaran",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ),
                        );
                      }),
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
  String productName;
  String productDesc;
  int productPrice;
  String productImage;
  int productQuantity;

  ProductCard(
      {Key? key,
      required this.productDesc,
      required this.productImage,
      required this.productName,
      required this.productPrice,
      required this.productQuantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                        image: NetworkImage(
                            AppConstant.BASE_URL + productImage.substring(1))),
                  ),
                ),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(productName,
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      Text(productDesc,
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 11, fontWeight: FontWeight.w300)),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text(
                                    CurrencyFormat.convertToIdr(
                                        productPrice, 0),
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 32,
                                      height: 28,
                                      child: TextFormField(
                                          readOnly: true,
                                          initialValue:
                                              productQuantity.toString(),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(3),
                                          ],
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          style: AppTheme.textTheme.titleLarge!
                                              .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Divider(
              color: Colors.grey[300],
            ),
            SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }
}