import 'dart:developer';

import 'package:get/get.dart';
import 'package:kateringku_mobile/data/repositories/cart_repo.dart';
import 'package:kateringku_mobile/models/product_model.dart';

import '../base/show_custom_snackbar.dart';
import '../data/repositories/catering_product_repo.dart';
import '../models/catering_product_model.dart';
import '../routes/route_helper.dart';
import '../screens/home/home_view.dart';

class CateringHomeController extends GetxController implements GetxService {
  final CateringProductRepo cateringProductRepo;
  final CartRepo cartRepo;

  var products = <ProductModel>[].obs;

  var totalQuantity = 0.obs;
  var totalPrice = 0.obs;

  CateringHomeController(
      {required this.cateringProductRepo, required this.cartRepo});

  var isLoading = false.obs;

  var isCartLoading = false.obs;

  var cateringId = "";

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

  void deleteController() {
    Get.delete<CateringHomeController>();
  }

  Future<void> getCateringProducts(String catering_id) async {
    isLoading.value = true;
    products.clear();
    Response response =
        await cateringProductRepo.getProductsFromCatering(catering_id);

    for (var i = 0; i < response.body['products'].length; i++) {
      // CateringProductModel cateringProductModel =
      //   CateringProductModel(
      //       product_id: response.body['products'][i]['id'].toString(),
      //       product_name: response.body['products'][i]['name'],
      //       product_description: response.body['products'][i]['description'],
      //       product_weight: response.body['products'][i]['weight'],
      //       minimum_quantity: response.body['products'][i]['minimum_quantity'],
      //       maximum_quantity: response.body['products'][i]['maximum_quantity'],
      //       is_free_delivery: response.body['products'][i]['is_free_delivery'],
      //       is_available: response.body['products'][i]['is_available'],
      //       product_image: response.body['products'][i]['original_path'],
      //     product_price: response.body['products'][i]['price'],
      //     product_is_customable: response.body['products'][i]['is_customable']
      //   );
      products.add(ProductModel.fromJson(response.body['products'][i]));
    }
    products.refresh();
    isLoading.value = false;
    update();
  }

  void addProductQuantity(int index, {bool fromCart = false}) {
    if (products[index].orderQuantity >= products[index].maximumQuantity!) {
      showCustomSnackBar(
          message: "Jumlah maksimal adalah ${products[index].maximumQuantity!}",
          title: "JUMLAH TELAH MAKSIMAL");
      return;
    }
    if (fromCart) {
      totalPrice.value += products[index].fixPrice();
      totalQuantity += 1;
    } else if (products[index].minimumQuantity! >= 1 &&
        products[index].orderQuantity == 0) {
      totalPrice.value +=
          products[index].fixPrice() * products[index].minimumQuantity!;
      totalQuantity += products[index].minimumQuantity!;
    } else {
      totalPrice.value += products[index].fixPrice();
      totalQuantity += 1;
    }

    products[index].addQuantity(fromCart: fromCart);
    // products[index].quantity = products[index].quantity;
    products.refresh();
    // products[index].addQuantity();

    update();
  }

  void minusProductQuantity(int index) {
    if (products[index].orderQuantity == 0) {
      return;
    }

    if (products[index].orderQuantity <= products[index].minimumQuantity!) {
      totalPrice.value -=
          products[index].fixPrice() * products[index].minimumQuantity!;
      totalQuantity -= products[index].minimumQuantity!;
    } else {
      totalPrice.value -= products[index].fixPrice();
      totalQuantity -= 1;
    }

    products[index].subtractQuantity();

    if (products[index].orderQuantity == 0) {
      // return;
      products[index].additionalPrice = 0;
      products[index].productOptions!.forEach((productOption) {
        productOption.clearSelection();
      });
      products.refresh();
    }
    // products[index].quantity -= 1;
    // products[index].quantity = products[index].quantity;

    products.refresh();
    update();
  }

  List<ProductModel> collectAllOrder() {
    var allOrderList = <ProductModel>[];
    products.forEach((element) {
      if (element.orderQuantity > 0) {
        allOrderList.add(element);
      }
    });
    return allOrderList;
  }

  void totalPrices() {
    var totalPrices = 0;
    products.forEach((product) {
      totalPrices += product.fixPrice() * product.orderQuantity;
    });
    totalPrice.value = totalPrices;
  }

  Future<void> postCart() async {
    isCartLoading.value = true;

    Map<String, dynamic> cartRequest = <String, dynamic>{};
    cartRequest["catering_id"] = cateringId;
    cartRequest["order_type"] = "PREORDER";
    var allOrderProducts = collectAllOrder();
    if (allOrderProducts.isNotEmpty) {
      cartRequest['products'] =
          allOrderProducts.map((v) => v.toJson()).toList();
    }

    Response response = await cartRepo.postCart(cartRequest);

    if (response.statusCode == 200) {
      showCustomSnackBar(
          message: "Anda berhasil menambahkan order ke keranjang!",
          title: "Tambah Keranjang Berhasil");
      var homeController = Get.find<HomeController>();
      homeController.tabController.value.index = 1;
      Get.until((route) => Get.currentRoute == RouteHelper.mainHome);
    }

    isCartLoading.value = false;
  }

  void clearController() {
    getCateringProducts(cateringId);
    totalQuantity = 0.obs;
    totalPrice = 0.obs;
    products.refresh();
  }
}
