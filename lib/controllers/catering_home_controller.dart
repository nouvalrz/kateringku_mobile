import 'dart:developer';

import 'package:get/get.dart';

import '../data/repositories/catering_product_repo.dart';
import '../models/catering_product_model.dart';

class CateringHomeController extends GetxController implements GetxService{
  final CateringProductRepo cateringProductRepo;

  var products = <CateringProductModel>[].obs;

  var totalQuantity = 0.obs;
  var totalPrice = 0.obs;

  CateringHomeController({required this.cateringProductRepo});

  var isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    // products.clear();
  }

  @override
  void onClose() {
    super.onClose();
    Get.delete<CateringHomeController>();
  }


  void deleteController(){
    Get.delete<CateringHomeController>();
  }

  Future<void> getCateringProducts(String catering_id) async{
    // products.clear();
    isLoading.value = true;
    Response response = await cateringProductRepo.getProductsFromCatering(catering_id);

    print(response.body['products'].length);

    for(var i = 0 ; i < response.body['products'].length ; i++){
      CateringProductModel cateringProductModel =
        CateringProductModel(
            product_id: response.body['products'][i]['id'].toString(),
            product_name: response.body['products'][i]['name'],
            product_description: response.body['products'][i]['description'],
            product_weight: response.body['products'][i]['weight'],
            minimum_quantity: response.body['products'][i]['minimum_quantity'],
            maximum_quantity: response.body['products'][i]['maximum_quantity'],
            is_free_delivery: response.body['products'][i]['is_free_delivery'],
            is_available: response.body['products'][i]['is_available'],
            product_image: response.body['products'][i]['original_path'],
          product_price: response.body['products'][i]['price'],
        );
      products.add(cateringProductModel);

    }
    products.refresh();
    isLoading.value = false;
    update();
    // products.forEach((element) {
    //   print(element.product_name);
    // });
    //   print(products.length);
  }

  void addProductQuantity(int index){
    if(products[index].quantity >= products[index].maximum_quantity){
      return;
    }
    totalPrice.value += products[index].product_price;
    products[index].quantity += 1;
    products[index].quantity = products[index].quantity;
    products.refresh();
    // products[index].addQuantity();
    totalQuantity += 1;
    update();
  }

  void minusProductQuantity(int index){
    if(products[index].quantity == 0){
      return;
    }
    if(totalQuantity != 0){
      totalQuantity -= 1;
    }
    totalPrice.value -= products[index].product_price;
    products[index].quantity -= 1;
    products[index].quantity = products[index].quantity;
    products.refresh();
    update();
  }

    List<CateringProductModel> collectAllOrder(){
    var allOrderList = <CateringProductModel>[];
    products.forEach((element) {
      if(element.quantity > 0){
        allOrderList.add(element);
      }
    });
    // return allOrderList;
      return allOrderList;
  }

}