import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kateringku_mobile/controllers/profile_controller.dart';
import 'package:kateringku_mobile/data/repositories/catering_repo.dart';
import 'package:kateringku_mobile/models/subs_order_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../data/repositories/catering_product_repo.dart';
import '../data/repositories/order_repo.dart';
import '../models/address_model.dart';
import '../models/catering_display_model.dart';
import '../models/product_model.dart';
import '../routes/route_helper.dart';
import '../services/location_service.dart';
import '../themes/app_theme.dart';
import 'customer_dashboard_controller.dart';

class SubsOrderController extends GetxController implements GetxService {
  final CateringRepo cateringRepo;
  final CateringProductRepo cateringProductRepo;
  final OrderRepo orderRepo;

  SubsOrderController(
      {required this.cateringRepo,
      required this.cateringProductRepo,
      required this.orderRepo});

  // Date Picker
  DateRangePickerController datePickerController = DateRangePickerController();
  var cateringWorkday = <String>[];
  var blackOutDayList = <int>[];
  var blackoutDateForCalendar = <DateTime>[];
  var date = DateTime.monday;
  DateTimeRange? deliveryAvailableTime;

  var isListOrderExpand = false.obs;

  Map<String, int> dayType = {
    "senin": DateTime.monday,
    "selasa": DateTime.tuesday,
    "rabu": DateTime.wednesday,
    "kamis": DateTime.thursday,
    "jumat": DateTime.friday,
    "sabtu": DateTime.saturday,
    "minggu": DateTime.sunday
  };

  // Address
  LocationService locationService = LocationService();
  AddressModel? currentAddress;
  AddressModel? selectedAddress;
  var isCurrentAddress = true.obs;
  var customAddress = AddressModel().obs;

  // Delivery Price

  // Catering
  double? cateringLatitude;
  double? cateringLongitude;
  String? cateringId;
  int? cateringDeliveryCost;
  int? cateringMinDistanceDelivery;

  // Products
  var cateringProducts = <ProductModel>[].obs;

  // Discount
  var discount = 0.obs;
  // Rx<int?> discountId = null.obs;
  var discountId = Rxn<int>();
  String? discountName;
  int? discountPercentage;

  // Orders
  var orderList = <DateTime, SubsOrderModel>{}.obs;
  Rx<int> subtotalPrice = 0.obs;
  Rx<int> deliveryPrice = 0.obs;
  Rx<int> fixOrderPrice = 0.obs;
  Rx<int> useBalance = 0.obs;

  // Pricing State
  var allTotalPrice = 0.obs;
  var allTotalQuantity = 0.obs;

  // Form Validate
  var isAnyFulfilled = false.obs;

  // Loading State
  var isGenerateListOfOrderLoading = false.obs;
  var isLoading = false.obs;

  void init({required int cateringId}) async {
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    await getCateringOpenDay(cateringId: cateringId);
    await getCateringOpenTime(cateringId: cateringId);
    await getCateringProducts(cateringId.toString());
    generateBlackoutDayList();
    generateBlackoutDateForCalendar();
    EasyLoading.dismiss();
  }

  void initConfirmation() async {
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    isLoading.value = true;

    await Get.find<ProfileController>().getProfile();
    currentAddress = await setCurrentAddress();
    setSelectedAddress(currentAddress!, true);
    await setDeliveryPrice();
    setTotalPrice();

    isLoading.value = false;
    EasyLoading.dismiss();
  }

  void setTotalPrice() {
    fixOrderPrice.value = (deliveryPrice.value + allTotalPrice.value) -
        discount.value -
        useBalance.value;
  }

  void setCustomAddress(AddressModel customAddress) {
    this.customAddress.value = customAddress;
  }

  void setSelectedAddress(AddressModel selectedAddress, bool isCurrentAddress) {
    this.selectedAddress = selectedAddress;
    this.isCurrentAddress.value = isCurrentAddress;
  }

