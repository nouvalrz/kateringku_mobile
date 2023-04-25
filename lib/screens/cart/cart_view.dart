import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kateringku_mobile/controllers/cart_controller.dart';
import 'package:kateringku_mobile/models/catering_display_model.dart';
import 'package:kateringku_mobile/screens/pre_order/pre_order_confirmation_view.dart';

import '../../helpers/currency_format.dart';
import '../../routes/route_helper.dart';
import '../../themes/app_theme.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {

  var cartController = Get.find<CartController>();

  @override
  void initState(){
    super.initState();
    cartController.getAllCart();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: (){
        // orderListController.isLoading.value = true;
        cartController.getAllCart();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              child: SizedBox(
                height: 10,
                child: Container(
                  color: Colors.grey[200],
                  width: 600,
                ),
              ),
              top: 90,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 46),
                child: Container(
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text("Keranjang",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    cartController.getAllCart();
                                  },
                                  child: Icon(
                                    Icons.refresh_rounded,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(child: Obx(()=> cartController.isLoading.value ? Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen,),) : cartController.carts.isEmpty ? Center(child: Text("Keranjang anda masih kosong"),) : RefreshIndicator(
                onRefresh: ()async{
                  cartController.getAllCart();
                },
                color: Colors.white,
                backgroundColor: AppTheme.primaryGreen,
                child: ListView.builder(itemBuilder: (context, index){
                  return OrderTile(index: index,);
                }, itemCount: cartController.carts.length, padding: EdgeInsets.zero,),
              )))
              ,
            ])
          ],
        ),
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  int index;
   OrderTile({
    Key? key, required this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var cartController = Get.find<CartController>();

    return GestureDetector(
      onLongPress: (){
        Get.defaultDialog(textConfirm: "Hapus", textCancel: "Batal", middleTextStyle: AppTheme.textTheme.titleLarge!.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700]), middleText: "Yakin menghapus cart?", radius: 8, onConfirm: () async{
          await cartController.deleteCart(cartController.carts[index].id!);
          cartController.getAllCart();
          Get.back();
        });
      },
      child: ConfigurableExpansionTile(
        header: Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          cartController.carts[index].orderType == "PREORDER" ?  PreOrderBadge() : LanggananBadge(),
                          SizedBox(
                            height: 12,
                          ),
                          Text(cartController.carts[index].cateringName!,
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700])),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Column(children: [
                            Text(CurrencyFormat.convertToIdr(
                                cartController.carts[index].totalPrice(), 0),
                                style: AppTheme.textTheme.titleLarge!
                                    .copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                            Text("${cartController.carts[index].totalQuantity()} Item",
                                style: AppTheme.textTheme.titleLarge!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300)),
                          ], crossAxisAlignment: CrossAxisAlignment.end,),
                          SizedBox(width: 12,),
                          Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Colors.grey[600],
                            size: 30,
                          ),

                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8,),
                Divider(color: Colors.grey[400],)
              ],
            ),
          ),
        ),
        children: <Widget>[
          Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: [
                  Column(children:
                    List.generate(cartController.carts[index].cartDetails!.length, (index2) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${cartController.carts[index].cartDetails![index2].product!.name} x${cartController.carts[index].cartDetails![index2].quantity}",
                                style: AppTheme.textTheme.titleLarge!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                            if(cartController.carts[index].cartDetails![index2].productOptions!.isNotEmpty)
                            Row(
                              children: [
                                Icon(Icons.dashboard_customize_outlined, color: AppTheme.greyOutline, size: 16,),
                                SizedBox(width: 4),
                                Text("Kustom : " + cartController.carts[index].cartDetails![index2].concatProductOptions(), style: AppTheme.textTheme.titleLarge!
                                    .copyWith(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ],
                        ),
                        Text(CurrencyFormat.convertToIdr(
                            cartController.carts[index].cartDetails![index2].fixPrice(), 0),
                            style: AppTheme.textTheme.titleLarge!
                                .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),

                      ], crossAxisAlignment: CrossAxisAlignment.start,),
                    ))
                  ,),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(children: [
                      GestureDetector(
                        onTap: (){
                          // Get.to(InstantOrderConfirmationView(fromCart: true,), arguments: [cartController.carts[index].products]);
                        },
                        child: GestureDetector(
                          onTap: (){
                            var cateringDisplayModel = CateringDisplayModel(originalPath: cartController.carts[index].catering!.originalPath!, name: cartController.carts[index].catering!.name!, categories: cartController.carts[index].catering!.categories, village: cartController.carts[index].catering!.village, id: cartController.carts[index].cateringId!);
                            Get.toNamed(
                                RouteHelper.getCatering(
                                  catering_name: cartController.carts[index].catering!.name!,
                                  catering_image: cartController.carts[index].catering!.originalPath!,
                                  catering_location: cartController.carts[index].catering!.village!.name!,
                                  catering_id: cartController.carts[index].cateringId!.toString(),
                                  catering_latitude: double.parse(cartController.carts[index].catering!.latitude!),
                                  catering_longitude: double.parse(cartController.carts[index].catering!.longitude!),
                                  fromCart: "true"
                                ),
                                arguments: [cateringDisplayModel, cartController.carts[index]]);
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
                              child: Center(
                                child: Text("Checkout",
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppTheme.primaryGreen),
                              borderRadius: BorderRadius.circular(7),
                            ),

                          ),
                        ),
                      ),
                    ], mainAxisAlignment: MainAxisAlignment.end,),
                  ),
                  SizedBox(height: 6,),
                  Divider(color: Colors.grey[400],)
                ],
              ),
            )
          ], crossAxisAlignment: CrossAxisAlignment.start,)
        ],
      ),
    );
  }
}

class PreOrderBadge extends StatelessWidget {
  const PreOrderBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Pre Order",
            style: AppTheme.textTheme.titleLarge!
                .copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white)),
      ),
      decoration: BoxDecoration(
          color: AppTheme.primaryGreen,
          borderRadius: BorderRadius.circular(6)),
    );
  }
}

class LanggananBadge extends StatelessWidget {
  const LanggananBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Langganan",
            style: AppTheme.textTheme.titleLarge!
                .copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
      ),
      decoration: BoxDecoration(
          color: AppTheme.primaryOrange,
          borderRadius: BorderRadius.circular(6)),
    );
  }
}
