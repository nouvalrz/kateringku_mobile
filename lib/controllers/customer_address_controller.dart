

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/data/repositories/customer_address_repo.dart';
import 'package:kateringku_mobile/models/customer_address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constant.dart';

class CustomerAddressController extends GetxController implements GetxService{
  final CustomerAddressRepo customerAddressRepo;

  CustomerAddressController({required this.customerAddressRepo});


  var isLoading = false.obs;

  var addressList = <CustomerAddressModel>[].obs;

  var cateringLatitude = 0.0;
  var cateringLongitude = 0.0;

  var distance = 0.0.obs;
  // var deliveryPrice = 0.obs;

  int? deliveryPrice;

  CustomerAddressModel? mainAddress;


  @override
  void onInit(){
    super.onInit();
    // customerAddressRepo.setToken();
    getAllAddress();

  }


  Future<void> getAllAddress() async{
    isLoading.value = true;
    customerAddressRepo.setToken();
    addressList.clear();
    Response response = await customerAddressRepo.getAllAddress();

    print("TANDAAA");
    print(response.body);
    print(response.body['addresses']);

    for(var i = 0 ; i < response.body['addresses'].length; i++){
      CustomerAddressModel customerAddressModel = CustomerAddressModel(id: response.body['addresses'][i]['id'].toString(), customer_id: response.body['addresses'][i]['customer_id'].toString(), recipient_name: response.body['addresses'][i]['recipient_name'], address: response.body['addresses'][i]['address'], latitude: double.parse(response.body['addresses'][i]['latitude']), longitude: double.parse( response.body['addresses'][i]['longitude']), phone: response.body['addresses'][i]['phone']);

      addressList.add(customerAddressModel);
    }
    addressList.refresh();

    if(addressList.isNotEmpty){
      getMainAddress();
    }

    isLoading.value = false;


  }

  void getMainAddress() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var main_address = preferences.getString(AppConstant.MAIN_ADDRESS);

    print(addressList);

    if(main_address==null || main_address == ""){
      mainAddress = addressList[0];
      await preferences.setString(AppConstant.MAIN_ADDRESS, addressList[0].id.toString());
    }else{
      addressList.forEach((element) {
        if(element.id.toString() == main_address){
          mainAddress = element;
        }
      });
    }
    print("INI MAIN ADDRESS ++");
    print(mainAddress);
    print(main_address);

    getDeliveryPrice();
    update();
  }

  void getDeliveryPrice(){
    print("TITIK CATERING");
    print(cateringLatitude);
    print(cateringLongitude);
    print("TITIK ADDRESS");
    print(mainAddress!.latitude);
    print(mainAddress!.longitude);
    var distance = Geolocator.distanceBetween(mainAddress!.latitude, mainAddress!.longitude, cateringLatitude, cateringLongitude);
    // print(distance);
    distance = distance/1000;
    // print(distance);
    var rounded_distance = distance.round();
    deliveryPrice = rounded_distance * 3000;
    // print(deliveryPrice.value);
    isLoading.value = false;
    // print(rounded_distance * 3000);
  }

  Future<void> getLocationName(double latitude, double longitude) async{
    List<Placemark> placemark =
    await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemark[0];
    print(place);
  }


}