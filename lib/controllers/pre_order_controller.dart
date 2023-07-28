import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kateringku_mobile/controllers/customer_dashboard_controller.dart';
import 'package:kateringku_mobile/controllers/profile_controller.dart';
import 'package:kateringku_mobile/data/repositories/catering_repo.dart';
import 'package:kateringku_mobile/models/address_model.dart';
import 'package:kateringku_mobile/models/pre_order_model.dart';
import 'package:kateringku_mobile/routes/route_helper.dart';
import 'package:kateringku_mobile/services/location_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import '../data/repositories/order_repo.dart';
import '../models/product_model.dart';
import '../screens/home/home_view.dart';
import '../themes/app_theme.dart';
import 'order_list_controller.dart';

class PreOrderController extends GetxController implements GetxService {
  final CateringRepo cateringRepo;
  final OrderRepo preOrderRepo;

  PreOrderController({required this.cateringRepo, required this.preOrderRepo});

  LocationService locationService = LocationService();
  var preOrderModel = PreOrderModel().obs;
  AddressModel? currentAddress;
  var customAddress = AddressModel().obs;
  AddressModel? selectedAddress;
  var isLoading = false.obs;
  var isLoadingGetDeliveryAvailableTime = false.obs;
  var isLoadingPostPreOrder = false.obs;

  double? cateringLatitude;
  double? cateringLongitude;
  int? cateringMinDistanceDelivery;
  int? cateringDeliveryCost;
  String? cateringId;
  var deliveryDateTime = Rxn<DateTime>();

  //DATE
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

  // List<ProductModel>? orderProducts;

  // DateTimeRange? deliveryAvailableTime;

  var isCurrentAddress = true.obs;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    await Get.find<ProfileController>().getProfileForOrder();
    currentAddress = await setCurrentAddress();
    setSelectedAddress(currentAddress!, true);
    preOrderModel.value.setSubTotalPrices();
    await setDeliveryPrice();
    preOrderModel.value.setTotalPrice();

    await getCateringOpenDay(cateringId: int.parse(cateringId!));
    // await getCateringOpenTime(cateringId: int.parse(cateringId!));
    generateBlackoutDayList();
    generateBlackoutDateForCalendar();

