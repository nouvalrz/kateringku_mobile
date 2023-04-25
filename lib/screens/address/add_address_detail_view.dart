import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kateringku_mobile/controllers/save_address_controller.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../components/primary_button.dart';
import '../../constants/vector_path.dart';
import '../../routes/route_helper.dart';
import '../../themes/app_theme.dart';

class AddAddressDetailView extends StatefulWidget {
  const AddAddressDetailView({Key? key}) : super(key: key);

  @override
  State<AddAddressDetailView> createState() => _AddAddressDetailViewState();
}

class _AddAddressDetailViewState extends State<AddAddressDetailView> {

  LatLng? customerCoordinate;
  String? village;
  String? district;
  String? regency;
  String? province;

  var saveAddressController = Get.find<SaveAddressController>();

  @override

  void initState(){
    super.initState();
    var state = Get.arguments;
    customerCoordinate = state[0];
    village = state[1];
    district = state[2];
    regency = state[3];
    province = state[4];
    print(customerCoordinate);
    saveAddressController.addressCoordinate = customerCoordinate;
    saveAddressController.villageName = village!;
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
                      Text("Masukkan Detail Alamat",
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 42),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12,),
                      Padding(
                        padding: EdgeInsets.only(left: 25, right: 25,),
                        child: Row(
                          children: [
                            Text("Lokasi Pin Anda",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w500))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top: 20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.pin_drop_outlined,
                              color: Colors.grey[600],
                              size: 28,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Column(
                              children: [
                                Text(village!,
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 4,
                                ),
                                SizedBox(
                                  width: 300,
                                  child: Text(
                                      "$district, $regency, $province",
                                      style: AppTheme.textTheme.titleLarge!
                                          .copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400)),
                                )
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            )
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Divider(
                        color: Colors.grey[200],
                        thickness: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top: 12),
                        child: Form(
                          key: saveAddressController.addressFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Detail Alamat",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 18,),
                              Text(
                                  "Nama Penerima",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 12,),
                              TextFormField(
                                controller: saveAddressController.recipientNameController,
                                onSaved: (value) {
                                  saveAddressController.recipientName = value!;
                                },
                                validator: (value) {
                                  return saveAddressController.validateName(value!);
                                },
                                keyboardType: TextInputType.text,
                                decoration:  InputDecoration(hintText: '',errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 215, 80, 46),
                                        width: 0.6)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(255, 215, 80, 46),
                                          width: 0.6)),),
                                style: AppTheme.textTheme.labelMedium,
                              ),
                              SizedBox(height: 16,),
                              Text(
                                  "Alamat Lengkap",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 12,),
                              SizedBox(
                                child: TextFormField(
                                  controller: saveAddressController.addressController,
                                  onSaved: (value) {
                                    saveAddressController.address = value!;
                                  },
                                  validator: (value) {
                                    return saveAddressController.validateAddress(value!);
                                  },
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration:  InputDecoration(hintText: '',errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(255, 215, 80, 46),
                                          width: 0.6)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(255, 215, 80, 46),
                                            width: 0.6)),),
                                  style: AppTheme.textTheme.labelMedium,
                                ),
                              ),
                              SizedBox(height: 16,),
                              Text(
                                  "No. HP",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 12,),
                              SizedBox(
                                child: TextFormField(
                                  controller: saveAddressController.phoneController,
                                  onSaved: (value) {
                                    saveAddressController.phone = value!;
                                  },
                                  validator: (value) {
                                    return saveAddressController.validatePhone(value!);
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '',
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        left: 12,
                                      ),
                                      child: SvgPicture.asset(VectorPath.phoneCode),
                                    ),
                                    prefixIconConstraints: const BoxConstraints(
                                        maxHeight: 120,
                                        maxWidth: 120,
                                        minWidth: 46,
                                        minHeight: 56),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(255, 215, 80, 46),
                                            width: 0.6)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(255, 215, 80, 46),
                                            width: 0.6)),
                                  ),
                                  style: AppTheme.textTheme.labelMedium,
                                ),
                              ),
                              SizedBox(height: 16,),
                              Text(
                                  "Provinsi",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 12,),
                              TextFormField(
                                readOnly: true,
                                initialValue: province,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(hintText: ''),
                                style: AppTheme.textTheme.labelMedium,
                              ),
                              SizedBox(height: 16,),
                              Text(
                                  "Kabupaten / Kota",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 12,),
                              TextFormField(
                                readOnly: true,
                                initialValue: regency,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(hintText: ''),
                                style: AppTheme.textTheme.labelMedium,
                              ),
                              SizedBox(height: 16,),
                              Text(
                                  "Kecamatan",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 12,),
                              TextFormField(
                                readOnly: true,
                                initialValue: district,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(hintText: ''),
                                style: AppTheme.textTheme.labelMedium,
                              ),
                              SizedBox(height: 16,),
                              Text(
                                  "Kelurahan",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 12,),
                              TextFormField(
                                readOnly: true,
                                initialValue: village,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(hintText: ''),
                                style: AppTheme.textTheme.labelMedium,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 72,
              )
            ],
          ),
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
                      Expanded(
                        child: Obx(()=>PrimaryButton(
                            title: 'Tambah Alamat',
                            onTap: () {
                              saveAddressController
                                  .checkFormAddressValidation();

                            },
                            state: saveAddressController.isLoading.value ? ButtonState.loading : ButtonState.idle),
                      ))
                    ],
                  ),
                ),
              ),
            ),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
}