  Future<void> setDeliveryPrice() async {
    isLoading.value = true;
    Response response = await locationService.getDistanceFromCoordinates(
        cateringLatitude: cateringLatitude!,
        cateringLongitude: cateringLongitude!,
        customerLatitude: double.parse(selectedAddress!.latitude!),
        customerLongitude: double.parse(selectedAddress!.longitude!));

    // var distance = Geolocator.distanceBetween(
    //     double.parse(selectedAddress!.latitude!),
    //     double.parse(selectedAddress!.longitude!),
    //     cateringLatitude!,
    //     cateringLongitude!);
    var distance = response.body["routes"][0]["distance"];
    distance = distance / 1000;
    var rounded_distance = distance.round();

    if (rounded_distance < cateringMinDistanceDelivery) {
      deliveryPrice!.value =
          (cateringDeliveryCost! * cateringMinDistanceDelivery!) *
              orderList.length;
    } else {
      deliveryPrice!.value =
          (rounded_distance * cateringDeliveryCost!) * orderList.length;
    }
    isLoading.value = false;
  }

  void recalculatePrice() async {
    isLoading.value = true;
    await setDeliveryPrice();
    setTotalPrice();
    isLoading.value = false;
  }

  // void recalculatePrice() {
  //   isLoading.value = true;
  //   preOrderModel.value.setSubTotalPrices();
  //   setDeliveryPrice();
  //   preOrderModel.value.setTotalPrice();
  //   isLoading.value = false;
  // }

  Future<void> getCateringProducts(String catering_id) async {
    cateringProducts.clear();
    Response response =
        await cateringProductRepo.getProductsFromCatering(catering_id);

    for (var i = 0; i < response.body['products'].length; i++) {
      // CateringProductModel cateringProductModel =
      //   CateringProductModel(
      //       product_id: response.body['products'][i]['id'].toString(),
      //       product_name: response.body['products'][i]['name'],
      //       product_description: response.body['products'][i]['description'],
      //       product_weight: response.body['products'][i]['weight'],
      //       minimum_quantity: response.body['products'][i]['minimum_quantity'],
      //       maximum_quantity: response.body['products'][i]['maximum_quantity'],
      //       is_free_delivery: response.body['products'][i]['is_free_delivery'],
      //       is_available: response.body['products'][i]['is_available'],
      //       product_image: response.body['products'][i]['original_path'],
      //     product_price: response.body['products'][i]['price'],
      //     product_is_customable: response.body['products'][i]['is_customable']
      //   );
      cateringProducts.add(ProductModel.fromJson(response.body['products'][i]));
    }
    cateringProducts.refresh();
  }

