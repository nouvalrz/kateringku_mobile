import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kateringku_mobile/models/add_customer_address_body.dart';
import 'package:kateringku_mobile/routes/route_helper.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../data/repositories/customer_address_repo.dart';
import '../data/repositories/save_address_repo.dart';
import '../models/response_model.dart';
import 'customer_address_list_controller.dart';

class SaveAddressController extends GetxController implements GetxService{

  final SaveAddressRepo saveAddressRepo;

  SaveAddressController({
    required this.saveAddressRepo,
  });

  late TextEditingController recipientNameController,
      addressController,
      phoneController;

  var recipientName = "";
  var address = "";
  var phone = "";
  LatLng? addressCoordinate;
  var villageName = "";
  var isLoading = false.obs;
  var isValid = false;

  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  var addressRepo = Get.put(CustomerAddressRepo(apiClient: Get.find()));
  // var addressRepo = Get.find<CustomerAddressRepo>();

  var addressListController = Get.put(CustomerAddressListController(customerAddressRepo: Get.find()));

  @override
  void onInit() {
    super.onInit();
    recipientNameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void onClose() {
    recipientNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    recipientName = "";
    address = "";
    phone = "";
  }

  String? validateName(String value) {
    if (value.length <= 5) {
      return "Name must atleast 5 character";
    }
    return null;
  }

  String? validateAddress(String value) {
    if (value.length <= 10) {
      return "Address must atleast 10 character";
    }
    return null;
  }

  String? validatePhone(String value) {
    if (value.length <= 10) {
      return "Phone must atleast 10 character";
    }
    return null;
  }

  Future<ResponseModel> saveAddress(
      AddCustomerAddressBody addCustomerAddressBody) async {
    isLoading.value = true;
    Response response = await saveAddressRepo.saveAddress(addCustomerAddressBody);
    print(response.body);
    late ResponseModel responseModel;

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, "OK");
    } else {
      responseModel = ResponseModel(false, "ERROR");
      print(response.statusCode);
    }
    isLoading.value = false;
    update();
    return responseModel;
  }

  void checkFormAddressValidation() async {
    print("CLICK");
    isLoading.value = true;
    isValid = addressFormKey.currentState!.validate();
    if (!isValid) {
      print("NOT VALID");
      isLoading.value = false;
      return;
    } else {
      isLoading.value = true;
      addressFormKey.currentState!.save();
      AddCustomerAddressBody addCustomerAddressBody = AddCustomerAddressBody(longitude: addressCoordinate!.longitude.toDouble(), latitude: addressCoordinate!.latitude.toDouble(), address: address, phone: phone, recipientName: recipientName, villageName: villageName);

      print(addCustomerAddressBody.longitude);
      await saveAddress(addCustomerAddressBody).then((status) {
        if (status.isSuccess) {
          // Get.toNamed(RouteHelper.getOtpValidation(
          //     customerRegisterBody.email, customerRegisterBody.password));
          print("ADD ADDRESS SUCCESSFULLY");
          recipientName = "";
          address = "";
          phone = "";
          recipientNameController.clear();
          addressController.clear();
          phoneController.clear();
          // Get.until((route) => Get.currentRoute == RouteHelper.getAddressList());
          addressListController.getAllAddress();
          Get.back();
          return;
        }else{
          print("NOT SUCCESS");
        }
      });
    }
    isLoading.value = false;

  }


}