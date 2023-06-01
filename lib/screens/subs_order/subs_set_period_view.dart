import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:kateringku_mobile/base/show_custom_snackbar.dart';
import 'package:kateringku_mobile/controllers/subs_order_controller.dart';
import 'package:kateringku_mobile/routes/route_helper.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../constants/app_constant.dart';
import '../../constants/vector_path.dart';
import '../../helpers/currency_format.dart';
import '../../models/catering_display_model.dart';
import '../../themes/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

class SubsSetPeriodView extends StatefulWidget {
  const SubsSetPeriodView({Key? key}) : super(key: key);

  @override
  State<SubsSetPeriodView> createState() => _SubsSetPeriodViewState();
}

class _SubsSetPeriodViewState extends State<SubsSetPeriodView> {
  var subsOrderController = Get.find<SubsOrderController>();
  DateTimeRange? subsDateRange;
  late int cateringId;
  late double cateringLatitude;
  late double cateringLongitude;
  late int cateringDeliveryCost;
  late int cateringMinDistanceDelivery;
  late List<Discount> discountList;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id');
    cateringId = Get.arguments["cateringId"];
    cateringLatitude = double.parse(Get.arguments["cateringLatitude"]);
    cateringLongitude = double.parse(Get.arguments["cateringLongitude"]);
    cateringDeliveryCost = Get.arguments["cateringDeliveryCost"];
    cateringMinDistanceDelivery = Get.arguments["cateringMinDistanceDelivery"];
    discountList = Get.arguments["cateringDiscount"] ?? null;
    subsOrderController.init(cateringId: cateringId);
    subsOrderController.cateringLatitude = cateringLatitude;
    subsOrderController.cateringLongitude = cateringLongitude;
    subsOrderController.cateringMinDistanceDelivery =
        cateringMinDistanceDelivery;
    subsOrderController.cateringDeliveryCost = cateringDeliveryCost;
    subsOrderController.cateringId = cateringId.toString();
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
                  "Atur Periode",
                  style: AppTheme.textTheme.labelSmall!.copyWith(
                      color: AppTheme.primaryBlack,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
                Container(
                  height: 400,
                  child: SfDateRangePicker(
                    controller: subsOrderController.datePickerController,
                    selectionColor: AppTheme.primaryOrange,
                    todayHighlightColor: AppTheme.primaryOrange,
                    showActionButtons: true,
                    view: DateRangePickerView.month,
                    minDate: DateTime.now().add(Duration(days: 1)),
                    onCancel: () {
                      Get.back();
                    },
                    maxDate: DateTime.now().add(Duration(days: 30)),
                    selectionMode: DateRangePickerSelectionMode.extendableRange,
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        blackoutDates:
                            subsOrderController.blackoutDateForCalendar),
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs
                        dateRangePickerSelectionChangedArgs) {
                      if (dateRangePickerSelectionChangedArgs.value.endDate !=
                          null) {
                        subsDateRange = DateTimeRange(
                            start: DateTime.parse(
                                dateRangePickerSelectionChangedArgs
                                    .value.startDate
                                    .toString()),
                            end: DateTime.parse(
                                dateRangePickerSelectionChangedArgs
                                    .value.endDate
                                    .toString()));
                      }
                    },
                    navigationDirection:
                        DateRangePickerNavigationDirection.vertical,
                    onSubmit: (Object? value) {
                      if (subsDateRange == null) {
                        showCustomSnackBar(
                            message: "Isi periode terlebih dahulu",
                            title: "Periode masih kosong");
                      } else {
                        subsOrderController.generateListOfOrder(subsDateRange!);
                        Get.back();
                        subsOrderController.chooseTime();
                      }
                    },
                  ),
                ),
              ],
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
        Container(
          decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          height: 170,
          child: Stack(
            children: [
              // Align(
              //   child: Transform.scale(
              //     child: SvgPicture.asset(
              //       VectorPath.orangeRadial,
              //     ),
              //     scaleY: -1,
              //     scaleX: -1,
              //   ),
              //   alignment: Alignment.topRight,
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 46),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              "Pesan Berlangganan",
                              style: AppTheme.textTheme.labelSmall!.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Atur Periode",
                          style: AppTheme.textTheme.labelSmall!.copyWith(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 4,
                              child: Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalDatePicker();
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Obx(() {
                                          return Text(
                                              subsOrderController.orderList
                                                      .value.isNotEmpty
                                                  ? subsOrderController
                                                      .getDateRangeWording()
                                                  : "Atur Tanggal",
                                              style: AppTheme
                                                  .textTheme.titleLarge!
                                                  .copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400));
                                        })
                                      ],
                                    ),
                                    height: 44,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppTheme.greyOutline)),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: GestureDetector(
                                  onTap: () {
                                    if (subsOrderController.orderList.isEmpty) {
                                      showCustomSnackBar(
                                          message:
                                              "Atur periode terlebih dahulu",
                                          title: "Periode masih kosong!");
                                    } else {
                                      subsOrderController.chooseTime();
                                    }
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Obx(() {
                                          return Text(
                                              subsOrderController
                                                      .orderList.isEmpty
                                                  ? "Atur Waktu"
                                                  : DateFormat.Hm().format(
                                                      subsOrderController
                                                          .orderList
                                                          .values
                                                          .first
                                                          .deliveryDateTime!),
                                              style: AppTheme
                                                  .textTheme.titleLarge!
                                                  .copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400));
                                        })
                                      ],
                                    ),
                                    height: 44,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppTheme.greyOutline)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),

                        // SizedBox(
                        //   height: 8,
                        // ),
                        // Text(
                        //   "Atur Jam Pengantaran",
                        //   style: AppTheme.textTheme.labelSmall!.copyWith(
                        //       color: Colors.white,
                        //       fontSize: 13,
                        //       fontWeight: FontWeight.w400),
                        // ),
                        // SizedBox(
                        //   height: 8,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(child: Obx(() {
          if (subsOrderController.isGenerateListOfOrderLoading.value) {
            return Center(
                child: Text("Atur Periode Dahulu",
                    style: AppTheme.textTheme.titleLarge!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryBlack)));
          } else {
            if (subsOrderController.orderList.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Pilih Produk",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryBlack)),
                        if (subsOrderController.isAnyFulfilled.value)
                          GestureDetector(
                            onTap: () {
                              subsOrderController.repeatOrder();
                            },
                            child: Text("Repeat Order",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.primaryBlack)),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: OrderComponent(orderIndex: index),
                          );
                        },
                        itemCount: subsOrderController.orderList.length,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                  child: Text("Atur Periode Dahulu",
                      style: AppTheme.textTheme.titleLarge!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryBlack)));
            }
          }
        })),
        SizedBox(
          height: 60,
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
                                    subsOrderController.allTotalPrice.value, 0),
                                // "Rp. 20.000",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 13, fontWeight: FontWeight.w500)),
                            Text(
                                subsOrderController.allTotalQuantity.value
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
                    if (subsOrderController.validateForm()) {
                      Get.toNamed(RouteHelper.subsConfirmationView,
                          arguments: {"cateringDiscount": discountList});
                    } else {
                      showCustomSnackBar(
                          message: "Lengkapi data pesanan terlebih dahulu",
                          title: "Data Pesanan Belum Lengkap");
                    }
                  },
                  child: Container(
                    height: 72,
                    width: 150,
                    color: AppTheme.primaryOrange,
                    child: Center(
                      child: Text("Lanjutkan",
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
      ],
    ));
  }
}

