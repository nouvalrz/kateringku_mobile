import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kateringku_mobile/constants/vector_path.dart';
import 'package:kateringku_mobile/controllers/catering_home_controller.dart';
import 'package:kateringku_mobile/data/repositories/catering_product_repo.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';

import '../../base/show_custom_snackbar.dart';
import '../../constants/app_constant.dart';
import '../../data/api/api_client.dart';
import '../../helpers/currency_format.dart';
import '../../routes/route_helper.dart';

class _CateringViewState extends State<CateringView> {
  var cateringProductController = Get.find<CateringHomeController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // var relevantCateringProductsController = Get.find<CateringHomeController>();
    // relevantCateringProductsController.getCateringProducts(widget.catering_id);
    // Get.delete<CateringHomeController>();
    // var relevantCateringProductsController = Get.find<CateringHomeController>();
    cateringProductController.getCateringProducts(widget.catering_id);
    cateringProductController.totalPrice.value = 0;
    cateringProductController.totalQuantity.value = 0;
  }

  //
  // @override
  //   void dispose() {
  //     // Get.delete<CateringHomeController>();
  //     relevantCateringProductsController.products.clear();
  //     super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    // var relevantCateringProductsController = Get.find<CateringHomeController>();
    // relevantCateringProductsController.getCateringProducts(widget.catering_id);
    // print("LALSSSSSSALA");
    return Scaffold(
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
            top: 220,
          ),
          Align(
            child: SvgPicture.asset(VectorPath.greenRadial),
            alignment: Alignment.topRight,
          ),
          Padding(
            padding: EdgeInsets.only(top: 46, left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.grey,
                    )
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                            image: NetworkImage(AppConstant.BASE_URL +
                                widget.catering_image.substring(1))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          Text(
                            widget.catering_name,
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text("Aneka Nasi, Vegan",
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w400)),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey[600],
                              ),
                              Text(
                                widget.catering_location,
                                style: AppTheme.textTheme.labelSmall!
                                    .copyWith(fontSize: 11),
                              ),
                              SizedBox(
                                child: VerticalDivider(
                                  color: Colors.grey[500],
                                  thickness: 0.7,
                                ),
                                height: 16,
                              ),
                              Text(
                                "Terjual 222",
                                style: AppTheme.textTheme.labelSmall!
                                    .copyWith(fontSize: 11),
                              ),
                            ],
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 66,
                ),
                Text('Produk Katering',
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 18,
                ),
                Expanded(
                    child: Obx(
                  () => SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product_desc: cateringProductController
                              .products[index].product_description,
                          product_image: cateringProductController
                              .products[index].product_image,
                          product_name: cateringProductController
                              .products[index].product_name,
                          product_price: cateringProductController
                              .products[index].product_price
                              .toString(),
                          index: index,
                        );
                      },
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          cateringProductController.products.value.length,
                    ),
                  ),
                )),
                SizedBox(
                  height: 72,
                )
              ],
            ),
          ),
          Align(
            child: SizedBox(
              height: 72,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[350]!)),
                    color: Colors.white),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text("Pesan\nLangganan",
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Obx(
                          ()=> Text(CurrencyFormat.convertToIdr(
                                    cateringProductController.totalPrice.value, 0),
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500)),
                              ),
                              Obx(()=>
                                Text(cateringProductController.totalQuantity.value.toString() + " Item",
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w300)),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    GestureDetector(
                      onTap: (){
                        if(cateringProductController.totalQuantity == 0){
                          showCustomSnackBar(message: "Harap memilih minimal 1 produk", title: "ORDER KOSONG");
                        }else{
                          var allOrderList = cateringProductController.collectAllOrder();
                          Get.toNamed(RouteHelper.getInstantOrderConfirmation(), arguments: [allOrderList, cateringProductController.totalPrice]);
                        }
                      },
                      child: Container(
                        height: 72,
                        width: 126,
                        color: AppTheme.primaryOrange,
                        child: Center(
                          child: Text("Pesan Instan",
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            alignment: Alignment.bottomCenter,
          )
        ],
      ),
    );
  }
}

class CateringView extends StatefulWidget {
  String catering_id;
  String catering_name;
  String catering_location;
  String catering_image;

  CateringView(
      {Key? key,
      required this.catering_name,
      required this.catering_location,
      required this.catering_image,
      required this.catering_id})
      : super(key: key);

  @override
  State<CateringView> createState() => _CateringViewState();
}

class ProductCard extends StatelessWidget {
  String product_name;
  String product_desc;
  String product_price;
  String product_image;
  int index;

  ProductCard(
      {Key? key,
      required this.product_name,
      required this.product_desc,
      required this.product_image,
      required this.product_price,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cateringProductController = Get.find<CateringHomeController>();
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                      image: NetworkImage(
                          AppConstant.BASE_URL + product_image.substring(1))),
                ),
              ),
              SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(product_name,
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    Text(
                        product_desc.length > 32
                            ? '${product_desc.substring(0, 32)}...'
                            : product_desc,
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 11, fontWeight: FontWeight.w300)),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text(
                                  CurrencyFormat.convertToIdr(
                                      int.parse(product_price), 0),
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                              SizedBox(
                                child: VerticalDivider(
                                  color: Colors.grey[500],
                                  thickness: 0.7,
                                ),
                                height: 16,
                              ),
                              Text("Terjual 26",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                        Obx(() {
                          if (cateringProductController
                                  .products[index].quantity ==
                              0) {
                            return GestureDetector(
                              onTap: () => cateringProductController
                                  .addProductQuantity(index),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppTheme.primaryGreen,
                                    borderRadius: BorderRadius.circular(4)),
                                height: 28,
                                width: 28,
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => cateringProductController.minusProductQuantity(index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppTheme.primaryGreen,
                                              borderRadius: BorderRadius.circular(4)),
                                          height: 28,
                                          width: 28,
                                          child: Center(
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),

                                      SizedBox(
                                        width: 32,
                                        height: 28,
                                        child: Obx(
                                        ()=> TextFormField(
                                            key: Key(cateringProductController
                                                .products[index].quantity
                                                .toString()),
                                              initialValue: cateringProductController
                                                  .products[index].quantity
                                                  .toString(),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(3),
                                              ],
                                              keyboardType: TextInputType.number,
                                              textAlign: TextAlign.center,
                                              style: AppTheme.textTheme.titleLarge!
                                                  .copyWith(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      GestureDetector(
                                        onTap: ()=> cateringProductController.addProductQuantity(index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppTheme.primaryGreen,
                                              borderRadius: BorderRadius.circular(4)),
                                          height: 28,
                                          width: 28,
                                          child: Center(
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if(cateringProductController.products[index].quantity > 0 && cateringProductController.products[index].quantity < cateringProductController.products[index].minimum_quantity)
                                  Text("Min. " + cateringProductController.products[index].minimum_quantity.toString(), style: AppTheme.textTheme.titleLarge!.copyWith(
                                      fontSize: 11, fontWeight: FontWeight.w300))
                                  else if(cateringProductController.products[index].quantity >= cateringProductController.products[index].maximum_quantity)
                                    Text("Max. " + cateringProductController.products[index].maximum_quantity.toString(), style: AppTheme.textTheme.titleLarge!.copyWith(
                                        fontSize: 11, fontWeight: FontWeight.w300))
                                ],
                              ),
                            );
                          }
                        })
                      ],
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              // Expanded(
              //     child: Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     SizedBox(height: 32,),
              //
              //   ],
              // ))
            ],
          ),
          SizedBox(
            height: 14,
          ),
          Divider(
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}
