import 'package:get/get.dart';

import '../data/repositories/customer_address_repo.dart';
import '../models/address_model.dart';

class AddressController extends GetxController implements GetxService{

  List<AddressModel> addresses = [];
  late AddressModel newAddress;
  final CustomerAddressRepo customerAddressRepo;
  var isLoading = false.obs;

  AddressController({required this.customerAddressRepo});

  Future<void> getAllAddress() async{
    isLoading.value = true;
    addresses = [];
    customerAddressRepo.setToken();
    Response response = await customerAddressRepo.getAllAddress();

    for(var i = 0 ; i < response.body['addresses'].length; i++){
      AddressModel addressModel = AddressModel.fromJson(response.body['addresses'][i]);
      addresses.add(addressModel);
    }
    isLoading.value = false;
  }
}