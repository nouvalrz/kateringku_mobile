import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kateringku_mobile/controllers/customer_address_controller.dart';
import 'package:kateringku_mobile/models/catering_product_model.dart';

import '../../constants/app_constant.dart';
import '../../helpers/currency_format.dart';
import '../../themes/app_theme.dart';

class InstantOrderConfirmationView extends StatefulWidget {
  const InstantOrderConfirmationView({Key? key}) : super(key: key);

  @override
  State<InstantOrderConfirmationView> createState() =>
      _InstantOrderConfirmationViewState();
}

class _InstantOrderConfirmationViewState
    extends State<InstantOrderConfirmationView> {

  var allOrderList = <CateringProductModel>[];
  var totalPrice = 0;

  var customerAddressController = Get.find<CustomerAddressController>();

  @override
  void initState(){
    super.initState();
    var state = Get.arguments;
    allOrderList = state[0];
    totalPrice = state[1].value;
    // print(allOrderList);
    // print(totalPrice);
    // print(customerAddressController.addressList);
    // print("DELIMITER FROM VIEW");
    // print(customerAddressController.mainAddress);
  }

  @override
  Widget build(BuildContext context) {
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
            top: 90,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 46),
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text("Konfirmasi Pesanan Instan",
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height:29,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25, top: 0),
                          child: Obx(() => customerAddressController.isLoading.value ? Center(child: Text("LOADING"),) :  Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Alamat Pengantaran",
                                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                                fontSize: 14, fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          height: 14,
                                        ),
                                        Row(
                                          children: [
                                            Text(customerAddressController.mainAddress!.recipient_name,
                                                style: AppTheme.textTheme.titleLarge!
                                                    .copyWith(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w400)),
                                            SizedBox(
                                              child: VerticalDivider(
                                                color: Colors.grey[500],
                                                thickness: 0.7,
                                              ),
                                              height: 16,
                                            ),
                                            Text("+6285156878006",
                                                style: AppTheme.textTheme.titleLarge!
                                                    .copyWith(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w400)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.pin_drop_outlined,
                                              color: Colors.grey[600],
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            SizedBox(
                                              child: Text(
                                                  customerAddressController.mainAddress!.address,
                                                  style: AppTheme.textTheme.titleLarge!
                                                      .copyWith(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w400)),
                                              width: 260,
                                            ),
                                          ],
                                        ),



                                      ],
                                    ),
                                    Text("Ganti",
                                        style: AppTheme.textTheme.titleLarge!.copyWith(
                                            fontSize: 13, fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ],
                            ),
                          )),
                        ),
                        SizedBox(
                          height: 14,
                        ),

                        Divider(color: Colors.grey[200], thickness: 10,),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 25, right: 25, bottom: 16),
                          child: Text("Pesanan Anda",
                              style: AppTheme.textTheme.titleLarge!
                                  .copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                        ),

                        ListView.builder(itemBuilder: (context, index){
                          return ProductCard(productName: allOrderList[index].product_name, productDesc: allOrderList[index].product_description, productImage: allOrderList[index].product_image, productPrice: allOrderList[index].product_price, productQuantity: allOrderList[index].quantity,);
                        }, itemCount: allOrderList.length, shrinkWrap: true, physics: NeverScrollableScrollPhysics(), padding: EdgeInsets.zero,),
                        Divider(color: Colors.grey[200], thickness: 10,),
                        Padding(
                          padding: EdgeInsets.only(left: 25, right: 25, bottom: 16, top: 14),
                          child: Text("Ringkasan Pembayaran",
                              style: AppTheme.textTheme.titleLarge!
                                  .copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 25, right: 25,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Subtotal Harga",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(fontSize: 12, fontWeight: FontWeight.w300)),
                              Text(CurrencyFormat.convertToIdr(
                                  totalPrice, 0),
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(fontSize: 12, fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                        SizedBox(height: 8,),
                        Padding(
                          padding: EdgeInsets.only(left: 25, right: 25,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Ongkos Kirim",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(fontSize: 12, fontWeight: FontWeight.w300)),
                              Text("GRATIS",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(fontSize: 12, fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                        SizedBox(height: 4,),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Divider(color: Colors.grey[300], thickness: 1,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 25, right: 25,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Harga",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(fontSize: 13, fontWeight: FontWeight.w500)),
                              Text(CurrencyFormat.convertToIdr(
                                  totalPrice, 0),
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        SizedBox(height: 36,)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 72,)
            ],
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

                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text("Total Harga",
                                      style: AppTheme.textTheme.titleLarge!
                                          .copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400)),

                                  SizedBox(height: 1,),
                                  Text(CurrencyFormat.convertToIdr(
                                    totalPrice, 0),
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),

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
                    Container(
                      height: 72,
                      width: 150,
                      color: AppTheme.primaryOrange,
                      child: Center(
                        child: Text("Pilih Pembayaran",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
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

class ProductCard extends StatelessWidget {

  String productName;
  String productDesc;
  int productPrice;
  String productImage;
  int productQuantity;

  ProductCard({
    Key? key,
    required this.productDesc,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productQuantity
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                        image: NetworkImage(
                            AppConstant.BASE_URL + productImage.substring(1))),
                  ),
                ),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(productName,
                          style: AppTheme.textTheme.titleLarge!
                              .copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                      Text(productDesc,
                          style: AppTheme.textTheme.titleLarge!
                              .copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300)),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text(
                                    CurrencyFormat.convertToIdr(
                                        productPrice, 0),
                                    style: AppTheme
                                        .textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 12,
                                            fontWeight:
                                                FontWeight.w500)),


                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [

                                    SizedBox(
                                      width: 32,
                                      height: 28,
                                      child: TextFormField(
                                        readOnly: true,
                                          initialValue: productQuantity.toString(),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                3),
                                          ],
                                          keyboardType:
                                              TextInputType.number,
                                          textAlign:
                                              TextAlign.center,
                                          style: AppTheme
                                              .textTheme.titleLarge!
                                              .copyWith(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight
                                                          .w400),
                                          decoration:
                                              InputDecoration(
                                            contentPadding:
                                                const EdgeInsets
                                                        .fromLTRB(
                                                    0, 0, 0, 0),
                                          )),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Divider(
              color: Colors.grey[300],
            ),
            SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }
}
