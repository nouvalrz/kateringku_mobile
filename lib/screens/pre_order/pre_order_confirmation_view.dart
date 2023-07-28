import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
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
import 'package:kateringku_mobile/controllers/profile_controller.dart';
import 'package:kateringku_mobile/data/api/api_client.dart';
import 'package:kateringku_mobile/data/repositories/instant_confirmation_repo.dart';
import 'package:kateringku_mobile/models/add_cart_body.dart';
import 'package:kateringku_mobile/models/cart_model.dart';
import 'package:kateringku_mobile/models/catering_display_model.dart';
import 'package:kateringku_mobile/models/catering_product_model.dart';
import 'package:kateringku_mobile/models/new_cart_model.dart';
import 'package:kateringku_mobile/models/product_model.dart';
import 'package:kateringku_mobile/screens/home/home_view.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
  var profileContreoller = Get.find<ProfileController>();
  late NewCartModel stateCart;
  late List<Discount> discountList;

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
    discountList = state[5] ?? null;
    var cateringDeliveryCost = state[6];
    var cateringMinDistanceDelivery = state[7];

    // EasyLoading.show(
    //   status: 'Loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );

    preOrderController.preOrderModel.value.orderProducts = allOrderList;
    preOrderController.cateringId = cateringId;
    preOrderController.cateringLatitude = cateringLatitude;
    preOrderController.cateringLongitude = cateringLongitude;
    preOrderController.preOrderModel.value.discountId = null;
    preOrderController.preOrderModel.value.discount = 0;
    preOrderController.preOrderModel.value.useBalance = 0;
    preOrderController.cateringDeliveryCost = cateringDeliveryCost;
    preOrderController.cateringMinDistanceDelivery =
        cateringMinDistanceDelivery;

    preOrderController.deliveryDateTime = Rxn<DateTime>();

    preOrderController.onInit();
    preOrderController.getDeliveryTimeRange();
  }

  void showModalDatePicker() async {
    await showModalBottomSheet(
        // isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        context: context,
        // isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Atur Tanggal",
                  style: AppTheme.textTheme.labelSmall!.copyWith(
                      color: AppTheme.primaryBlack,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
                Container(
                  height: 400,
                  child: SfDateRangePicker(
                    controller: preOrderController.datePickerController,
                    selectionColor: AppTheme.primaryOrange,
                    todayHighlightColor: AppTheme.primaryOrange,
                    showActionButtons: true,
                    view: DateRangePickerView.month,
                    minDate: DateTime.now().add(Duration(days: 3)),
                    onCancel: () {
                      Get.back();
                    },
                    maxDate: DateTime.now().add(Duration(days: 33)),
                    selectionMode: DateRangePickerSelectionMode.single,
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        blackoutDates:
                            preOrderController.blackoutDateForCalendar),
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs
                        dateRangePickerSelectionChangedArgs) {
                      // print(dateRangePickerSelectionChangedArgs);
                      if (dateRangePickerSelectionChangedArgs.value != null) {
                        preOrderController
                                .preOrderModel.value.deliveryDateTime =
                            dateRangePickerSelectionChangedArgs.value;
                        preOrderController.deliveryDateTime.value =
                            dateRangePickerSelectionChangedArgs.value;
                      }

                      // if (preOrderController.pickedDate != null &&
                      // pickedDate != preOrderModel.value.deliveryDateTime) {
                      // preOrderModel.value.deliveryDateTime = pickedDate;
                      // deliveryDateTime.value = pickedDate;
                      //
                      //               subsDateRange = DateTimeRange(
                      //                   start: DateTime.parse(
                      //                       dateRangePickerSelectionChangedArgs
                      //                           .value.startDate
                      //                           .toString()),
                      //                   end: DateTime.parse(
                      //                       dateRangePickerSelectionChangedArgs
                      //                           .value.endDate
                      //                           .toString()));
                    },
                    navigationDirection:
                        DateRangePickerNavigationDirection.horizontal,
                    onSubmit: (Object? value) {
                      if (preOrderController
                                  .preOrderModel.value.deliveryDateTime ==
                              null &&
                          preOrderController.deliveryDateTime.value == null) {
                        showCustomSnackBar(
                            message: "Isi periode terlebih dahulu",
                            title: "Periode masih kosong");
                      } else {
                        // subsOrderController.generateListOfOrder(subsDateRange!);
                        Get.back();
                        preOrderController.chooseTime();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
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
            physics: const BouncingScrollPhysics(),
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
                  const SizedBox(
                    height: 22,
                  ),
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ColorFiltered(
                          colorFilter: (() {
                            if (preOrderController.isDiscountUsable(
                                minimumSpend:
                                    discountList[index].minimumSpend!)) {
                              return const ColorFilter.mode(
                                  Colors.white, BlendMode.dst);
                            } else {
                              return const ColorFilter.matrix(<double>[
                                0.2126, 0.7152, 0.0722, 0, 0, //
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0, 0, 0, 1, 0,
                              ]);
                            }
                          }()),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Transform.translate(
                                    offset: const Offset(-6, 0.0),
                                    child: Container(
                                      child:
                                          SvgPicture.asset(ImagePath.discount),
                                      width: 62,
                                      height: 62,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          discountList[index].title!,
                                          style: AppTheme.textTheme.labelMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Diskon ${discountList[index].percentage}%\nMin. pembelian ${CurrencyFormat.convertToIdr(discountList[index].minimumSpend, 0)}\nMaks. diskon ${CurrencyFormat.convertToIdr(discountList[index].maximumDisc, 0)}",
                                              style: AppTheme
                                                  .textTheme.labelMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12),
                                            ),
                                            if (preOrderController
                                                .isDiscountUsable(
                                                    minimumSpend:
                                                        discountList[index]
                                                            .minimumSpend!))
                                              Obx(() {
                                                return Radio<int?>(
                                                    value:
                                                        discountList[index].id!,
                                                    groupValue:
                                                        preOrderController
                                                            .preOrderModel
                                                            .value
                                                            .discountId,
                                                    toggleable: true,
                                                    onChanged: (value) {
                                                      preOrderController
                                                          .preOrderModel
                                                          .value
                                                          .discountId = value;
                                                      if (value != null) {
                                                        preOrderController
                                                            .preOrderModel.value
                                                            .setDiscount(
                                                                discountModel:
                                                                    discountList[
                                                                        index]);
                                                      } else {
                                                        preOrderController
                                                            .preOrderModel.value
                                                            .setDiscount(
                                                                discountModel:
                                                                    discountList[
                                                                        index],
                                                                reset: true);
                                                      }
                                                      preOrderController
                                                          .preOrderModel
                                                          .refresh();
                                                    });
                                              })
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          "Berlaku s/d ${DateFormat('d MMMM', 'id').format(DateTime.parse(discountList[index].endDate!))}",
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
                              const Divider(
                                thickness: 0.3,
                                color: Colors.black12,
                              ),
                              const SizedBox(
                                height: 8,
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: discountList.length,
                    ),
                  )
                ],
              ),
            ),
          );
        });
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
                        const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                        const SizedBox(
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
              const SizedBox(
                height: 29,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                              const SizedBox(
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
                                            const SizedBox(
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
                                            const SizedBox(
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
                                                    return const Padding(
                                                      padding: EdgeInsets.only(
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
                                                                    .address!
                                                                    .length >
                                                                45
                                                            ? preOrderController
                                                                    .currentAddress!
                                                                    .address!
                                                                    .substring(
                                                                        0, 45) +
                                                                "..."
                                                            : preOrderController
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
                              const SizedBox(
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
                                            const SizedBox(
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
                                            const SizedBox(
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
                        const SizedBox(
                          height: 14,
                        ),
                        Divider(
                          color: Colors.grey[200],
                          thickness: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 12),
                          child: Column(
                            children: [
                              Text("Jadwal Pengantaran",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalDatePicker();
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
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
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
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
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
                        const SizedBox(
                          height: 14,
                        ),
                        Divider(
                          color: Colors.grey[200],
                          thickness: 8,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, bottom: 16),
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
                              ? const Center(child: CircularProgressIndicator())
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
                                          .image!,
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(top: 4),
                                ))
                        else
                          ListView.builder(
                            itemBuilder: (context, index) {
                              preOrderController
                                  .preOrderModel.value.orderProducts![index]
                                  .setProductOptionSummary();
                              return ProductCard(
                                productOptionSummary: preOrderController
                                            .preOrderModel
                                            .value
                                            .orderProducts![index]
                                            .productOptionSummary ==
                                        ""
                                    ? null
                                    : preOrderController
                                        .preOrderModel
                                        .value
                                        .orderProducts![index]
                                        .productOptionSummary,
                                productName: preOrderController.preOrderModel
                                    .value.orderProducts![index].name!,
                                productDesc: preOrderController.preOrderModel
                                    .value.orderProducts![index].description!,
                                productImage: preOrderController.preOrderModel
                                    .value.orderProducts![index].image!,
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
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(top: 4),
                          ),
                        Obx(() {
                          if (!preOrderController.isLoading.value &&
                              profileContreoller.profileModel!.balance != 0) {
                            return Column(
                              children: [
                                Divider(
                                  color: Colors.grey[200],
                                  thickness: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25, bottom: 16, top: 14),
                                  child: GestureDetector(
                                    onTap: () {
                                      preOrderController.useBalanceForPayment();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.black12)),
                                      height: 55,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 18,
                                              ),
                                              const Icon(
                                                Icons.wallet_rounded,
                                                color: AppTheme.primaryGreen,
                                              ),
                                              const SizedBox(
                                                width: 18,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Obx(() {
                                                    return Text(
                                                        (() {
                                                          if (preOrderController
                                                                  .preOrderModel
                                                                  .value
                                                                  .useBalance >
                                                              0) {
                                                            return "Saldo Digunakan";
                                                          } else {
                                                            return "Bayar dengan Saldo";
                                                          }
                                                        }()),
                                                        style: AppTheme
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500));
                                                  }),
                                                  Text(
                                                      "Saldo anda " +
                                                          CurrencyFormat.convertToIdr(
                                                              profileContreoller
                                                                  .profileModel!
                                                                  .balance,
                                                              0),
                                                      style: AppTheme
                                                          .textTheme.titleLarge!
                                                          .copyWith(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Obx(() {
                                                return Icon(
                                                  Icons
                                                      .check_circle_outline_rounded,
                                                  color: preOrderController
                                                              .preOrderModel
                                                              .value
                                                              .useBalance !=
                                                          0
                                                      ? AppTheme.primaryGreen
                                                      : Colors.black26,
                                                );
                                              }),
                                              const SizedBox(
                                                width: 18,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else
                            return Container();
                        }),
                        if (discountList.isNotEmpty)
                          Column(
                            children: [
                              Divider(
                                color: Colors.grey[200],
                                thickness: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, bottom: 16, top: 14),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalDiscounts();
                                  },
                                  child: Obx(() {
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.black12)),
                                      height: 55,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 18,
                                              ),
                                              const Icon(
                                                Icons.discount_rounded,
                                                color: AppTheme.primaryOrange,
                                              ),
                                              const SizedBox(
                                                width: 18,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      (() {
                                                        if (preOrderController
                                                                .preOrderModel
                                                                .value
                                                                .discount ==
                                                            0) {
                                                          return 'Gunakan Diskon';
                                                        } else {
                                                          return 'Diskon Berhasil Digunakan';
                                                        }
                                                      }()),
                                                      style: AppTheme
                                                          .textTheme.titleLarge!
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                  if (preOrderController
                                                          .preOrderModel
                                                          .value
                                                          .discount >
                                                      0)
                                                    Text(
                                                        preOrderController
                                                            .preOrderModel
                                                            .value
                                                            .discountName!,
                                                        style: AppTheme
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons
                                                    .arrow_circle_right_outlined,
                                                color: Colors.black26,
                                              ),
                                              const SizedBox(
                                                width: 18,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        Divider(
                          color: Colors.grey[200],
                          thickness: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, bottom: 16, top: 14),
                          child: Text("Ringkasan Pembayaran",
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
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
                                  return const Text("...");
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
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
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
                                  ? const Text("...")
                                  : preOrderController.preOrderModel.value
                                              .deliveryPrice ==
                                          null
                                      ? const Text("!")
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
                        const SizedBox(
                          height: 8,
                        ),
                        Obx(() {
                          if (preOrderController.preOrderModel.value.discount !=
                              0) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                right: 25,
                                bottom: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Diskon",
                                      style: AppTheme.textTheme.titleLarge!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300)),
                                  Obx(() => preOrderController.isLoading.value
                                      ? const Text("...")
                                      : preOrderController.preOrderModel.value
                                                  .deliveryPrice ==
                                              null
                                          ? const Text("!")
                                          : Text(
                                              "- ${CurrencyFormat.convertToIdr(preOrderController.preOrderModel.value.discount, 0)}",
                                              style: AppTheme
                                                  .textTheme.titleLarge!
                                                  .copyWith(
                                                      color:
                                                          AppTheme.primaryRed,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400)))
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                        Obx(() {
                          if (preOrderController
                                  .preOrderModel.value.useBalance !=
                              0) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                right: 25,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Pakai Saldo",
                                      style: AppTheme.textTheme.titleLarge!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300)),
                                  Obx(() => preOrderController.isLoading.value
                                      ? const Text("...")
                                      : preOrderController.preOrderModel.value
                                                  .deliveryPrice ==
                                              null
                                          ? const Text("!")
                                          : Text(
                                              "- ${CurrencyFormat.convertToIdr(preOrderController.preOrderModel.value.useBalance, 0)}",
                                              style: AppTheme
                                                  .textTheme.titleLarge!
                                                  .copyWith(
                                                      color:
                                                          AppTheme.primaryRed,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400)))
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                        const SizedBox(
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
                          padding: const EdgeInsets.only(
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
                                  ? const Text("...")
                                  : preOrderController
                                              .preOrderModel.value.totalPrice ==
                                          null
                                      ? const Text("!")
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
                        const SizedBox(
                          height: 36,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
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
                              const SizedBox(
                                height: 1,
                              ),
                              Obx(() => preOrderController.isLoading.value
                                  ? const Text("...")
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
                    const SizedBox(
                      width: 18,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (preOrderController.isAllFilled()) {
                          preOrderController.postPreOrder();
                          if (stateCart != null) {
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
                            child:
                                preOrderController.isLoadingPostPreOrder.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text("Pilih Pembayaran",
                                        style: AppTheme.textTheme.titleLarge!
                                            .copyWith(
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
  String? productOptionSummary;

  ProductCard(
      {Key? key,
      required this.productDesc,
      required this.productImage,
      required this.productName,
      required this.productPrice,
      required this.productQuantity,
      this.productOptionSummary})
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
                    child: FancyShimmerImage(
                      imageUrl: productImage,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(productName,
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 4,
                      ),
                      Text(productDesc,
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 11, fontWeight: FontWeight.w300)),
                      if (productOptionSummary != null)
                        Column(
                          children: [
                            SizedBox(
                              height: 2,
                            ),
                            Text("Kustom : " + productOptionSummary!,
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 11, fontWeight: FontWeight.w300)),
                          ],
                        ),
                      const SizedBox(
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
                                          decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
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
            const SizedBox(
              height: 8,
            ),
            Divider(
              color: Colors.grey[300],
            ),
            const SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }
}