  List<DateTime> generateListOfOrderDate(DateTimeRange subsDateRange) {
    List<DateTime> subsDate = [];
    var startDate = subsDateRange.start;
    var endDate = subsDateRange.end;
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      if (!blackOutDayList.contains(startDate.add(Duration(days: i)).weekday)) {
        subsDate.add(startDate.add(Duration(days: i)));
      }
    }
    return subsDate;
  }

  void generateListOfOrder(DateTimeRange subsDateRange) {
    isGenerateListOfOrderLoading.value = true;
    orderList.clear();
    var subsDate = generateListOfOrderDate(subsDateRange);
    subsDate.forEach((element) {
      var subsOrderModel = SubsOrderModel();
      subsOrderModel.deliveryDateTime = element;
      orderList[element] = subsOrderModel;
    });
    isGenerateListOfOrderLoading.value = false;
  }

  Future<void> getCateringOpenDay({required int cateringId}) async {
    Response response =
        await cateringRepo.getCateringWorkDay(cateringId.toString());
    if (response.statusCode == 200) {
      for (var i = 0; i < response.body["workday"].length; i++) {
        cateringWorkday.add(response.body["workday"][i]);
      }
    }
  }

  Future<void> getCateringOpenTime({required int cateringId}) async {
    Response response =
        await cateringRepo.getCateringDeliveryTimeRange(cateringId.toString());

    var startTime = response.body['delivery_start_time'];
    var endTime = response.body['delivery_end_time'];

    deliveryAvailableTime = DateTimeRange(
        start: DateTime.parse("2000-01-01 $startTime"),
        end: DateTime.parse("2000-01-01 $endTime"));
  }

  void generateBlackoutDayList() {
    var blackOutDay = dayType;
    blackOutDay.removeWhere((key, value) => cateringWorkday.contains(key));
    blackOutDayList = blackOutDay.values.toList();
  }

  void generateBlackoutDateForCalendar() {
    var startDate = DateTime.now().add(Duration(days: 1));
    var endDate = DateTime.now().add(Duration(days: 30));
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      if (blackOutDayList.contains(startDate.add(Duration(days: i)).weekday)) {
        blackoutDateForCalendar.add(startDate.add(Duration(days: i)));
      }
    }
  }

  String getDateRangeWording() {
    initializeDateFormatting('id');
    var firstDate = orderList.keys.toList().first;
    var lastDate = orderList.keys.toList().last;
    if (firstDate.month == lastDate.month) {
      return "${firstDate.day} - ${DateFormat.MMMMd('id').format(lastDate)}";
    } else {
      return "${DateFormat.MMMMd('id').format(firstDate)} - ${DateFormat.MMMMd('id').format(lastDate)}";
    }
  }

  chooseTime() async {
    showCupertinoModalPopup<void>(
        context: Get.context!,
        builder: (BuildContext context) => Container(
              height: 300,
              padding: const EdgeInsets.only(top: 12.0),
              // The Bottom margin is provided to align the popup above the system
              // navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Estimasi Pengiriman",
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      if (orderList.values.first.deliveryDateTime != null)
                        Text(
                            "${DateFormat.Hm().format(orderList.values.first.deliveryDateTime!)} - ${DateFormat.Hm().format(orderList.values.first.deliveryDateTime!.add(Duration(minutes: 30)))}",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w400)),
                      Flexible(
                        child: CupertinoDatePicker(
                          initialDateTime: deliveryAvailableTime!.start,
                          minuteInterval: 30,
                          mode: CupertinoDatePickerMode.time,
                          minimumDate: deliveryAvailableTime!.start,
                          maximumDate: deliveryAvailableTime!.end,
                          use24hFormat: true,
                          // This is called when the user changes the date.
                          onDateTimeChanged: (DateTime newTime) {
                            // DateTime newDateTime = DateTime(
                            //     preOrderModel.value.deliveryDateTime!.year,
                            //     preOrderModel.value.deliveryDateTime!.month,
                            //     preOrderModel.value.deliveryDateTime!.day,
                            //     newDate.hour,
                            //     newDate.minute);
                            // deliveryDateTime.value = newDateTime;
                            // preOrderModel.value.deliveryDateTime = newDateTime;
                            changeAllOrderTime(newTime: newTime);
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ));
  }

  void changeAllOrderTime({required DateTime newTime}) {
    orderList.forEach((key, value) {
      value.changeTime(newTime: newTime);
    });
    orderList.refresh();
  }

  void addProductQuantity({required int orderIndex, required int productId}) {
    var orderProductIndex = orderList.values
        .elementAt(orderIndex)
        .orderProducts
        .indexWhere((element) => element.id == productId);
    var NOT_FOUND = -1;
    if (orderProductIndex == NOT_FOUND) {
      var copyProducts = cateringProducts.toList();
      var copySelectedCateringProduct =
          copyProducts.firstWhere((element) => element.id == productId);
      var selectedCateringProduct = ProductModel(
          price: copySelectedCateringProduct.price,
          cateringId: copySelectedCateringProduct.id,
          image: copySelectedCateringProduct.image,
          id: copySelectedCateringProduct.id,
          name: copySelectedCateringProduct.name,
          createdAt: copySelectedCateringProduct.createdAt,
          description: copySelectedCateringProduct.description,
          isAvailable: copySelectedCateringProduct.isAvailable,
          isCustomable: copySelectedCateringProduct.isCustomable,
          isFreeDelivery: copySelectedCateringProduct.isFreeDelivery,
          isHidden: copySelectedCateringProduct.isHidden,
          maximumQuantity: copySelectedCateringProduct.maximumQuantity,
          minimumQuantity: copySelectedCateringProduct.minimumQuantity,
          productOptions: copySelectedCateringProduct.productOptions,
          totalSales: copySelectedCateringProduct.totalSales,
          updatedAt: copySelectedCateringProduct.updatedAt,
          weight: copySelectedCateringProduct.weight);
      selectedCateringProduct.addQuantity(quantity: 1);
      orderList.values
          .elementAt(orderIndex)
          .orderProducts
          .add(selectedCateringProduct);
    } else {
      orderList.values
          .elementAt(orderIndex)
          .orderProducts[orderProductIndex]
          .addQuantity(quantity: 1);
    }
    orderList.values.elementAt(orderIndex)
      ..setTotalPrices()
      ..setTotalQuantity();
    orderList.refresh();
  }

  void minusProductQuantity({required int orderIndex, required int productId}) {
    var orderProductIndex = orderList.values
        .elementAt(orderIndex)
        .orderProducts
        .indexWhere((element) => element.id == productId);
    orderList.values
        .elementAt(orderIndex)
        .orderProducts[orderProductIndex]
        .subtractQuantity();
    if (orderList.values
            .elementAt(orderIndex)
            .orderProducts[orderProductIndex]
            .orderQuantity ==
        0) {
      orderList.values
          .elementAt(orderIndex)
          .orderProducts
          .removeAt(orderProductIndex);
    }
    orderList.values.elementAt(orderIndex)
      ..setTotalPrices()
      ..setTotalQuantity();
    orderList.refresh();
  }

  Rx<int> getOrderProductQuantity(
      {required int orderIndex, required int productId}) {
    var orderProductIndex = orderList.values
        .elementAt(orderIndex)
        .orderProducts
        .indexWhere((element) => element.id == productId);
    var NOT_FOUND = -1;
    if (orderProductIndex == NOT_FOUND) {
      // orderList.refresh();
      return 0.obs;
    } else {
      update();
      return orderList.values
          .elementAt(orderIndex)
          .orderProducts[orderProductIndex]
          .orderQuantity
          .obs;
    }
  }

  void setAllTotalPrice() {
    allTotalPrice.value = 0;
    for (var order in orderList.values) {
      allTotalPrice += order.totalPrice;
    }
  }

  void setAllTotalQuantity() {
    allTotalQuantity.value = 0;
    for (var order in orderList.values) {
      allTotalQuantity += order.totalQuantity;
    }
  }

  void resetOrderInDay({required int orderIndex}) {
    orderList.values.elementAt(orderIndex).orderProducts.clear();
    orderList.values.elementAt(orderIndex).setTotalQuantity();
    orderList.values.elementAt(orderIndex).setTotalPrices();
    orderList.refresh();
  }

  void checkAnyFulfilled() {
    isAnyFulfilled.value = false;
    for (var order in orderList.values) {
      if (order.orderProducts.isNotEmpty) {
        isAnyFulfilled.value = true;
        break;
      }
    }
  }

  void repeatOrder() {
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var fulfilledOrderIndex = <int>[];
    var emptyOrderIndex = <int>[];
    for (var i = 0; i < orderList.values.length; i++) {
      if (orderList.values.elementAt(i).orderProducts.isEmpty) {
        emptyOrderIndex.add(i);
      } else {
        fulfilledOrderIndex.add(i);
      }
    }

    var fulfilledOrderIndexSeeder = <int>[];

    //Expand
    if (emptyOrderIndex.length > fulfilledOrderIndex.length) {
      var toAdd = <int>[];
      fulfilledOrderIndexSeeder = fulfilledOrderIndex;
      for (var i = 0;
          i < (emptyOrderIndex.length - fulfilledOrderIndex.length);
          i++) {
        for (var index in fulfilledOrderIndex) {
          if (toAdd.length ==
              (emptyOrderIndex.length - fulfilledOrderIndex.length)) {
            break;
          }
          toAdd.add(index);
        }
      }
      fulfilledOrderIndexSeeder = fulfilledOrderIndexSeeder + toAdd;
    }
    //Shrink
    else if (emptyOrderIndex.length < fulfilledOrderIndex.length) {
      fulfilledOrderIndexSeeder =
          fulfilledOrderIndex.sublist(0, emptyOrderIndex.length);
    }
    // Do Nothing
    else {
      fulfilledOrderIndexSeeder = fulfilledOrderIndex;
    }

    for (var i = 0; i < emptyOrderIndex.length; i++) {
      var copiedProducts = <ProductModel>[];
      orderList.values
          .elementAt(fulfilledOrderIndexSeeder[i])
          .orderProducts!
          .forEach((element) {
        var copiedProduct = ProductModel(
            orderQuantity: element.orderQuantity,
            additionalPrice: element.additionalPrice,
            price: element.price,
            cateringId: element.id,
            image: element.image,
            id: element.id,
            name: element.name,
            createdAt: element.createdAt,
            description: element.description,
            isAvailable: element.isAvailable,
            isCustomable: element.isCustomable,
            isFreeDelivery: element.isFreeDelivery,
            isHidden: element.isHidden,
            maximumQuantity: element.maximumQuantity,
            minimumQuantity: element.minimumQuantity,
            productOptions: element.productOptions,
            totalSales: element.totalSales,
            updatedAt: element.updatedAt,
            productOptionSummary: element.productOptionSummary,
            weight: element.weight);
        copiedProducts.add(copiedProduct);
      });

      orderList.values
          .elementAt(emptyOrderIndex[i])
          .orderProducts
          .addAll(copiedProducts);
      orderList.values.elementAt(emptyOrderIndex[i]).setTotalQuantity();
      orderList.values.elementAt(emptyOrderIndex[i]).setTotalPrices();
    }
    setAllTotalQuantity();
    setAllTotalPrice();
    orderList.refresh();
    EasyLoading.dismiss();
  }

  Future<AddressModel> setCurrentAddress() async {
    // Position coordinates = await locationService.getCoordinates();
    var homeController = Get.find<CustomerDashboardController>();
    AddressModel addressModel = await locationService
        .getAddressFromCoordinates(homeController.currentCoordinates!);
    return addressModel;
  }

  bool isDiscountUsable({required int minimumSpend}) {
    return allTotalPrice.value >= minimumSpend;
  }

  void setDiscount({required Discount discountModel, bool reset = false}) {
    // discountId = discountModel.id;
    if (!reset) {
      var discountReducePrice =
          (allTotalPrice.value * (discountModel.percentage! / 100)).toInt();
      if (discountReducePrice > discountModel.maximumDisc!) {
        discount.value = discountModel.maximumDisc!;
      } else {
        discount.value = discountReducePrice;
      }
      discountName = discountModel.title;
      discountPercentage = discountModel.percentage;
    } else {
      discount.value = 0;
      discountName = null;
      discountPercentage = null;
    }
    setTotalPrice();
  }

  bool validateForm() {
    if (orderList.isEmpty) {
      return false;
    }
    for (var subOrder in orderList.values) {
      if (subOrder.orderProducts.isEmpty) {
        return false;
      }
    }
    return true;
  }

  Future<void> createSubsOrder() async {
    Map<String, dynamic> data = {};
    data['address'] = selectedAddress!.toJson();
    data['delivery_cost'] = deliveryPrice.value;
    data['total_price'] = fixOrderPrice.value;
    data['use_balance'] = useBalance.value;
    data['start_date'] = orderList.values.first.deliveryDateTime.toString();
    data['end_date'] = orderList.values.last.deliveryDateTime.toString();
    data['catering_id'] = cateringId!;
    if (this.discount != 0) {
      Map<String, dynamic> discountData = {
        "nama": "${discountName!}",
        "persenan": discountPercentage!,
        "jumlah": discount.value
      };

      data["discount"] = json.encode(discountData);
    } else {
      data["discount"] = null;
    }
    var orderDetails = <Map<String, dynamic>>[];

    for (var order in orderList.values) {
      for (var product in order.orderProducts) {
        product.setProductOptionSummary();
        Map<String, dynamic> data = {
          "delivery_datetime": order.deliveryDateTime.toString(),
          "product_id": product.id,
          "quantity": product.orderQuantity,
          "price": product.fixPrice(),
          "custom_desc": product.productOptionSummary
        };
        orderDetails.add(data);
      }
    }

    data["order_details"] = orderDetails;

    Response response = await orderRepo.postSubsOrder(data);

    if (response.statusCode == 200) {
      var orderId = response.body['id'];
      // var homeController = Get.find<HomeController>();
      // homeController.tabController.value.index = 2;
      // var orderListController = Get.find<OrderListController>();
      // orderListController.isLoading.value = true;
      // orderListController.getAllOrders();
      Get.until((route) => Get.currentRoute == RouteHelper.mainHome);
      Get.toNamed(RouteHelper.midtransPayment, arguments: [orderId]);
    }
  }

  void useBalanceForPayment() {
    var profileController = Get.find<ProfileController>();

    if (useBalance.value > 0) {
      useBalance.value = 0;
      recalculatePrice();
      return;
    }

    if (profileController.profileModel!.balance! >= fixOrderPrice.value) {
      useBalance.value = fixOrderPrice.value;
    } else {
      useBalance.value = profileController.profileModel!.balance!;
    }
    recalculatePrice();
  }
}
