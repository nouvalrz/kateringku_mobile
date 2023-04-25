import 'package:get/get.dart';
import 'package:kateringku_mobile/data/repositories/catering_product_repo.dart';
import 'package:kateringku_mobile/data/repositories/instant_confirmation_repo.dart';
import 'package:kateringku_mobile/models/add_cart_body.dart';

import '../models/cart_model.dart';
import '../models/catering_product_model.dart';

class InstantConfirmationController extends GetxController implements GetxService{

  final InstantConfirmationRepo instantConfirmationRepo;
  List<Product> rawProducts;
  var products = <CateringProductModel>[];

  InstantConfirmationController({required this.instantConfirmationRepo, required this.rawProducts});
  
  var isLoading = false.obs;

  @override
  void onInit() async{
    super.onInit();
    products = await getProductDetail(rawProducts);
  }
  
  Future<List<CateringProductModel>> getProductDetail(List<Product> products) async{
    isLoading.value = true;
    instantConfirmationRepo.setToken();
    
    var finishProducts = <CateringProductModel>[];
    
    for(var i = 0 ; i < products.length ; i++){
      Response response = await instantConfirmationRepo.getProductDetail(products[i]);
      print("LALALAL");
      print(response.body);

      CateringProductModel cateringProductModel = CateringProductModel(product_id: response.body["id"].toString(), product_price: response.body["price"], product_name: response.body["name"], product_description: response.body["description"], product_weight: response.body["weight"], minimum_quantity: response.body["minimum_quantity"], maximum_quantity: response.body["maximum_quantity"], is_free_delivery: response.body["is_free_delivery"], is_available: response.body["is_available"], product_image: response.body["original_path"], product_is_customable: response.body["is_customable"]);

      finishProducts.add(cateringProductModel);
    }
    isLoading.value = false;
    print("FROM CONTOL");
    print(finishProducts.length);
    return finishProducts;
  }
}