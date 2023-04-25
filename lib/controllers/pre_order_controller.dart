import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kateringku_mobile/controllers/customer_dashboard_controller.dart';
import 'package:kateringku_mobile/data/repositories/catering_repo.dart';
import 'package:kateringku_mobile/models/address_model.dart';
import 'package:kateringku_mobile/models/pre_order_model.dart';
import 'package:kateringku_mobile/routes/route_helper.dart';
import 'package:kateringku_mobile/services/location_service.dart';
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
  String? cateringId;
  var deliveryDateTime = Rxn<DateTime>();

  // List<ProductModel>? orderProducts;

  DateTimeRange? deliveryAvailableTime;

  var isCurrentAddress = true.obs;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    currentAddress = await setCurrentAddress();
    setSelectedAddress(currentAddress!, true);
    preOrderModel.value.setSubTotalPrices();
    setDeliveryPrice();
    preOrderModel.value.setTotalPrice();
    EasyLoading.dismiss();
    isLoading.value = false;
  }

  Future<AddressModel> setCurrentAddress() async {
    // Position coordinates = await locationService.getCoordinates();
    var homeController = Get.find<CustomerDashboardController>();
    AddressModel addressModel =
        await locationService.getAddressFromCoordinates(homeController.currentCoordinates!);
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

  void setDeliveryPrice() {
    isLoading.value = true;
    var distance = Geolocator.distanceBetween(
        double.parse(selectedAddress!.latitude!),
        double.parse(selectedAddress!.longitude!),
        cateringLatitude!,
        cateringLongitude!);
    distance = distance / 1000;
    var rounded_distance = distance.round();
    preOrderModel.value.deliveryPrice = rounded_distance * 4000;
    isLoading.value = false;
  }

  void recalculatePrice() {
    isLoading.value = true;
    preOrderModel.value.setSubTotalPrices();
    setDeliveryPrice();
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
        ? DateTime.now().add(Duration(days: 1))!
        : deliveryDateTime!.value;
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: initialDate!,
        firstDate: DateTime.now().add(Duration(days: 1)),
        lastDate: DateTime.now().add(Duration(days: 30)));
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
                        Text("${DateFormat.Hm().format(deliveryDateTime.value!)} - ${DateFormat.Hm().format(deliveryDateTime.value!.add(Duration(minutes: 30)))}",
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
}