class OrderComponent extends StatefulWidget {
  int orderIndex;
  bool fromConfirmation;

  OrderComponent(
      {Key? key, required this.orderIndex, this.fromConfirmation = false})
      : super(key: key);

  @override
  State<OrderComponent> createState() => _OrderComponentState();
}

class _OrderComponentState extends State<OrderComponent> {
  var subsOrderController = Get.find<SubsOrderController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                            DateFormat.MMMMEEEEd('id').format(
                                subsOrderController.orderList.values
                                    .elementAt(widget.orderIndex)
                                    .deliveryDateTime!),
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryBlack)),
                        SizedBox(
                          width: 6,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.grey,
                              size: 14,
                            ),
                            Text(
                                subsOrderController.orderList.values
                                            .elementAt(widget.orderIndex)
                                            .deliveryDateTime!
                                            .hour ==
                                        0
                                    ? "-"
                                    : DateFormat.Hm().format(subsOrderController
                                        .orderList.values
                                        .elementAt(widget.orderIndex)
                                        .deliveryDateTime!),
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: AppTheme.primaryBlack)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                        CurrencyFormat.convertToIdr(
                            subsOrderController.orderList.values
                                .elementAt(widget.orderIndex)
                                .totalPrice,
                            0),
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryOrange))
                  ],
                ),
                if (!widget.fromConfirmation &&
                    subsOrderController.orderList.values
                        .elementAt(widget.orderIndex)
                        .orderProducts
                        .isNotEmpty)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await Get.toNamed(RouteHelper.subsPickProduct,
                                arguments: {"index": widget.orderIndex});
                            subsOrderController.checkAnyFulfilled();
                            subsOrderController.setAllTotalPrice();
                            subsOrderController.setAllTotalQuantity();
                          },
                          child: Text("+ Ubah",
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryGreen)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Obx(() {
              if (subsOrderController.orderList.values
                  .elementAt(widget.orderIndex)
                  .orderProducts
                  .isEmpty) {
                return NoSelectedProductComponent(
                  orderIndex: widget.orderIndex,
                );
              } else {
                return SelectedProductComponent(orderIndex: widget.orderIndex);
              }
            }),
            Divider()
          ],
        ),
      ),
    );
  }
}

