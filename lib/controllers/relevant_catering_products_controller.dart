import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/data/repositories/relevant_catering_products_repo.dart';
import 'package:kateringku_mobile/models/relevant_catering_products_request_body.dart';
import 'package:kateringku_mobile/models/relevant_catering_products_response_body.dart';

class RelevantCateringProductsController extends GetxController
    implements GetxService {
  late StreamSubscription<Position> streamSubscription;
  // late Position position;
  var latitude = 0.0;
  var longitude = 0.0;
  var location = '...'.obs;
  // var address = "";

  @override
  void onInit() async {
    super.onInit();
    // await getLocation();
    // getRelavantCatering();
    Position position = await determinePosition();
    String locality = await getAddressFromLatLang(position);
    print(locality);
    RelevantCateringProductsRequestBody relevantCateringProductsRequestBody =
        RelevantCateringProductsRequestBody(location: "DENPASAR SELATAN");
    await getRelevantCateringProducts(relevantCateringProductsRequestBody);
    // print(address.value);
  }


  void getRelavantCatering() async {
    RelevantCateringProductsRequestBody relevantCateringProductsRequestBody =
        RelevantCateringProductsRequestBody(location: "DENPASAR");
    await getRelevantCateringProducts(relevantCateringProductsRequestBody);
  }

  final RelevantCateringProductsRepo relevantCateringProductsRepo;
  // late List<RelevantCateringProductsResponseBody>
  //     relevantCateringProductsResponeFinal;

  var relevantCaterings = <RelevantCateringProductsResponseBody>[];

  // RelevantCateringProductsResponseBody? relevantCateringProductsResponseBody;
  var isLoading = false.obs;
  RelevantCateringProductsController(
      {required this.relevantCateringProductsRepo});

  // var isLoading = false.obs;

  Future<void> getRelevantCateringProducts(
      RelevantCateringProductsRequestBody
          relevantCateringProductsRequestBody) async {
    isLoading.value = true;
    Response response = await relevantCateringProductsRepo
        .getRelevantCateringProducts(relevantCateringProductsRequestBody);
    if (response.statusCode == 200) {
      // response.body['caterings'].forEach((data) {

      //   relevantCateringProductsResponeFinal
      //       .add(relevantCateringProductsResponseBody);
      // });
      print(response.body['caterings'].length);
      for (var i = 0; i < response.body['caterings'].length; i++) {
        // var productPrice1 = int.parse(response.body['caterings'][i]["products"][0]["price"]);
        // var productPrice2 = int.parse(response.body['caterings'][i]["products"][1]["price"]);
        relevantCaterings.add(RelevantCateringProductsResponseBody(
            cateringVillageName: response.body['caterings'][i]['catering']
                ['village_name'],
            cateringId: response.body['caterings'][i]['catering']['id'],
            cateringName: response.body['caterings'][i]['catering']['name'],
            cateringImageUrl: response.body['caterings'][i]['catering']
                ['original_path'],
            productId1: response.body['caterings'][i]["products"][0]["id"],
            productName1: response.body['caterings'][i]["products"][0]["name"],
            productPrice1: response.body['caterings'][i]["products"][0]
                ["price"],
            productImage1: response.body['caterings'][i]["products"][0]
                ["original_path"],
            productId2: response.body['caterings'][i]["products"][1]["id"],
            productName2: response.body['caterings'][i]["products"][1]["name"],
            productPrice2: response.body['caterings'][i]["products"][1]
                ["price"],
            productImage2: response.body['caterings'][i]["products"][1]
                ["original_path"]));

        // relevantCaterings.refresh();
      }
      print("AYSHSHASHASHJASJH");
      // response.body['caterings'].forEach((key, value) {

      // });
      // relevantCaterings.add({
      //   "catering_name": value['catering']['name'],
      //   "catering_id": value['catering']['id'],
      //   "catering_image": value['catering']['original_path'],
      //   "catering_products": [
      //     {
      //       "product_id": value["products"][0]["id"],
      //       "product_name": value["products"][0]["name"],
      //       "product_price": value["products"][0]["price"],
      //       "product_image": value["products"][0]["original_path"],
      //     },
      //     {
      //       "product_id": value["products"][1]["id"],
      //       "product_name": value["products"][1]["name"],
      //       "product_price": value["products"][1]["price"],
      //       "product_image": value["products"][1]["original_path"],
      //     },
      //   ]
      // });

      // print(relevantCateringProductsRequestBody);
      isLoading.value = false;
      update();
    }
  }

  getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error("Location services are disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location services are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location services are denied forever");
    }

    // Geolocator.getCurrentPosition().then((Position position) {
    //   this.position = position;
    // });
    // getAddressFromLatLang(position);

    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      latitude = position.latitude;
      longitude = position.longitude;
      getAddressFromLatLang(position);
    });
  }

  Future<String> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    // print(placemark[0]);

    List<String> localityList = placemark[0].locality!.split(" ");
    String localityFinal =
        localityList.sublist(1, localityList.length).join(" ");
    // address = localityFinal;
    location.value = placemark[0].street! + " " + placemark[0].subLocality!;

    return localityFinal;
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
