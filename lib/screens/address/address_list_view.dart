import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kateringku_mobile/controllers/address_controller.dart';
import 'package:kateringku_mobile/controllers/address_list_controller.dart';
import 'package:kateringku_mobile/controllers/customer_address_controller.dart';
import 'package:kateringku_mobile/controllers/customer_address_list_controller.dart';
import 'package:kateringku_mobile/controllers/pre_order_controller.dart';
import 'package:kateringku_mobile/data/api/api_client.dart';
import 'package:kateringku_mobile/data/repositories/customer_address_repo.dart';

import '../../components/primary_button.dart';
import '../../helpers/currency_format.dart';
import '../../models/customer_address_model.dart';
import '../../routes/route_helper.dart';
import '../../themes/app_theme.dart';

class AddressListView extends StatefulWidget {
  AddressListView({Key? key}) : super(key: key);

  @override
  State<AddressListView> createState() => _AddressListViewState();
}

class _AddressListViewState extends State<AddressListView>
    with WidgetsBindingObserver {
  var addressController = Get.find<AddressController>();
  var preOrderController = Get.find<PreOrderController>();

  @override
  void initState() {
    super.initState();
    addressController.getAllAddress();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: (){
        addressController.getAllAddress();
      },
      child: Scaffold(
        body: Stack(children: [
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
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text("Daftar Alamat",
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 29,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: Text("Alamat Anda",
                  style: AppTheme.textTheme.titleLarge!
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            Expanded(
              child: Obx(() {
                if (addressController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryGreen,
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          preOrderController.setCustomAddress(addressController.addresses[index]);
                          preOrderController.setSelectedAddress(addressController.addresses[index], false);
                          preOrderController.recalculatePrice();
                          Get.back();
                        },
                        child: AddressCard(
                          recipientName: addressController.addresses![index].recipientName!,
                          phone: addressController.addresses![index].phone!,
                          address: addressController.addresses![index].address!,
                          addressId: addressController.addresses![index].id!.toString(),
                        ),
                      );
                    },
                    itemCount: addressController.addresses!.length,
                    padding: EdgeInsets.only(bottom: 20),
                  );
                }
              }),
            ),
            SizedBox(height: 72,)
          ]),
          Align(
            child: SizedBox(
              height: 72,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[350]!)),
                    color: Colors.white),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteHelper.getAddAddressMap());
                          // addressListController.getAllAddress();
                        },
                        child: Container(
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                          width: 62,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppTheme.primaryGreen),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: PrimaryButton(
                            title: 'Pilih Alamat',
                            onTap: () {
                              Get.back();
                            },
                            state: ButtonState.idle),
                      )
                    ],
                  ),
                ),
              ),
            ),
            alignment: Alignment.bottomCenter,
          ),
        ]),
      ),
    );
  }
}

class ActiveAddressCard extends StatelessWidget {
  String recipientName;
  String phone;
  String address;

  ActiveAddressCard(
      {Key? key,
      required this.recipientName,
      required this.phone,
      required this.address})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 20),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppTheme.primaryGreen),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(recipientName,
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.check_circle_outline_outlined,
                        size: 20,
                        color: AppTheme.primaryGreen,
                      )
                    ],
                  ),
                  Icon(
                    Icons.more_vert,
                    size: 22,
                    color: Colors.grey[600],
                  )
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Text("+" + phone,
                  style: AppTheme.textTheme.titleLarge!
                      .copyWith(fontSize: 13, fontWeight: FontWeight.w400)),
              SizedBox(
                height: 12,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Text(address,
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                      // SizedBox(
                      //   width: 300,
                      //   child: Text(
                      //       "Kel. Pedungan, Kec. Denpasar Selatan, Kota Denpasar, Bali",
                      //       style: AppTheme.textTheme.titleLarge!.copyWith(
                      //           fontSize: 13, fontWeight: FontWeight.w400)),
                      // )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  String addressId;
  String recipientName;
  String phone;
  String address;

  AddressCard(
      {Key? key,
      required this.recipientName,
      required this.phone,
      required this.address,
      required this.addressId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 20),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Text(recipientName,
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ]),
                  Icon(
                    Icons.more_vert,
                    size: 22,
                    color: Colors.grey[600],
                  )
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Text("+" + phone,
                  style: AppTheme.textTheme.titleLarge!
                      .copyWith(fontSize: 13, fontWeight: FontWeight.w400)),
              SizedBox(
                height: 12,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Text(address,
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                      // SizedBox(
                      //   width: 300,
                      //   child: Text(
                      //       "Kel. Pedungan, Kec. Denpasar Selatan, Kota Denpasar, Bali",
                      //       style: AppTheme.textTheme.titleLarge!.copyWith(
                      //           fontSize: 13, fontWeight: FontWeight.w400)),
                      // )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
