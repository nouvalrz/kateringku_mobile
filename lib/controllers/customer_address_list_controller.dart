import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constant.dart';
import '../data/repositories/customer_address_repo.dart';
import '../models/customer_address_model.dart';

class CustomerAddressListController extends GetxController {
  final CustomerAddressRepo customerAddressRepo;

  CustomerAddressListController({required this.customerAddressRepo});

  var activeId = "".obs;

  var isLoading = false.obs;

  var addressList = <CustomerAddressModel>[].obs;

  CustomerAddressModel? mainAddress;

  @override
  void onInit() {
    super.onInit();
    // customerAddressRepo.setToken();
    // getAllAddress();
  }

  void setInitialActiveId(String id) async {
    activeId.value = id;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(AppConstant.MAIN_ADDRESS, id);
    update();
  }

  Future<void> getAllAddress() async {
    isLoading.value = true;
    addressList.clear();
    customerAddressRepo.setToken();
    Response response = await customerAddressRepo.getAllAddress();

    print("TANDAAA");
    print(response.body);
    print(response.body['addresses']);

    for (var i = 0; i < response.body['addresses'].length; i++) {
      CustomerAddressModel customerAddressModel = CustomerAddressModel(
          id: response.body['addresses'][i]['id'].toString(),
          customer_id: response.body['addresses'][i]['customer_id'].toString(),
          recipient_name: response.body['addresses'][i]['recipient_name'],
          address: response.body['addresses'][i]['address'],
          latitude: double.parse(response.body['addresses'][i]['latitude']),
          longitude: double.parse(response.body['addresses'][i]['longitude']),
          phone: response.body['addresses'][i]['phone']);

      addressList.add(customerAddressModel);
    }
    addressList.refresh();
    // getMainAddress();
  }

  void getMainAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var main_address = preferences.getString(AppConstant.MAIN_ADDRESS);

    if (main_address == null || main_address == "") {
      mainAddress = addressList[0];
      activeId.value = mainAddress!.id.toString();
      await preferences.setString(
          AppConstant.MAIN_ADDRESS, addressList[0].id.toString());
    } else {
      addressList.forEach((element) {
        if (element.id.toString() == main_address) {
          mainAddress = element;
          activeId.value = element.id;
        }
      });
    }
    print("INI MAIN ADDRESS!!!");
    print("SHARED" + main_address!);
    // print(mainAddress!.recipient_name);
    isLoading.value = false;
    update();
  }
}
