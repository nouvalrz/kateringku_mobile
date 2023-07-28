import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/data/repositories/relevant_catering_products_repo.dart';
import 'package:kateringku_mobile/models/address_model.dart';
import 'package:kateringku_mobile/models/catering_display_model.dart';
import 'package:kateringku_mobile/models/relevant_catering_products_request_body.dart';
import 'package:kateringku_mobile/models/catering_with_two_product_model.dart';
import 'package:kateringku_mobile/routes/route_helper.dart';
import 'dart:developer';

import 'package:kateringku_mobile/services/location_service.dart';

class CustomerDashboardController extends GetxController
    implements GetxService {
  // For Get Location
  late StreamSubscription<Position> streamSubscription;
  Position? currentCoordinates;
  var location = '...'.obs;
  var relevantCaterings = <CateringDisplayModel>[];
  var isLoading = false.obs;
  AddressModel? addressModel;

  var searchInputController = TextEditingController();

  LocationService locationService = LocationService();
  final RelevantCateringProductsRepo relevantCateringProductsRepo;

  CustomerDashboardController({required this.relevantCateringProductsRepo});

  @override
  void onInit() async {
    super.onInit();

    currentCoordinates = await locationService.getCoordinates();
    addressModel =
        await locationService.getAddressFromCoordinates(currentCoordinates!);
    location.value = addressModel!.address!;

    RelevantCateringProductsRequestBody relevantCateringProductsRequestBody =
        RelevantCateringProductsRequestBody(
            location: addressModel!.districtName!,
            latitude: double.parse(addressModel!.latitude!),
            longitude: double.parse(addressModel!.longitude!));
    await getRelevantCateringProducts(relevantCateringProductsRequestBody);
  }

  Future<void> getAgainRelevantCateringProducts(Position position) async {
    location.value = "...";
    addressModel = await locationService.getAddressFromCoordinates(position);
    location.value = addressModel!.address!;

    RelevantCateringProductsRequestBody relevantCateringProductsRequestBody =
        RelevantCateringProductsRequestBody(
            location: addressModel!.districtName!,
            latitude: double.parse(addressModel!.latitude!),
            longitude: double.parse(addressModel!.longitude!));
    await getRelevantCateringProducts(relevantCateringProductsRequestBody);
  }

  Future<void> getRelevantCateringProducts(
      RelevantCateringProductsRequestBody
          relevantCateringProductsRequestBody) async {
    isLoading.value = true;
    relevantCaterings.clear();
    Response response = await relevantCateringProductsRepo
        .getRelevantCateringProducts(relevantCateringProductsRequestBody);
    if (response.statusCode == 200) {
      for (var i = 0; i < response.body['caterings'].length; i++) {
        relevantCaterings
            .add(CateringDisplayModel.fromJson(response.body['caterings'][i]));
      }
      for (var catering in relevantCaterings) {
        for (var j = 0; j < response.body['admin_discounts'].length; j++) {
          catering.discounts!
              .add(Discount.fromJson(response.body['admin_discounts'][j]));
        }
      }
      isLoading.value = false;
      update();
    }
  }

  void search() {
    var keyword = searchInputController.value.text;
    Get.toNamed(RouteHelper.search, arguments: {
      "keyword": keyword,
      "district_name": addressModel!.districtName!,
      'customer_latitude': addressModel!.latitude!,
      'customer_longitude': addressModel!.longitude!
    });
  }

  // void getRelavantCatering() async {
  //   RelevantCateringProductsRequestBody relevantCateringProductsRequestBody =
  //       RelevantCateringProductsRequestBody(location: "DENPASAR");
  //   await getRelevantCateringProducts(relevantCateringProductsRequestBody);
  // }

  // Future<String> getAddressFromCoordinates(Position position) async {
  //   List<Placemark> placemark =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark place = placemark[0];
  //
  //   List<String> localityList = placemark[0].locality!.split(" ");
  //   String localityFinal =
  //       localityList.sublist(1, localityList.length).join(" ");
  //   location.value = placemark[0].street! + " " + placemark[0].subLocality!;
  //
  //   return localityFinal;
  // }
  //
  // Future<Position> getCoordinates() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   // Return object from Position Class
  //   return await Geolocator.getCurrentPosition();
  // }
}