class NoSelectedProductComponent extends StatelessWidget {
  NoSelectedProductComponent({Key? key, required this.orderIndex})
      : super(key: key);

  int orderIndex;

  @override
  Widget build(BuildContext context) {
    var subsOrderController = Get.find<SubsOrderController>();
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 10),
      child: GestureDetector(
        onTap: () async {
          await Get.toNamed(RouteHelper.subsPickProduct,
              arguments: {"index": orderIndex});
          subsOrderController.checkAnyFulfilled();
          subsOrderController.setAllTotalPrice();
          subsOrderController.setAllTotalQuantity();
        },
        child: Container(
          child: Center(
            child: Column(
              children: [
                Text("Belum ada menu",
                    style: AppTheme.textTheme.titleLarge!.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.primaryBlack)),
                Text("+ Tambah",
                    style: AppTheme.textTheme.titleLarge!.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryGreen)),
              ],
            ),
          ),
          height: 50,
        ),
      ),
    );
  }
}

class SelectedProductComponent extends StatefulWidget {
  int orderIndex;

  SelectedProductComponent({Key? key, required this.orderIndex})
      : super(key: key);

  @override
  State<SelectedProductComponent> createState() =>
      _SelectedProductComponentState();
}

class _SelectedProductComponentState extends State<SelectedProductComponent> {
  @override
  Widget build(BuildContext context) {
    var subsOrderController = Get.find<SubsOrderController>();
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image(
                            image: NetworkImage(AppConstant.BASE_URL +
                                subsOrderController.orderList.values
                                    .elementAt(widget.orderIndex)
                                    .orderProducts[index]
                                    .image!
                                    .substring(1))),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              subsOrderController.orderList.values
                                  .elementAt(widget.orderIndex)
                                  .orderProducts[index]
                                  .name!,
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w400)),
                          if (subsOrderController.orderList.values
                                  .elementAt(widget.orderIndex)
                                  .orderProducts[index]
                                  .productOptionSummary !=
                              "")
                            Text(
                                "Kustom : " +
                                    subsOrderController.orderList.values
                                        .elementAt(widget.orderIndex)
                                        .orderProducts[index]
                                        .productOptionSummary,
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 11, fontWeight: FontWeight.w400)),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                              CurrencyFormat.convertToIdr(
                                  subsOrderController.orderList.values
                                      .elementAt(widget.orderIndex)
                                      .orderProducts[index]
                                      .fixPrice()!,
                                  0),
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 11, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                            "x " +
                                subsOrderController.orderList.values
                                    .elementAt(widget.orderIndex)
                                    .orderProducts[index]
                                    .orderQuantity!
                                    .toString(),
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 11, fontWeight: FontWeight.w500)),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: subsOrderController.orderList.values
              .elementAt(widget.orderIndex)
              .orderProducts
              .length,
        ),
      ),
    );
  }
}
