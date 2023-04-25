import 'package:get/get.dart';
import 'package:kateringku_mobile/data/repositories/cart_repo.dart';
import 'package:kateringku_mobile/models/add_cart_body.dart';
import 'package:kateringku_mobile/models/cart_model.dart';
import 'package:kateringku_mobile/models/new_cart_model.dart';
import 'package:kateringku_mobile/screens/cart/cart_view.dart';
import 'package:kateringku_mobile/screens/home/home_view.dart';

class CartController extends GetxController implements GetxService{

  final CartRepo cartRepo;

  CartController({required this.cartRepo});
  
  var isLoading = false.obs;
  var isDeleteLoading = false.obs;

  var carts = <NewCartModel>[];

  // @override
  // void onInit() {
  //   super.onInit();
  //   // await
  // }


  Future<void> getAllCart() async{
    isLoading.value = true;

    carts.clear();

    Response response = await cartRepo.getCarts();

    if(response.statusCode == 200){
      for(var i = 0 ; i < response.body['carts'].length ; i++){
        NewCartModel newCartModel = NewCartModel.fromJson(response.body['carts'][i]);
        carts.add(newCartModel);
      }
    }

    isLoading.value = false;
  }

  // Future<void> deleteCart(int id) async{
  //   isLoadingPostPreOrder.value = true;
  //
  //   Response response = await preOrderRepo.deleteCart(id);
  //
  //   isLoadingPostPreOrder.value = false;
  // }

  Future<void> deleteCart(int id) async {
    isDeleteLoading.value = true;

    Response response = await cartRepo.deleteCart(id);

    isDeleteLoading.value = false;
  }


  // Future<void> getAllCart() async{
  //   isLoading.value = true;
  //   cartRepo.setToken();
  //   Response response = await cartRepo.getCarts();
  //
  //   carts.clear();
  //
  //   for(var i = 0 ; i < response.body['carts'].length; i++){
  //     var products = <Product>[];
  //
  //     for(var j=0 ; j<response.body['carts'][i]['products'].length ; j++){
  //       Product product = Product(productId: response.body['carts'][i]['products'][j]['product_id'], name: response.body['carts'][i]['products'][j]['name'], price: response.body['carts'][i]['products'][j]['price'], quantity: response.body['carts'][i]['products'][j]['quantity'],);
  //
  //       products.add(product);
  //     }
  //
  //     CartModel cartModel = CartModel(id: response.body['carts'][i]['id'], customerId: response.body['carts'][i]['customer_id'], orderType: response.body['carts'][i]['order_type'], products: products, cateringName: response.body['carts'][i]['catering_name']);
  //
  //     carts.add(cartModel);
  //   }
  //   carts.refresh();
  //   // print(carts[0].id);
  //   isLoading.value = false;
  // }
  //
  // Future<void> saveCart(AddCartBody addCartBody) async{
  //   isLoading.value = true;
  //   cartRepo.setToken();
  //
  //   Response response = await cartRepo.saveCart(addCartBody);
  //   if(response.statusCode == 200){
  //     Get.offAll(HomeView(), arguments: [1]);
  //   }
  //
  // }
}