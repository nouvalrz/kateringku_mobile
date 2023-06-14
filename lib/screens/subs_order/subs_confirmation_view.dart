import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:kateringku_mobile/screens/subs_order/subs_set_period_view.dart';

import '../../constants/image_path.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/subs_order_controller.dart';
import '../../helpers/currency_format.dart';
import '../../models/catering_display_model.dart';
import '../../routes/route_helper.dart';
import '../../themes/app_theme.dart';

class SubsConfirmationView extends StatefulWidget {
  const SubsConfirmationView({Key? key}) : super(key: key);

  @override
  State<SubsConfirmationView> createState() => _SubsConfirmationViewState();
}

class _SubsConfirmationViewState extends State<SubsConfirmationView> {
  var subsOrderController = Get.find<SubsOrderController>();
  var profileContreoller = Get.find<ProfileController>();
  late List<Discount> discountList;
  @override
  void initState() {
    super.initState();
    subsOrderController.initConfirmation();
    discountList = Get.arguments["cateringDiscount"] ?? null;
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
                        return ColorFiltered(
                          colorFilter: (() {
                            if (subsOrderController.isDiscountUsable(
                                minimumSpend:
                                    discountList[index].minimumSpend!)) {
                              return ColorFilter.mode(
                                  Colors.white, BlendMode.dst);
                            } else {
                              return ColorFilter.matrix(<double>[
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
                                  Obx(() {
                                    return Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            discountList[index].title!,
                                            style: AppTheme
                                                .textTheme.labelMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Min. pembelian ${CurrencyFormat.convertToIdr(discountList[index].minimumSpend, 0)}\nMaks. diskon ${CurrencyFormat.convertToIdr(discountList[index].maximumDisc, 0)}",
                                                style: AppTheme
                                                    .textTheme.labelMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12),
                                              ),
                                              if (subsOrderController
                                                  .isDiscountUsable(
                                                      minimumSpend:
                                                          discountList[index]
                                                              .minimumSpend!))
                                                Obx(() {
                                                  return Radio<int?>(
                                                      value: discountList[index]
                                                          .id!,
                                                      groupValue:
                                                          subsOrderController
                                                                  .discountId
                                                                  .value ??
                                                              null,
                                                      toggleable: true,
                                                      onChanged: (value) {
                                                        subsOrderController
                                                            .discountId
                                                            .value = value;
                                                        if (value != null) {
                                                          subsOrderController
                                                              .setDiscount(
                                                                  discountModel:
                                                                      discountList[
                                                                          index]);
                                                        } else {
                                                          subsOrderController
                                                              .setDiscount(
                                                                  discountModel:
                                                                      discountList[
                                                                          index],
                                                                  reset: true);
                                                        }
                                                        subsOrderController
                                                            .discountId
                                                            .refresh();
                                                        // subsOrderController
                                                        //     .update();
                                                        // subsOrderController
                                                        //     .orderList
                                                        //     .refresh();
                                                      });
                                                })
                                              // })
                                            ],
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            "Berlaku s/d ${DateFormat('d MMMM', 'id').format(DateTime.parse(discountList[index].endDate!))}",
                                            style: AppTheme
                                                .textTheme.labelMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                          ),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      ),
                                    );
                                  }),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 46, bottom: 14),
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
                    Text("Konfirmasi Pesanan Berlangganan",
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w600))
                  ],
                ),
              ),
            ),
          ),
          Divider(
            thickness: 9,
            color: Colors.grey[200],
          ),
          SizedBox(
            height: 11,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Alamat Pengantaran",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            subsOrderController.setSelectedAddress(
                                subsOrderController.currentAddress!, true);
                            subsOrderController.recalculatePrice();
                          },
                          child: Obx(() {
                            return Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Icon(Icons.location_on_outlined,
                                          color: (() {
                                            // your code here
                                            if (subsOrderController
                                                .isCurrentAddress.value) {
                                              return AppTheme.primaryGreen;
                                            } else {
                                              return Colors.grey;
                                            }
                                            // return AppTheme.primaryGreen;
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
                                                          FontWeight.w500)),
                                          Obx(() {
                                            if (subsOrderController
                                                .isLoading.value) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: SizedBox(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color:
                                                        AppTheme.primaryGreen,
                                                    strokeWidth: 2,
                                                  ),
                                                  height: 12,
                                                  width: 12,
                                                ),
                                              );
                                            } else {
                                              return Text(
                                                  subsOrderController
                                                      .currentAddress!.address!,
                                                  style: AppTheme
                                                      .textTheme.titleLarge!
                                                      .copyWith(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w400));
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
                                        if (subsOrderController
                                            .isCurrentAddress.value) {
                                          return Border.all(
                                              color: AppTheme.primaryGreen);
                                        } else {
                                          return Border.all(color: Colors.grey);
                                        }
                                        // return Border.all(color: AppTheme.primaryGreen);
                                      }()),
                                      borderRadius: BorderRadius.circular(10)),
                                )),
                              ],
                            );
                          }),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteHelper.getAddressList(),
                                arguments: {"fromSubs": true});
                          },
                          child: Obx(() {
                            return Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Icon(Icons.map_outlined,
                                          color: (() {
                                            // your code here
                                            if (!subsOrderController
                                                .isCurrentAddress.value) {
                                              return AppTheme.primaryGreen;
                                            } else {
                                              return Colors.grey;
                                            }
                                            // return AppTheme.primaryGreen;
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
                                                          FontWeight.w500)),
                                          if (!subsOrderController
                                              .isCurrentAddress.value)
                                            Text(
                                                subsOrderController
                                                    .customAddress
                                                    .value
                                                    .address!,
                                                style: AppTheme
                                                    .textTheme.titleLarge!
                                                    .copyWith(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w400)),
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
                                        if (!subsOrderController
                                            .isCurrentAddress.value) {
                                          return Border.all(
                                              color: AppTheme.primaryGreen);
                                        } else {
                                          return Border.all(color: Colors.grey);
                                        }
                                        // return Border.all(color: AppTheme.primaryGreen);
                                      }()),
                                      borderRadius: BorderRadius.circular(10)),
                                )),
                              ],
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 9,
                    color: Colors.grey[200],
                  ),
                  //  SECTION PESANAN ANDA
                  Padding(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 12, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pesanan Anda",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                            Text("${subsOrderController.orderList.length} Hari",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w300)),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.grey,
                              size: 16,
                            ),
                            Text(
                                " ${subsOrderController.getDateRangeWording()} | ",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w400)),
                            Icon(
                              Icons.access_time,
                              color: Colors.grey,
                              size: 16,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                                DateFormat.Hm().format(subsOrderController
                                    .orderList.values.first.deliveryDateTime!),
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: OrderComponent(
                            orderIndex: index,
                            fromConfirmation: true,
                          ),
                        );
                      },
                      itemCount: subsOrderController.isListOrderExpand.value
                          ? subsOrderController.orderList.length
                          : 1,
                    );
                  }),
                  Obx(() {
                    return GestureDetector(
                      onTap: () {
                        subsOrderController.isListOrderExpand.value =
                            !subsOrderController.isListOrderExpand.value;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              subsOrderController.isListOrderExpand.value
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: AppTheme.primaryGreen,
                            ),
                            Text(
                                subsOrderController.isListOrderExpand.value
                                    ? "Tutup Pesanan"
                                    : "Lihat Semua Pesanan",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppTheme.primaryGreen))
                          ],
                        ),
                      ),
                    );
                  }),
                  Obx(() {
                    if (!subsOrderController.isLoading.value &&
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
                                subsOrderController.useBalanceForPayment();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black12)),
                                height: 55,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                                    if (subsOrderController
                                                            .useBalance.value >
                                                        0) {
                                                      return "Saldo Digunakan";
                                                    } else {
                                                      return "Bayar dengan Saldo";
                                                    }
                                                  }()),
                                                  style: AppTheme
                                                      .textTheme.titleLarge!
                                                      .copyWith(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500));
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
                                                            FontWeight.w400)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Obx(() {
                                          return Icon(
                                            Icons.check_circle_outline_rounded,
                                            color: subsOrderController
                                                        .useBalance.value !=
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
                          padding: EdgeInsets.only(
                              left: 25, right: 25, bottom: 16, top: 14),
                          child: GestureDetector(
                            onTap: () {
                              showModalDiscounts();
                            },
                            child: Obx(() {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black12)),
                                height: 55,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                (() {
                                                  if (subsOrderController
                                                          .discount.value ==
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
                                                            FontWeight.w500)),
                                            if (subsOrderController
                                                    .discount.value !=
                                                0)
                                              Text(
                                                  subsOrderController
                                                      .discountName!,
                                                  style: AppTheme
                                                      .textTheme.titleLarge!
                                                      .copyWith(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w300)),
                                          ],
                                        ),
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
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 4,
                  ),
                  Divider(
                    thickness: 9,
                    color: Colors.grey[200],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 8, bottom: 16),
                    child: Column(
                      children: [
                        Text("Ringkasan Pembayaran",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text("Subtotal Harga",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w300)),
                        Obx(() {
                          return Text(
                              CurrencyFormat.convertToIdr(
                                  subsOrderController.allTotalPrice.value, 0),
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w400));
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
                        Obx(() {
                          return Text(
                              "Ongkos Kirim (${((subsOrderController.deliveryPrice / subsOrderController.orderList.length) / 1000).toInt()}rb x${subsOrderController.orderList.length})",
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w300));
                        }),
                        Obx(() {
                          return Text(
                              CurrencyFormat.convertToIdr(
                                  subsOrderController.deliveryPrice.value, 0),
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w400));
                        })
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Obx(() {
                    if (subsOrderController.discount != 0) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 25, right: 25, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Diskon",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w300)),
                            Obx(() => subsOrderController.isLoading.value
                                ? Text("...")
                                : subsOrderController.deliveryPrice.value == 0
                                    ? Text("!")
                                    : Text(
                                        "- ${CurrencyFormat.convertToIdr(subsOrderController.discount.value, 0)}",
                                        style: AppTheme.textTheme.titleLarge!
                                            .copyWith(
                                                color: AppTheme.primaryRed,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400)))
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                  Obx(() {
                    if (subsOrderController.useBalance.value != 0) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Pakai Saldo",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w300)),
                            Obx(() => subsOrderController.isLoading.value
                                ? const Text("...")
                                : Text(
                                    "- ${CurrencyFormat.convertToIdr(subsOrderController.useBalance.value, 0)}",
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            color: AppTheme.primaryRed,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400)))
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                  // Obx(() {
                  //   if (preOrderController.preOrderModel.value.discount !=
                  //       0) {
                  //     return Padding(
                  //       padding: EdgeInsets.only(
                  //         left: 25,
                  //         right: 25,
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment:
                  //         MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text("Diskon",
                  //               style: AppTheme.textTheme.titleLarge!
                  //                   .copyWith(
                  //                   fontSize: 12,
                  //                   fontWeight: FontWeight.w300)),
                  //           Obx(() => preOrderController.isLoading.value
                  //               ? Text("...")
                  //               : preOrderController.preOrderModel.value
                  //               .deliveryPrice ==
                  //               null
                  //               ? Text("!")
                  //               : Text(
                  //               "- ${CurrencyFormat.convertToIdr(preOrderController.preOrderModel.value.discount, 0)}",
                  //               style: AppTheme
                  //                   .textTheme.titleLarge!
                  //                   .copyWith(
                  //                   color:
                  //                   AppTheme.primaryRed,
                  //                   fontSize: 12,
                  //                   fontWeight:
                  //                   FontWeight.w400)))
                  //         ],
                  //       ),
                  //     );
                  //   } else {
                  //     return Container();
                  //   }
                  // }),
                  // SizedBox(
                  //   height: 4,
                  // ),
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
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 13, fontWeight: FontWeight.w500)),
                        Obx(() => Text(
                            CurrencyFormat.convertToIdr(
                                subsOrderController.fixOrderPrice.value, 0),
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 13, fontWeight: FontWeight.w600))),
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
          SizedBox(
            height: 68,
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
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 11, fontWeight: FontWeight.w400)),
                            SizedBox(
                              height: 1,
                            ),
                            Obx(() {
                              return Text(
                                  CurrencyFormat.convertToIdr(
                                      subsOrderController.fixOrderPrice.value,
                                      0),
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600));
                            }),
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
                      onTap: () async {
                        await subsOrderController.createSubsOrder();
                        // if (preOrderController.isAllFilled()) {
                        //   preOrderController.postPreOrder();
                        //   if (stateCart != null) {
                        //     preOrderController.deleteCart(stateCart.id!);
                        //   }
                        // } else {
                        //   showCustomSnackBar(
                        //       message: "Isi Semua Data",
                        //       title: "Data Pesanan Belum Lengkap");
                        // }
                      },
                      child: Container(
                        height: 68,
                        width: 150,
                        color: AppTheme.primaryOrange,
                        child: Center(child: Obx(() {
                          if (subsOrderController
                              .isLoadingPostSubsOrder.value) {
                            return CircularProgressIndicator(
                              color: Colors.white,
                            );
                          } else {
                            return Text("Pilih Pembayaran",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white));
                          }
                        })),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
