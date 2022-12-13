import 'package:geocoding/geocoding.dart';
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
    Response response = await customerAddressRepo.getAllAddress();

    print("TANDAAA");
    print(response.body);
    print(response.body['addresses']);

    for(var i = 0 ; i < response.body['addresses'].length; i++){
      CustomerAddressModel customerAddressModel = CustomerAddressModel(id: response.body['addresses'][i]['id'].toString(), customer_id: response.body['addresses'][i]['customer_id'].toString(), recipient_name: response.body['addresses'][i]['recipient_name'], address: response.body['addresses'][i]['address'], latitude: double.parse(response.body['addresses'][i]['latitude']), longitude: double.parse( response.body['addresses'][i]['longitude']));

      addressList.add(customerAddressModel);
    }
    addressList.refresh();
    getMainAddress();

  }

  void getMainAddress() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var main_address = preferences.getString(AppConstant.MAIN_ADDRESS);


    if(main_address==null){
      mainAddress = addressList[0];
      await preferences.setString(AppConstant.MAIN_ADDRESS, addressList[0].id.toString());
    }else{
      addressList.forEach((element) {
        if(element.id.toString() == main_address){
          mainAddress = element;
        }
      });
    }
    print("INI MAIN ADDRESS");
    print(mainAddress);
    isLoading.value = false;
  }

  Future<void> getLocationName(double latitude, double longitude) async{
    List<Placemark> placemark =
    await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemark[0];
    print(place);
  }


}