    EasyLoading.dismiss();
    isLoading.value = false;
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
    var startDate = DateTime.now().add(Duration(days: 3));
    var endDate = DateTime.now().add(Duration(days: 33));
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      if (blackOutDayList.contains(startDate.add(Duration(days: i)).weekday)) {
        blackoutDateForCalendar.add(startDate.add(Duration(days: i)));
      }
    }
  }

  Future<AddressModel> setCurrentAddress() async {
    // Position coordinates = await locationService.getCoordinates();
    var homeController = Get.find<CustomerDashboardController>();
    AddressModel addressModel = await locationService
        .getAddressFromCoordinates(homeController.currentCoordinates!);
    return addressModel;
  }

  void setCustomAddress(AddressModel customAddress) {
    this.customAddress.value = customAddress;
    preOrderModel.value.addressModel = customAddress;
  }

  void setSelectedAddress(AddressModel selectedAddress, bool isCurrentAddress) {
    preOrderModel.value.addressModel = selectedAddress;
    this.selectedAddress = selectedAddress;
    this.isCurrentAddress.value = isCurrentAddress;
  }

  Future<void> setDeliveryPrice() async {
    isLoading.value = true;
    // var distance = Geolocator.distanceBetween(
    //     double.parse(selectedAddress!.latitude!),
    //     double.parse(selectedAddress!.longitude!),
    //     cateringLatitude!,
    //     cateringLongitude!);
    // distance = distance / 1000;
    // var rounded_distance = distance.round();
    // preOrderModel.value.deliveryPrice = rounded_distance * 4000;
    Response response = await locationService.getDistanceFromCoordinates(
        cateringLatitude: cateringLatitude!,
        cateringLongitude: cateringLongitude!,
        customerLatitude: double.parse(selectedAddress!.latitude!),
        customerLongitude: double.parse(selectedAddress!.longitude!));

    int rounded_distance = 0;

    if (response.statusCode == 200) {
      var distance =
          double.parse(response.body["routes"][0]["distance"].toString());
      distance = distance / 1000;
      rounded_distance = distance.round();
    } else {
      rounded_distance = (Geolocator.distanceBetween(
                  double.parse(selectedAddress!.latitude!),
                  double.parse(selectedAddress!.longitude!),
                  cateringLatitude!,
                  cateringLongitude!) /
              1000)
          .round();
    }

    // var distance = Geolocator.distanceBetween(
    //     double.parse(selectedAddress!.latitude!),
    //     double.parse(selectedAddress!.longitude!),
    //     cateringLatitude!,
    //     cateringLongitude!);
    // var distance =
    //     double.parse(response.body["routes"][0]["distance"].toString());
    // distance = distance / 1000;
    // var rounded_distance = distance.round();

    if (rounded_distance < cateringMinDistanceDelivery!) {
      preOrderModel.value.deliveryPrice =
          (cateringDeliveryCost! * cateringMinDistanceDelivery!);
    } else {
      preOrderModel.value.deliveryPrice =
          (rounded_distance * cateringDeliveryCost!);
    }
    isLoading.value = false;
  }

  void recalculatePrice() async {
    isLoading.value = true;
    preOrderModel.value.setSubTotalPrices();
    await setDeliveryPrice();
    preOrderModel.value.setTotalPrice();
    isLoading.value = false;
  }

  Future<void> getDeliveryTimeRange() async {
    isLoadingGetDeliveryAvailableTime.value = true;
    Response response =
        await cateringRepo.getCateringDeliveryTimeRange(cateringId!);

    var startTime = response.body['delivery_start_time'];
    var endTime = response.body['delivery_end_time'];

    deliveryAvailableTime = DateTimeRange(
        start: DateTime.parse("2000-01-01 $startTime"),
        end: DateTime.parse("2000-01-01 $endTime"));

    isLoadingGetDeliveryAvailableTime.value = false;
  }

  chooseDate() async {
    var initialDate = deliveryDateTime!.value == null
        ? DateTime.now().add(Duration(days: 3))!
        : deliveryDateTime!.value;
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: initialDate!,
        firstDate: DateTime.now().add(Duration(days: 3)),
        lastDate: DateTime.now().add(Duration(days: 33)));
    if (pickedDate != null &&
        pickedDate != preOrderModel.value.deliveryDateTime) {
      preOrderModel.value.deliveryDateTime = pickedDate;
      deliveryDateTime.value = pickedDate;
    }
    // update();
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
                      if (deliveryDateTime.value != null)
                        Text(
                            "${DateFormat.Hm().format(deliveryDateTime.value!)} - ${DateFormat.Hm().format(deliveryDateTime.value!.add(Duration(minutes: 30)))}",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w400)),
                      Flexible(
                        child: CupertinoDatePicker(
                          initialDateTime: deliveryAvailableTime!.start,
                          // minuteInterval: 30,
                          mode: CupertinoDatePickerMode.time,
                          minimumDate: deliveryAvailableTime!.start,
                          maximumDate: deliveryAvailableTime!.end,
                          use24hFormat: true,
                          // This is called when the user changes the date.
                          onDateTimeChanged: (DateTime newDate) {
                            DateTime newDateTime = DateTime(
                                preOrderModel.value.deliveryDateTime!.year,
                                preOrderModel.value.deliveryDateTime!.month,
                                preOrderModel.value.deliveryDateTime!.day,
                                newDate.hour,
                                newDate.minute);
                            deliveryDateTime.value = newDateTime;
                            preOrderModel.value.deliveryDateTime = newDateTime;
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ));
  }

  Future<void> postPreOrder() async {
    isLoadingPostPreOrder.value = true;
    preOrderModel.value.cateringId = cateringId!;
    Response response = await preOrderRepo.postPreOrder(preOrderModel.value);

    if (response.statusCode == 200) {
      var orderId = response.body['id'];
      // var homeController = Get.find<HomeController>();
      // homeController.tabController.value.index = 2;
      // var orderListController = Get.find<OrderListController>();
      // orderListController.isLoading.value = true;
      // orderListController.getAllOrders();
      Get.until((route) => Get.currentRoute == RouteHelper.mainHome);
      Get.toNamed(RouteHelper.midtransPayment, arguments: [orderId]);
      // Get.delete<PreOrderController>();
    }
    isLoadingPostPreOrder.value = false;
  }

  Future<void> deleteCart(int id) async {
    isLoadingPostPreOrder.value = true;

    Response response = await preOrderRepo.deleteCart(id);

    isLoadingPostPreOrder.value = false;
  }

  bool isAllFilled() {
    return (!(deliveryDateTime.value == null) &&
        !(deliveryDateTime.value!.hour == 0) &&
        !isLoading.value &&
        !isLoadingGetDeliveryAvailableTime.value);
  }

  bool isDiscountUsable({required int minimumSpend}) {
    return preOrderModel.value.subTotalPrice >= minimumSpend;
  }

  void useBalanceForPayment() {
    var profileController = Get.find<ProfileController>();

    if (preOrderModel.value.useBalance > 0) {
      preOrderModel.value.useBalance = 0;
      preOrderModel.value.setTotalPrice();
      preOrderModel.refresh();
      return;
    }

    if (profileController.profileModel!.balance! >=
        preOrderModel.value.totalPrice) {
      preOrderModel.value.useBalance = preOrderModel.value.totalPrice;
    } else {
      preOrderModel.value.useBalance = profileController.profileModel!.balance!;
    }
    preOrderModel.value.setTotalPrice();
    preOrderModel.refresh();
  }
}
