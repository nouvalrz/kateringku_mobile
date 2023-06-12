// import 'dart:html';

import 'dart:async';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:kateringku_mobile/base/show_custom_snackbar.dart';
import 'package:kateringku_mobile/controllers/catering_pre_order_detail_controller.dart';
import 'package:kateringku_mobile/controllers/catering_subs_order_detail_controller.dart';
import 'package:kateringku_mobile/controllers/complaint_controller.dart';
import 'package:kateringku_mobile/controllers/pre_order_detail_controller.dart';
import 'package:kateringku_mobile/controllers/review_controller.dart';
import 'package:kateringku_mobile/routes/route_helper.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:nil/nil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/primary_button.dart';
import '../../constants/app_constant.dart';
import '../../constants/image_path.dart';
import '../../controllers/order_list_controller.dart';
import '../../helpers/currency_format.dart';
import '../../themes/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';

class CateringSubsOrderDetailView extends StatefulWidget {
  const CateringSubsOrderDetailView({Key? key}) : super(key: key);

  @override
  State<CateringSubsOrderDetailView> createState() =>
      _CateringSubsOrderDetailViewState();
}

class _CateringSubsOrderDetailViewState
    extends State<CateringSubsOrderDetailView> {
  // late ReviewController reviewController;
  // late ComplaintController complaintController;
  var orderDetailController = Get.find<CateringSubsOrderDetailController>();
  int? id;
  late int orderTodayIndex;

  @override
  void initState() {
    super.initState();
    id = Get.arguments!;
    orderDetailController.getOrderDetail(id!).then((value) {
      orderTodayIndex = orderDetailController.subsOrderDetailModel!.orders!
          .indexWhere((element) {
        return DateTime.parse(element.deliveryDatetime!).day ==
            DateTime.now().day;
      });
    });
    initializeDateFormatting('id');
  }

  // void showModalSentConfirmation() async {
  //   await showModalBottomSheet(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(12.0),
  //       ),
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           height: 400,
  //           decoration: BoxDecoration(
  //               color: Colors.white, borderRadius: BorderRadius.circular(12)),
  //           child: Padding(
  //             padding: const EdgeInsets.only(
  //                 left: 12, right: 16, top: 20, bottom: 20),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Text(
  //                           "Konfirmasi Diterima",
  //                           style: AppTheme.textTheme.labelMedium!.copyWith(
  //                               fontWeight: FontWeight.w600, fontSize: 14),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 ),
  //                 const SizedBox(
  //                   height: 12,
  //                 ),
  //                 Container(
  //                   child: SvgPicture.asset(ImagePath.sentConfirmation),
  //                   width: 230,
  //                   height: 230,
  //                 ),
  //                 Text(
  //                   "Apakah pesanan anda telah diterima dengan baik?",
  //                   textAlign: TextAlign.center,
  //                   style: AppTheme.textTheme.labelMedium!
  //                       .copyWith(fontWeight: FontWeight.w500, fontSize: 13),
  //                 ),
  //                 Expanded(
  //                   child: Container(),
  //                 ),
  //                 Row(
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         Get.back();
  //                         complaintController = Get.find<ComplaintController>();
  //                         showModalComplaint();
  //                       },
  //                       child: Container(
  //                         child: Center(
  //                           child: Text(
  //                             "Komplain",
  //                             textAlign: TextAlign.center,
  //                             style: AppTheme.textTheme.labelMedium!.copyWith(
  //                                 fontWeight: FontWeight.w500,
  //                                 fontSize: 14,
  //                                 color: AppTheme.primaryRed),
  //                           ),
  //                         ),
  //                         width: 120,
  //                         height: 60,
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           border: Border.all(color: AppTheme.greyOutline),
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       width: 12,
  //                     ),
  //                     Expanded(child: Obx(() {
  //                       return PrimaryButton(
  //                           title: 'Konfirmasi',
  //                           onTap: () async {
  //                             // profileController.logout();
  //                             await orderDetailController.setOrderToAccepted();
  //                             await orderDetailController.getOrderDetail(id!);
  //                             Get.back();
  //                           },
  //                           state: orderDetailController
  //                                   .isSetOrderToAcceptedLoading.value
  //                               ? ButtonState.loading
  //                               : ButtonState.idle);
  //                     }))
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
  //
  // void showModalDisplayComplaint() async {
  //   await showModalBottomSheet(
  //       // isScrollControlled: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(12), topRight: Radius.circular(12)),
  //       ),
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (context) {
  //         return SingleChildScrollView(
  //           physics: BouncingScrollPhysics(),
  //           child: Padding(
  //             padding: EdgeInsets.only(
  //                 left: 25,
  //                 right: 25,
  //                 top: 20,
  //                 bottom: MediaQuery.of(context).viewInsets.bottom + 20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Text(
  //                       "Status Komplain",
  //                       style: AppTheme.textTheme.labelMedium!.copyWith(
  //                           fontWeight: FontWeight.w600, fontSize: 14),
  //                     ),
  //                     Text(
  //                       orderDetailController.subsOrderDetailModel.invoiceNumber!,
  //                       style: AppTheme.textTheme.labelMedium!.copyWith(
  //                           fontWeight: FontWeight.w400, fontSize: 12),
  //                     ),
  //                   ],
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 ),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 Container(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             "Status Pengajuan Komplain",
  //                             style: AppTheme.textTheme.labelMedium!.copyWith(
  //                                 fontWeight: FontWeight.w500, fontSize: 13),
  //                           ),
  //                           SizedBox(
  //                             height: 10,
  //                           ),
  //                           Container(
  //                             padding: EdgeInsets.all(8),
  //                             child: Text(
  //                               orderDetailController
  //                                   .orderDetail.value.complaint!
  //                                   .statusWording()!,
  //                               style: AppTheme.textTheme.labelMedium!.copyWith(
  //                                   fontWeight: FontWeight.w500,
  //                                   fontSize: 13,
  //                                   color: Colors.white),
  //                             ),
  //                             decoration:
  //                                 BoxDecoration(color: AppTheme.primaryOrange),
  //                           ),
  //                           SizedBox(
  //                             height: 10,
  //                           ),
  //                           Text(
  //                             "Tipe Masalah",
  //                             style: AppTheme.textTheme.labelMedium!.copyWith(
  //                                 fontWeight: FontWeight.w500, fontSize: 13),
  //                           ),
  //                           SizedBox(
  //                             height: 10,
  //                           ),
  //                           Container(
  //                             padding: EdgeInsets.all(8),
  //                             child: Text(
  //                               orderDetailController
  //                                   .orderDetail.value.complaint!
  //                                   .problemWording()!,
  //                               style: AppTheme.textTheme.labelMedium!.copyWith(
  //                                   fontWeight: FontWeight.w500,
  //                                   fontSize: 13,
  //                                   color: Colors.white),
  //                             ),
  //                             decoration:
  //                                 BoxDecoration(color: AppTheme.primaryGreen),
  //                           ),
  //                           SizedBox(
  //                             height: 10,
  //                           ),
  //                           Text(
  //                             "Gambar Bukti",
  //                             style: AppTheme.textTheme.labelMedium!.copyWith(
  //                                 fontWeight: FontWeight.w500, fontSize: 13),
  //                           ),
  //                           const SizedBox(
  //                             height: 12,
  //                           ),
  //                           // RatingBar.builder(
  //                           //   initialRating: 0,
  //                           //   minRating: 1,
  //                           //   direction: Axis.horizontal,
  //                           //   allowHalfRating: false,
  //                           //   itemCount: 5,
  //                           //   itemPadding:
  //                           //       const EdgeInsets.symmetric(horizontal: 4.0),
  //                           //   itemBuilder: (context, _) => const Icon(
  //                           //     Icons.star,
  //                           //     color: Colors.amber,
  //                           //   ),
  //                           //   onRatingUpdate: (rating) {
  //                           //     // reviewController.ratingStar.value = rating;
  //                           //   },
  //                           // ),
  //                           // const SizedBox(
  //                           //   height: 12,
  //                           // ),
  //                           ListView.builder(
  //                             shrinkWrap: true,
  //                             physics: NeverScrollableScrollPhysics(),
  //                             itemBuilder: (context, index) {
  //                               return Padding(
  //                                 padding: const EdgeInsets.only(bottom: 8),
  //                                 child: Row(
  //                                   children: [
  //                                     Expanded(
  //                                         child: Container(
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.all(8.0),
  //                                         child: Row(
  //                                           mainAxisAlignment:
  //                                               MainAxisAlignment.spaceBetween,
  //                                           children: [
  //                                             Row(
  //                                               children: [
  //                                                 ClipRRect(
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           5),
  //                                                   child: SizedBox(
  //                                                     width: 80,
  //                                                     height: 80,
  //                                                     child: FancyShimmerImage(
  //                                                       imageUrl: AppConstant
  //                                                               .BASE_URL +
  //                                                           orderDetailController
  //                                                               .orderDetail
  //                                                               .value
  //                                                               .complaint!
  //                                                               .images![index]
  //                                                               .image!
  //                                                               .substring(1),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                                 SizedBox(
  //                                                   width: 12,
  //                                                 ),
  //                                                 Text(
  //                                                   "Gambar ${index + 1}",
  //                                                   style: AppTheme
  //                                                       .textTheme.labelMedium!
  //                                                       .copyWith(
  //                                                           fontWeight:
  //                                                               FontWeight.w400,
  //                                                           fontSize: 12),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                       // height: 200,
  //                                       decoration: BoxDecoration(
  //                                           color: Colors.grey[50],
  //                                           borderRadius:
  //                                               BorderRadius.circular(6),
  //                                           border: Border.all(
  //                                               color: AppTheme.greyOutline,
  //                                               width: 0.6)),
  //                                     )),
  //                                   ],
  //                                 ),
  //                               );
  //                             },
  //                             itemCount: orderDetailController
  //                                 .orderDetail.value.complaint!.images!.length,
  //                           ),
  //                           const SizedBox(
  //                             height: 24,
  //                           ),
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
  //
  // void showModalComplaint() async {
  //   await showModalBottomSheet(
  //       // isScrollControlled: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(12), topRight: Radius.circular(12)),
  //       ),
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (context) {
  //         return SingleChildScrollView(
  //           physics: BouncingScrollPhysics(),
  //           child: Padding(
  //             padding: EdgeInsets.only(
  //                 left: 25,
  //                 right: 25,
  //                 top: 20,
  //                 bottom: MediaQuery.of(context).viewInsets.bottom + 20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Text(
  //                       "Ajukan Komplain",
  //                       style: AppTheme.textTheme.labelMedium!.copyWith(
  //                           fontWeight: FontWeight.w600, fontSize: 14),
  //                     ),
  //                     Text(
  //                       orderDetailController.orderDetail.value.invoiceNumber!,
  //                       style: AppTheme.textTheme.labelMedium!.copyWith(
  //                           fontWeight: FontWeight.w400, fontSize: 12),
  //                     ),
  //                   ],
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 ),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 Container(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             "Pilih Masalah",
  //                             style: AppTheme.textTheme.labelMedium!.copyWith(
  //                                 fontWeight: FontWeight.w500, fontSize: 13),
  //                           ),
  //                           SizedBox(
  //                             height: 4,
  //                           ),
  //                           Text(
  //                             "Sesuaikan dengan kendalamu ya",
  //                             style: AppTheme.textTheme.labelMedium!.copyWith(
  //                                 fontWeight: FontWeight.w400, fontSize: 11),
  //                           ),
  //                           SizedBox(
  //                             height: 10,
  //                           ),
  //                           GroupButton(
  //                             options: GroupButtonOptions(
  //                                 mainGroupAlignment: MainGroupAlignment.start,
  //                                 borderRadius: BorderRadius.circular(5),
  //                                 selectedColor: AppTheme.primaryGreen,
  //                                 runSpacing: 2,
  //                                 unselectedTextStyle:
  //                                     AppTheme.textTheme.labelMedium!.copyWith(
  //                                         fontWeight: FontWeight.w500,
  //                                         fontSize: 13),
  //                                 selectedTextStyle:
  //                                     AppTheme.textTheme.labelMedium!.copyWith(
  //                                         fontWeight: FontWeight.w600,
  //                                         fontSize: 13,
  //                                         color: Colors.white)),
  //                             isRadio: true,
  //                             onSelected: (value, index, isSelected) {
  //                               complaintController.problem = value.toString();
  //                               print(value);
  //                             },
  //                             // onSelected: (index, isSelected) => print('$index button is selected'),
  //                             buttons: [
  //                               "Makanan Rusak",
  //                               "Belum Sampai",
  //                               "Ada yang Kurang",
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             height: 10,
  //                           ),
  //                           Text(
  //                             "Gambar Bukti",
  //                             style: AppTheme.textTheme.labelMedium!.copyWith(
  //                                 fontWeight: FontWeight.w500, fontSize: 13),
  //                           ),
  //                           SizedBox(
  //                             height: 4,
  //                           ),
  //                           Text(
  //                             "Unggah maksimal 3 foto",
  //                             style: AppTheme.textTheme.labelMedium!.copyWith(
  //                                 fontWeight: FontWeight.w400, fontSize: 11),
  //                           ),
  //                           const SizedBox(
  //                             height: 12,
  //                           ),
  //                           // RatingBar.builder(
  //                           //   initialRating: 0,
  //                           //   minRating: 1,
  //                           //   direction: Axis.horizontal,
  //                           //   allowHalfRating: false,
  //                           //   itemCount: 5,
  //                           //   itemPadding:
  //                           //       const EdgeInsets.symmetric(horizontal: 4.0),
  //                           //   itemBuilder: (context, _) => const Icon(
  //                           //     Icons.star,
  //                           //     color: Colors.amber,
  //                           //   ),
  //                           //   onRatingUpdate: (rating) {
  //                           //     // reviewController.ratingStar.value = rating;
  //                           //   },
  //                           // ),
  //                           // const SizedBox(
  //                           //   height: 12,
  //                           // ),
  //                           Obx(() {
  //                             if (complaintController.images.value.isNotEmpty) {
  //                               return ListView.builder(
  //                                 itemCount:
  //                                     complaintController.images.value.length,
  //                                 itemBuilder: (context, index) {
  //                                   var imageCount = index + 1;
  //                                   return Padding(
  //                                     padding: const EdgeInsets.only(bottom: 8),
  //                                     child: Row(
  //                                       children: [
  //                                         Expanded(
  //                                             child: Container(
  //                                           child: Padding(
  //                                             padding:
  //                                                 const EdgeInsets.all(8.0),
  //                                             child: Row(
  //                                               mainAxisAlignment:
  //                                                   MainAxisAlignment
  //                                                       .spaceBetween,
  //                                               children: [
  //                                                 Row(
  //                                                   children: [
  //                                                     ClipRRect(
  //                                                       borderRadius:
  //                                                           BorderRadius
  //                                                               .circular(5),
  //                                                       child: SizedBox(
  //                                                         width: 80,
  //                                                         height: 80,
  //                                                         child: Image.file(
  //                                                           File(
  //                                                               complaintController
  //                                                                   .images
  //                                                                   .value[
  //                                                                       index]!
  //                                                                   .path!),
  //                                                           fit:
  //                                                               BoxFit.fitWidth,
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                     SizedBox(
  //                                                       width: 12,
  //                                                     ),
  //                                                     Text(
  //                                                       "Gambar ${imageCount}",
  //                                                       style: AppTheme
  //                                                           .textTheme
  //                                                           .labelMedium!
  //                                                           .copyWith(
  //                                                               fontWeight:
  //                                                                   FontWeight
  //                                                                       .w400,
  //                                                               fontSize: 12),
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                                 GestureDetector(
  //                                                   onTap: () {
  //                                                     complaintController
  //                                                         .deleteImage(index);
  //                                                   },
  //                                                   child: Padding(
  //                                                     padding:
  //                                                         const EdgeInsets.only(
  //                                                             right: 10),
  //                                                     child: Icon(
  //                                                       Icons
  //                                                           .delete_outline_outlined,
  //                                                       color:
  //                                                           AppTheme.primaryRed,
  //                                                       size: 24,
  //                                                     ),
  //                                                   ),
  //                                                 )
  //                                               ],
  //                                             ),
  //                                           ),
  //                                           // height: 200,
  //                                           decoration: BoxDecoration(
  //                                               color: Colors.grey[50],
  //                                               borderRadius:
  //                                                   BorderRadius.circular(6),
  //                                               border: Border.all(
  //                                                   color: AppTheme.greyOutline,
  //                                                   width: 0.6)),
  //                                         )),
  //                                       ],
  //                                     ),
  //                                   );
  //                                 },
  //                                 shrinkWrap: true,
  //                                 physics: NeverScrollableScrollPhysics(),
  //                               );
  //                             } else {
  //                               return Container();
  //                             }
  //                           }),
  //                           GestureDetector(
  //                             onTap: () async {
  //                               // await reviewController.pickImageFromCamera();
  //                               if (complaintController.images.value.length ==
  //                                   3) {
  //                                 showCustomSnackBar(
  //                                     message:
  //                                         "Anda tidak dapat menambah gambar lagi!",
  //                                     title: "Gambar Maksimal");
  //                               } else {
  //                                 await complaintController
  //                                     .pickImageFromCamera();
  //                               }
  //                             },
  //                             child: Row(
  //                               children: [
  //                                 Expanded(
  //                                     child: Container(
  //                                   height: 46,
  //                                   decoration: BoxDecoration(
  //                                       color: Colors.grey[100],
  //                                       borderRadius: BorderRadius.circular(6),
  //                                       border: Border.all(
  //                                           color: AppTheme.greyOutline,
  //                                           width: 0.6)),
  //                                   child: Center(
  //                                     child: Row(
  //                                       mainAxisSize: MainAxisSize.min,
  //                                       children: [
  //                                         const Icon(
  //                                           Icons.camera_alt_outlined,
  //                                           color: Colors.grey,
  //                                           size: 21,
  //                                         ),
  //                                         const SizedBox(
  //                                           width: 4,
  //                                         ),
  //                                         Text(
  //                                           "Unggah Gambar",
  //                                           style: AppTheme
  //                                               .textTheme.labelMedium!
  //                                               .copyWith(
  //                                                   fontWeight: FontWeight.w400,
  //                                                   fontSize: 12),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ))
  //                               ],
  //                             ),
  //                           ),
  //                           const SizedBox(
  //                             height: 24,
  //                           ),
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     Expanded(child: Obx(() {
  //                       return PrimaryButton(
  //                           title: 'Ajukan',
  //                           onTap: () async {
  //                             await complaintController.postComplain(
  //                                 order_id: orderDetailController
  //                                     .orderDetail!.value!.id!
  //                                     .toString());
  //                             // await reviewController.postReview(
  //                             //     cateringId: orderDetailController
  //                             //         .orderDetail.value.cateringId!,
  //                             //     orderId: orderDetailController
  //                             //         .orderDetail.value.id
  //                             //         .toString());
  //                             Get.back();
  //                             orderDetailController.getOrderDetail(id!);
  //                           },
  //                           state: complaintController.isLoading.value
  //                               ? ButtonState.loading
  //                               : ButtonState.idle);
  //                     }))
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
  //
  // void showModalSetReview() async {
  //   await showModalBottomSheet(
  //       // isScrollControlled: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(12), topRight: Radius.circular(12)),
  //       ),
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (context) {
  //         return SingleChildScrollView(
  //           physics: BouncingScrollPhysics(),
  //           child: Padding(
  //             padding: EdgeInsets.only(
  //                 left: 25,
  //                 right: 25,
  //                 top: 20,
  //                 bottom: MediaQuery.of(context).viewInsets.bottom + 20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Text(
  //                       "Ajukan Komplain",
  //                       style: AppTheme.textTheme.labelMedium!.copyWith(
  //                           fontWeight: FontWeight.w600, fontSize: 14),
  //                     ),
  //                     Text(
  //                       orderDetailController.orderDetail.value.invoiceNumber!,
  //                       style: AppTheme.textTheme.labelMedium!.copyWith(
  //                           fontWeight: FontWeight.w400, fontSize: 12),
  //                     ),
  //                   ],
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 ),
  //                 const SizedBox(
  //                   height: 28,
  //                 ),
  //                 Container(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Column(
  //                         children: [
  //                           Text(
  //                             "Kasih ratingmu untuk katering ini",
  //                             style: AppTheme.textTheme.labelMedium!.copyWith(
  //                                 fontWeight: FontWeight.w500, fontSize: 13),
  //                           ),
  //                           const SizedBox(
  //                             height: 8,
  //                           ),
  //                           RatingBar.builder(
  //                             initialRating: 0,
  //                             minRating: 1,
  //                             direction: Axis.horizontal,
  //                             allowHalfRating: false,
  //                             itemCount: 5,
  //                             itemPadding:
  //                                 const EdgeInsets.symmetric(horizontal: 4.0),
  //                             itemBuilder: (context, _) => const Icon(
  //                               Icons.star,
  //                               color: Colors.amber,
  //                             ),
  //                             onRatingUpdate: (rating) {
  //                               reviewController.ratingStar.value = rating;
  //                             },
  //                           ),
  //                           const SizedBox(
  //                             height: 14,
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 "Tambah deskripsi",
  //                                 style: AppTheme.textTheme.labelMedium!
  //                                     .copyWith(
  //                                         fontWeight: FontWeight.w500,
  //                                         fontSize: 13),
  //                               ),
  //                             ],
  //                           ),
  //                           const SizedBox(
  //                             height: 8,
  //                           ),
  //                           TextFormField(
  //                             maxLines: 5,
  //                             controller:
  //                                 reviewController.reviewDescriptionController,
  //                           ),
  //                           const SizedBox(
  //                             height: 12,
  //                           ),
  //                           Obx(() {
  //                             if (reviewController.isImageUpload.value) {
  //                               return Padding(
  //                                 padding: const EdgeInsets.only(bottom: 8),
  //                                 child: Row(
  //                                   children: [
  //                                     Expanded(
  //                                         child: Container(
  //                                       child: Image.file(File(reviewController
  //                                           .reviewImage!.path)),
  //                                       height: 200,
  //                                       decoration: BoxDecoration(
  //                                           color: Colors.grey[100],
  //                                           borderRadius:
  //                                               BorderRadius.circular(6),
  //                                           border: Border.all(
  //                                               color: AppTheme.greyOutline,
  //                                               width: 0.6)),
  //                                     )),
  //                                   ],
  //                                 ),
  //                               );
  //                             } else {
  //                               return Container();
  //                             }
  //                           }),
  //                           GestureDetector(
  //                             onTap: () async {
  //                               await reviewController.pickImageFromCamera();
  //                             },
  //                             child: Row(
  //                               children: [
  //                                 Expanded(
  //                                     child: Container(
  //                                   height: 46,
  //                                   decoration: BoxDecoration(
  //                                       color: Colors.grey[100],
  //                                       borderRadius: BorderRadius.circular(6),
  //                                       border: Border.all(
  //                                           color: AppTheme.greyOutline,
  //                                           width: 0.6)),
  //                                   child: Center(
  //                                     child: Row(
  //                                       mainAxisSize: MainAxisSize.min,
  //                                       children: [
  //                                         const Icon(
  //                                           Icons.camera_alt_outlined,
  //                                           color: Colors.grey,
  //                                           size: 21,
  //                                         ),
  //                                         const SizedBox(
  //                                           width: 4,
  //                                         ),
  //                                         Text(
  //                                           "Unggah Gambar",
  //                                           style: AppTheme
  //                                               .textTheme.labelMedium!
  //                                               .copyWith(
  //                                                   fontWeight: FontWeight.w400,
  //                                                   fontSize: 12),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ))
  //                               ],
  //                             ),
  //                           ),
  //                           const SizedBox(
  //                             height: 24,
  //                           ),
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     Expanded(child: Obx(() {
  //                       return PrimaryButton(
  //                           title: 'Konfirmasi',
  //                           onTap: () async {
  //                             await reviewController.postReview(
  //                                 cateringId: orderDetailController
  //                                     .orderDetail.value.cateringId!,
  //                                 orderId: orderDetailController
  //                                     .orderDetail.value.id
  //                                     .toString());
  //                             Get.back();
  //                             orderDetailController.getOrderDetail(id!);
  //                           },
  //                           state: reviewController.isLoading.value
  //                               ? ButtonState.loading
  //                               : ButtonState.idle);
  //                     }))
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
  //
  // void showModalDisplayReview() async {
  //   await showModalBottomSheet(
  //       // isScrollControlled: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(12), topRight: Radius.circular(12)),
  //       ),
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (context) {
  //         return SingleChildScrollView(
  //           child: Padding(
  //             padding: EdgeInsets.only(
  //                 left: 25,
  //                 right: 25,
  //                 top: 20,
  //                 bottom: MediaQuery.of(context).viewInsets.bottom + 20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Text(
  //                       "Ulasan Anda",
  //                       style: AppTheme.textTheme.labelMedium!.copyWith(
  //                           fontWeight: FontWeight.w600, fontSize: 14),
  //                     ),
  //                     Text(
  //                       orderDetailController.orderDetail.value.invoiceNumber!,
  //                       style: AppTheme.textTheme.labelMedium!.copyWith(
  //                           fontWeight: FontWeight.w400, fontSize: 12),
  //                     ),
  //                   ],
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 ),
  //                 const SizedBox(
  //                   height: 28,
  //                 ),
  //                 Container(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Column(
  //                         children: [
  //                           Text(
  //                             "Rating yang anda berikan",
  //                             style: AppTheme.textTheme.labelMedium!.copyWith(
  //                                 fontWeight: FontWeight.w500, fontSize: 13),
  //                           ),
  //                           const SizedBox(
  //                             height: 8,
  //                           ),
  //                           RatingBar.builder(
  //                             initialRating: orderDetailController
  //                                 .orderDetail.value.review!.star!
  //                                 .toDouble(),
  //                             minRating: 1,
  //                             direction: Axis.horizontal,
  //                             allowHalfRating: false,
  //                             itemCount: 5,
  //                             ignoreGestures: true,
  //                             itemPadding:
  //                                 const EdgeInsets.symmetric(horizontal: 4.0),
  //                             itemBuilder: (context, _) => const Icon(
  //                               Icons.star,
  //                               color: Colors.amber,
  //                             ),
  //                             onRatingUpdate: (rating) {},
  //                           ),
  //                           const SizedBox(
  //                             height: 14,
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 "Deskripsi Ulasan",
  //                                 style: AppTheme.textTheme.labelMedium!
  //                                     .copyWith(
  //                                         fontWeight: FontWeight.w500,
  //                                         fontSize: 13),
  //                               ),
  //                             ],
  //                           ),
  //                           const SizedBox(
  //                             height: 8,
  //                           ),
  //                           TextFormField(
  //                             maxLines: 5,
  //                             initialValue: orderDetailController
  //                                 .orderDetail.value.review!.description,
  //                             readOnly: true,
  //                           ),
  //                           const SizedBox(
  //                             height: 12,
  //                           ),
  //                           if (orderDetailController
  //                                       .orderDetail.value.review!.hasImage !=
  //                                   null ||
  //                               orderDetailController
  //                                       .orderDetail.value.review!.hasImage !=
  //                                   "")
  //                             Padding(
  //                               padding: const EdgeInsets.only(bottom: 8),
  //                               child: Row(
  //                                 children: [
  //                                   Expanded(
  //                                       child: Container(
  //                                     child: FancyShimmerImage(
  //                                       imageUrl: AppConstant.BASE_URL +
  //                                           orderDetailController.orderDetail
  //                                               .value.review!.hasImage!
  //                                               .substring(1),
  //                                     ),
  //                                     height: 200,
  //                                     decoration: BoxDecoration(
  //                                         color: Colors.grey[100],
  //                                         borderRadius:
  //                                             BorderRadius.circular(6),
  //                                         border: Border.all(
  //                                             color: AppTheme.greyOutline,
  //                                             width: 0.6)),
  //                                   )),
  //                                 ],
  //                               ),
  //                             ),
  //                           const SizedBox(
  //                             height: 24,
  //                           ),
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  Container? getOrderStatusBadge({required String orderStatus}) {
    if (orderStatus == "UNPAID") {
      return orderStatusBadge(
          text: "Belum Dibayar",
          bgColor: const Color(0xFFFFE6FD),
          textColor: const Color(0xff9d118f));
    } else if (orderStatus == "VOID") {
      return orderStatusBadge(
          text: "Pembayaran Kadaluarsa",
          bgColor: const Color(0xFFFFF1DB),
          textColor: const Color(0xffE49A2A));
    } else {
      if (orderStatus == "PAID") {
        return orderStatusBadge(
            text: "Menunggu Konfirmasi",
            bgColor: const Color(0xFFF5FFE0),
            textColor: const Color(0xff6a9316));
      } else if (orderStatus == "NOT_APPROVED") {
        return orderStatusBadge(
            text: "Dibatalkan Katering",
            bgColor: const Color(0xFFFFEBEB),
            textColor: const Color(0xffD72E2E));
      } else if (orderStatus == "PROCESSED") {
        return orderStatusBadge(
            text: "Diproses",
            bgColor: const Color(0xFFE8EAFF),
            textColor: const Color(0xff2D3BBC));
      } else if (orderStatus == "SEND") {
        return orderStatusBadge(
            text: "Sedang Dikirim",
            bgColor: const Color(0xFFE6FFE2),
            textColor: const Color(0xff34A023));
      } else if (orderStatus == "ONGOING") {
        return orderStatusBadge(
            text: "Sedang Berlangsung",
            bgColor: const Color(0xFFE6FFE2),
            textColor: const Color(0xff34A023));
      } else if (orderStatus == "ACCEPTED") {
        return orderStatusBadge(
            text: "Diterima",
            bgColor: const Color(0xFFE5F3FF),
            textColor: const Color(0xff2569A8));
      } else if (orderStatus == "COMPLAINT") {
        return orderStatusBadge(
            text: "Komplain",
            bgColor: const Color(0xFFFFEEEE),
            textColor: const Color(0xffC63939));
      }
    }
  }

  Container orderStatusBadge(
      {required String text,
      required Color bgColor,
      required Color textColor}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Text(
          text,
          style: AppTheme.textTheme.titleLarge!.copyWith(
              fontSize: 10, fontWeight: FontWeight.w600, color: textColor),
        ),
      ),
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text("Detail Pesanan",
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        orderDetailController.getOrderDetail(id!);
                      },
                      child: const Icon(
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
        const SizedBox(
          height: 29,
        ),
        Expanded(
            child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Nomor Pesanan",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 13, fontWeight: FontWeight.w500)),
                            Text(
                                orderDetailController.isLoading.value
                                    ? "..."
                                    : orderDetailController
                                        .subsOrderDetailModel!.invoiceNumber!,
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w400))
                          ],
                        );
                      }),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tipe",
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          Obx(() {
                            return Text(
                                orderDetailController.isLoading.value
                                    ? "..."
                                    : orderDetailController
                                        .subsOrderDetailModel!
                                        .orderTypeWording(),
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w400));
                          })
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(),
                      // Obx(() {
                      //   if (orderDetailController.preOrderDetailModel!.review !=
                      //       null) {
                      //     return Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         const SizedBox(
                      //           height: 5,
                      //         ),
                      //         Row(
                      //           children: [
                      //             Text("Ulasan Pembeli",
                      //                 style: AppTheme.textTheme.titleLarge!
                      //                     .copyWith(
                      //                         fontSize: 13,
                      //                         fontWeight: FontWeight.w500)),
                      //
                      //             // RatingBar.builder(
                      //             //   initialRating: orderDetailController.orderDetail.value.review!.star!.toDouble(),
                      //             //   direction: Axis.horizontal,
                      //             //   ignoreGestures: true,
                      //             //   itemCount: 5,
                      //             //   itemSize: 16,
                      //             //   itemPadding:
                      //             //   const EdgeInsets.symmetric(horizontal: 4.0),
                      //             //   itemBuilder: (context, _) => const Icon(
                      //             //     Icons.star,
                      //             //     color: Colors.amber,
                      //             //   ),
                      //             //   onRatingUpdate: (rating) {
                      //             //   },
                      //             // ),
                      //             Container(
                      //               child: Row(
                      //                 children: [
                      //                   Icon(
                      //                     Icons.star,
                      //                     color: AppTheme.primaryOrange,
                      //                     size: 20,
                      //                   ),
                      //                   Text(
                      //                       orderDetailController
                      //                           .preOrderDetailModel!
                      //                           .review!
                      //                           .star!
                      //                           .toString(),
                      //                       style: AppTheme
                      //                           .textTheme.titleLarge!
                      //                           .copyWith(
                      //                               fontSize: 13,
                      //                               fontWeight:
                      //                                   FontWeight.w400)),
                      //                   SizedBox(
                      //                     width: 6,
                      //                   ),
                      //                   GestureDetector(
                      //                     onTap: () {
                      //                       // showModalDisplayReview();
                      //                     },
                      //                     child: Text(
                      //                       "Lihat",
                      //                       style: AppTheme
                      //                           .textTheme.titleLarge!
                      //                           .copyWith(
                      //                               fontSize: 13,
                      //                               fontWeight: FontWeight.w400,
                      //                               decoration: TextDecoration
                      //                                   .underline),
                      //                     ),
                      //                   )
                      //                 ],
                      //               ),
                      //             )
                      //           ],
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //         ),
                      //         const SizedBox(
                      //           height: 5,
                      //         ),
                      //         const Divider(),
                      //       ],
                      //     );
                      //   } else
                      //     return Container();
                      // }),
                      const SizedBox(
                        height: 1,
                      ),
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Status Pesanan",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 13, fontWeight: FontWeight.w500)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!orderDetailController.isLoading.value &&
                                    (orderDetailController.subsOrderDetailModel!.orderStatus! == "UNPAID" ||
                                        orderDetailController
                                                .subsOrderDetailModel!
                                                .orderStatus! ==
                                            "VOID" ||
                                        orderDetailController
                                                .subsOrderDetailModel!
                                                .orderStatus! ==
                                            "PAID" ||
                                        orderDetailController
                                                .subsOrderDetailModel!
                                                .orderStatus! ==
                                            "COMPLAINT" ||
                                        orderDetailController
                                                .subsOrderDetailModel!
                                                .orderStatus! ==
                                            "NOT_APPROVED" ||
                                        orderDetailController
                                                .subsOrderDetailModel!
                                                .orderStatus! ==
                                            "ONGOING"))
                                  getOrderStatusBadge(
                                      orderStatus: orderDetailController
                                          .subsOrderDetailModel!.orderStatus!)!,
                                if (!orderDetailController.isLoading.value &&
                                    orderDetailController.subsOrderDetailModel!
                                            .orderStatus! ==
                                        "COMPLAINT")
                                  GestureDetector(
                                    onTap: () {
                                      // showModalDisplayComplaint();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Lihat Status Komplain",
                                        style: AppTheme.textTheme.titleLarge!
                                            .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                decoration:
                                                    TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        );
                      }),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 1,
                      ),
                      Obx(() {
                        if (!orderDetailController.isLoading.value &&
                            orderDetailController
                                    .subsOrderDetailModel!.orderStatus ==
                                "UNPAID") {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Batas Pembayaran",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CountdownTimer(
                                    endTime: orderDetailController
                                            .isLoading.value
                                        ? 0
                                        : DateTime.parse(orderDetailController
                                                .subsOrderDetailModel!
                                                .paymentExpiry!)
                                            .millisecondsSinceEpoch,
                                    // onEnd: (){
                                    //   Timer(Duration(seconds: 3), () {
                                    //     orderDetailController.getOrderDetail(id!);
                                    //   });
                                    // },
                                    textStyle: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  // const SizedBox(
                                  //   height: 4,
                                  // ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     Get.toNamed(RouteHelper.midtransPayment,
                                  //         arguments: [
                                  //           orderDetailController
                                  //               .preOrderDetailModel!.id
                                  //         ]);
                                  //   },
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //       border: Border.all(
                                  //           color: AppTheme.primaryGreen),
                                  //       borderRadius: BorderRadius.circular(6),
                                  //     ),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(6),
                                  //       child: Text("Buka Pembayaran",
                                  //           style: AppTheme
                                  //               .textTheme.titleLarge!
                                  //               .copyWith(
                                  //                   fontSize: 11,
                                  //                   fontWeight:
                                  //                       FontWeight.w400)),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                      Obx(() {
                        if (!orderDetailController.isLoading.value &&
                            !(orderDetailController
                                        .subsOrderDetailModel!.orderStatus! ==
                                    "PAID" ||
                                orderDetailController
                                        .subsOrderDetailModel!.orderStatus! ==
                                    "UNPAID" ||
                                orderDetailController
                                        .subsOrderDetailModel!.orderStatus! ==
                                    "PENDING" ||
                                orderDetailController
                                        .subsOrderDetailModel!.orderStatus! ==
                                    "VOID" ||
                                orderDetailController
                                        .subsOrderDetailModel!.orderStatus! ==
                                    "COMPLAINT" ||
                                orderDetailController
                                        .subsOrderDetailModel!.orderStatus! ==
                                    "NOT_APPROVED" ||
                                orderDetailController
                                        .subsOrderDetailModel!.orderStatus! ==
                                    "ONGOING")) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              orderStatusFlowWidget(
                                  state: orderDetailController
                                      .subsOrderDetailModel!.orderStatus!),
                              const SizedBox(
                                height: 14,
                              ),
                              getOrderStatusBadge(
                                  orderStatus: orderDetailController
                                      .subsOrderDetailModel!.orderStatus!)!
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Divider(
                thickness: 10,
                color: Colors.grey[200],
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, top: 12, right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Info Pengiriman",
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Obx(() {
                                return Row(
                                  children: [
                                    Text(
                                        orderDetailController.isLoading.value
                                            ? "..."
                                            : orderDetailController
                                                    .subsOrderDetailModel!
                                                    .address!
                                                    .recipientName! +
                                                " | ",
                                        style: AppTheme.textTheme.titleLarge!
                                            .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400)),
                                    Text(
                                        orderDetailController.isLoading.value
                                            ? "..."
                                            : " +" +
                                                orderDetailController
                                                    .subsOrderDetailModel!
                                                    .address!
                                                    .phone!,
                                        style: AppTheme.textTheme.titleLarge!
                                            .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400)),
                                  ],
                                );
                              }),
                              const SizedBox(
                                height: 4,
                              ),
                              Obx(() {
                                return Text(
                                    orderDetailController.isLoading.value
                                        ? "..."
                                        : orderDetailController
                                            .subsOrderDetailModel!
                                            .address!
                                            .address!,
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400));
                              }),
                              const SizedBox(
                                height: 6,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                child: Icon(Icons.map_outlined,
                                    color: AppTheme.primaryGreen),
                                onTap: () {
                                  MapsLauncher.launchCoordinates(
                                      double.parse(orderDetailController
                                          .subsOrderDetailModel!
                                          .address!
                                          .latitude!),
                                      double.parse(orderDetailController
                                          .subsOrderDetailModel!
                                          .address!
                                          .longitude!));
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    launch(
                                        "tel:${orderDetailController.subsOrderDetailModel!.address!.phone}");
                                  },
                                  child: Icon(Icons.phone,
                                      color: AppTheme.primaryGreen)),
                            ],
                          )
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: Colors.black38,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text("Jadwal Pengiriman",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)),
                            ],
                          ),
                          Obx(() {
                            return Text(
                                orderDetailController.isLoading.value
                                    ? "..."
                                    : "${DateFormat('d MMMM y', 'id').format(DateTime.parse(orderDetailController.subsOrderDetailModel!.deliveryDatetime!))}, Jam ${DateFormat('Hm', 'id').format(DateTime.parse(orderDetailController.subsOrderDetailModel!.deliveryDatetime!))} - ${DateFormat('Hm', 'id').format(DateTime.parse(orderDetailController.subsOrderDetailModel!.deliveryDatetime!).add(const Duration(minutes: 30)))}",
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w400));
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              // Divider(
              //   thickness: 10,
              //   color: Colors.grey[200],
              // ),
              const SizedBox(
                height: 12,
              ),
              // Container(
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.only(left: 25, right: 25, bottom: 12),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text("Info Katering",
              //             style: AppTheme.textTheme.titleLarge!.copyWith(
              //                 fontSize: 13, fontWeight: FontWeight.w500)),
              //         const SizedBox(
              //           height: 10,
              //         ),
              //         Row(
              //           children: [
              //             Obx(() {
              //               if (orderDetailController.isLoading.value) {
              //                 return Container(
              //                     width: 48, height: 48, color: Colors.black38);
              //               } else {
              //                 return ClipRRect(
              //                   borderRadius: BorderRadius.circular(5),
              //                   child: Container(
              //                     width: 48,
              //                     height: 48,
              //                     color: Colors.black38,
              //                     child: FancyShimmerImage(
              //                       imageUrl: orderDetailController
              //                           .preOrderDetailModel!.image!,
              //                     ),
              //                   ),
              //                 );
              //               }
              //             }),
              //             const SizedBox(
              //               width: 12,
              //             ),
              //             Obx(() {
              //               return Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                       orderDetailController.isLoading.value
              //                           ? "..."
              //                           : orderDetailController
              //                               .orderDetail.value.cateringName!,
              //                       style: AppTheme.textTheme.titleLarge!
              //                           .copyWith(
              //                               fontSize: 12,
              //                               fontWeight: FontWeight.w500)),
              //                   const SizedBox(
              //                     height: 2,
              //                   ),
              //                   Text(
              //                       orderDetailController.isLoading.value
              //                           ? "..."
              //                           : orderDetailController
              //                               .orderDetail.value.cateringPhone!,
              //                       style: AppTheme.textTheme.titleLarge!
              //                           .copyWith(
              //                               fontSize: 11,
              //                               fontWeight: FontWeight.w400)),
              //                   const SizedBox(
              //                     height: 5,
              //                   ),
              //                   Row(
              //                     children: [
              //                       const Icon(
              //                         Icons.pin_drop_outlined,
              //                         size: 16,
              //                         color: Colors.black38,
              //                       ),
              //                       Text(
              //                           orderDetailController.isLoading.value
              //                               ? "..."
              //                               : orderDetailController
              //                                   .orderDetail
              //                                   .value
              //                                   .cateringLocation!
              //                                   .capitalize!,
              //                           style: AppTheme.textTheme.titleLarge!
              //                               .copyWith(
              //                                   fontSize: 12,
              //                                   fontWeight: FontWeight.w400)),
              //                     ],
              //                   )
              //                 ],
              //               );
              //             })
              //           ],
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              Divider(
                thickness: 10,
                color: Colors.grey[200],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 12),
                child: Column(
                  children: [
                    Text("Pengantaran Hari Ini",
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 18,
                    ),
                    Obx(() {
                      if (orderDetailController.isLoading.value) {
                        return const CircularProgressIndicator(
                          color: AppTheme.primaryGreen,
                        );
                      } else {
                        if (orderTodayIndex == -1) {
                          return Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, top: 5),
                              child: Text("Tidak ada Pengantaran Hari Ini",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              if (index == orderTodayIndex) {
                                return OrderComponent(
                                  orderIndex: index,
                                  isToday: true,
                                );
                              } else {
                                return Container();
                              }
                            },
                            itemCount: orderDetailController
                                .subsOrderDetailModel!.orders!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                          );
                        }
                      }
                    })
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              Divider(
                thickness: 10,
                color: Colors.grey[200],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pesanan Lainnya",
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 12,
                    ),
                    Obx(() {
                      if (orderDetailController.isLoading.value) {
                        return const CircularProgressIndicator(
                          color: AppTheme.primaryGreen,
                        );
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            if (index != orderTodayIndex) {
                              return OrderComponent(
                                orderIndex: index,
                                isToday: false,
                              );
                            } else {
                              return Container();
                            }
                          },
                          itemCount: orderDetailController
                              .subsOrderDetailModel!.orders!.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        );
                      }
                    }),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Divider(
                thickness: 10,
                color: Colors.grey[200],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, bottom: 16, top: 14),
                child: Text("Ringkasan Pembayaran",
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Subtotal Harga",
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w300)),
                    Obx(() {
                      return Text(
                          orderDetailController.isLoading.value
                              ? "..."
                              : CurrencyFormat.convertToIdr(
                                  orderDetailController
                                          .subsOrderDetailModel!.totalPrice! -
                                      orderDetailController
                                          .subsOrderDetailModel!
                                          .deliveryPrice! +
                                      (orderDetailController
                                              .subsOrderDetailModel!.discount ??
                                          0) +
                                      (orderDetailController
                                              .subsOrderDetailModel!
                                              .useBalance ??
                                          0),
                                  0),
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400));
                    }),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ongkos Kirim",
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w300)),
                    Obx(() {
                      return Text(
                          orderDetailController.isLoading.value
                              ? "..."
                              : CurrencyFormat.convertToIdr(
                                  orderDetailController
                                      .subsOrderDetailModel!.deliveryPrice!,
                                  0),
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400));
                    }),
                  ],
                ),
              ),
              Obx(() {
                if (orderDetailController.isLoading.value) {
                  return Container();
                } else {
                  if (orderDetailController.subsOrderDetailModel!.discount !=
                      null) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Diskon",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300)),
                              Obx(() {
                                return Text(
                                    orderDetailController.isLoading.value
                                        ? "..."
                                        : "- ${CurrencyFormat.convertToIdr(orderDetailController.subsOrderDetailModel!.discount, 0)}",
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            color: AppTheme.primaryRed,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400));
                              }),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }
              }),
              Obx(() {
                if (orderDetailController.isLoading.value) {
                  return Container();
                } else {
                  if (orderDetailController.subsOrderDetailModel!.useBalance !=
                      0) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Pakai Saldo",
                                  style: AppTheme.textTheme.titleLarge!
                                      .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300)),
                              Obx(() {
                                return Text(
                                    orderDetailController.isLoading.value
                                        ? "..."
                                        : "- ${CurrencyFormat.convertToIdr(orderDetailController.subsOrderDetailModel!.useBalance, 0)}",
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            color: AppTheme.primaryRed,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400));
                              }),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }
              }),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Harga",
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w500)),
                    Obx(() {
                      return Text(
                          orderDetailController.isLoading.value
                              ? "..."
                              : CurrencyFormat.convertToIdr(
                                  orderDetailController
                                      .subsOrderDetailModel!.totalPrice!,
                                  0),
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400));
                    }),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        )),
        const SizedBox(
          height: 70,
        )
      ]),
      Align(
        child: SizedBox(
          height: 72,
          child: Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[350]!)),
                color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(child: Obx(() {
                    if (orderDetailController.isLoading.value) {
                      return nil;
                    } else {
                      return changeStatusButtonComponent();
                    }
                  }))
                  // GestureDetector(
                  //   onTap: () {
                  //     // await Get.toNamed(RouteHelper.getAddAddressMap());
                  //     // addressListController.getAllAddress();
                  //     Get.toNamed(RouteHelper.chat, arguments: {
                  //       "cateringId":
                  //           orderDetailController.orderDetail.value.cateringId,
                  //       "cateringName": orderDetailController
                  //           .orderDetail.value.cateringName,
                  //       "cateringImage":
                  //           orderDetailController.orderDetail.value.image!
                  //     });
                  //   },
                  //   child: Container(
                  //     child: const Center(
                  //       child: Icon(
                  //         Icons.chat_rounded,
                  //         color: AppTheme.primaryGreen,
                  //       ),
                  //     ),
                  //     width: 62,
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       border: Border.all(color: AppTheme.primaryGreen),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   width: 12,
                  // ),
                  // Expanded(
                  //   child: Obx(() {
                  //     if (orderDetailController.preOrderDetailModel!.review !=
                  //         null) {
                  //       return PrimaryButton(
                  //         title: "Pesanan Selesai",
                  //         onTap: () {},
                  //         state: ButtonState.disabled,
                  //       );
                  //     } else if (orderDetailController
                  //             .preOrderDetailModel!.orderStatus ==
                  //         "ACCEPTED") {
                  //       return PrimaryButton(
                  //           title: "Beri Ulasan",
                  //           onTap: () {
                  //             // reviewController = Get.find<ReviewController>();
                  //             // showModalSetReview();
                  //           });
                  //     } else {
                  //       return PrimaryButton(
                  //           title: 'Diterima',
                  //           onTap: () async {
                  //             if (orderDetailController
                  //                     .preOrderDetailModel!.orderStatus !=
                  //                 "SEND") {
                  //               showCustomSnackBar(
                  //                   message:
                  //                       "Pesanan belum dalam proses pengiriman",
                  //                   title: "Pesanan masih diproses");
                  //             } else if (orderDetailController
                  //                     .preOrderDetailModel!.orderStatus ==
                  //                 "SEND") {
                  //               // showModalSentConfirmation();
                  //             }
                  //           },
                  //           state: orderDetailController
                  //                       .preOrderDetailModel!.orderStatus ==
                  //                   "SEND"
                  //               ? ButtonState.idle
                  //               : ButtonState.disabled);
                  //     }
                  //   }),
                  // )
                ],
              ),
            ),
          ),
        ),
        alignment: Alignment.bottomCenter,
      ),
    ]));
  }

  Widget changeStatusButtonComponent() {
    var changeStatusWording = "";

    if (orderDetailController.isLoading.value) {
      return nil;
    } else {
      // Status is PAID, continue to processed or rejected
      if (orderDetailController.subsOrderDetailModel!.orderStatus! == "PAID") {
        return Row(
          children: [
            Flexible(
              flex: 1,
              child: PrimaryButton(
                title: "Tolak",
                onTap: () {
                  showModalChangeStatus("NOT_APPROVED", "Pesanan Ditolak");
                  // orderDetailController.changeOrderStatus("NOT_APPROVED");
                },
                state: ButtonState.danger,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Flexible(
              flex: 2,
              child: PrimaryButton(
                title: "Terima",
                onTap: () {
                  showModalChangeStatus("ONGOING", "Pesanan Diterima");
                  // orderDetailController.changeOrderStatus("PROCESSED");
                },
                state: ButtonState.idle,
              ),
            )
          ],
        );
        //  Status is Processed, continue to send
      } else if (orderDetailController.subsOrderDetailModel!.orderStatus! ==
          "PROCESSED") {
        return PrimaryButton(
          title: "Antar Pesanan",
          onTap: () {
            showModalChangeStatus("SEND", "Pesanan Diantar");

            // orderDetailController.changeOrderStatus("SEND");
          },
          state: ButtonState.idle,
        );
        //  Status is another else, disabled button.
      } else if ([
        "UNPAID",
        "VOID",
        "NOT_APPROVED",
        "SEND",
        "ACCEPTED",
        "COMPLAINT",
        "ONGOING"
      ].contains(orderDetailController.subsOrderDetailModel!.orderStatus!)) {
        return PrimaryButton(
          title: orderDetailController.subsOrderDetailModel!.orderStatus! ==
                  "ACCEPTED"
              ? "Pesanan Selesai"
              : "Ubah Status",
          onTap: () {},
          state: ButtonState.disabled,
        );
      } else {
        return nil;
      }
    }
  }

  void showModalChangeStatus(String newStatus, String newStatusWording) async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        context: context,
        builder: (context) {
          return Container(
            height: 400,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 16, top: 20, bottom: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Ubah Status",
                            style: AppTheme.textTheme.labelMedium!.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    child: SvgPicture.asset(ImagePath.sentConfirmation),
                    width: 230,
                    height: 230,
                  ),
                  Text(
                    "Apakah yakin mengubah status menjadi ${newStatusWording}?",
                    textAlign: TextAlign.center,
                    style: AppTheme.textTheme.labelMedium!
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              "Batal",
                              textAlign: TextAlign.center,
                              style: AppTheme.textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppTheme.primaryRed),
                            ),
                          ),
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppTheme.greyOutline),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: PrimaryButton(
                              title: 'Konfirmasi',
                              onTap: () {
                                // profileController.logout();
                                Get.back();
                                orderDetailController
                                    .changeOrderStatus(newStatus);
                              },
                              state: ButtonState.idle))
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Column orderStatusFlowWidget({required String state}) {
    var stateNumber = 0;
    if (state == "PROCESSED") {
      stateNumber = 0;
    } else if (state == "SEND") {
      stateNumber = 1;
    } else {
      stateNumber = 2;
    }
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              (() {
                if (stateNumber >= 0) {
                  return ImagePath.statusCook;
                } else {
                  return ImagePath.statusCookDeactived;
                }
              }()),
              height: 55,
            ),
            Image.asset(
              (() {
                if (stateNumber >= 1) {
                  return ImagePath.statusSent;
                } else {
                  return ImagePath.statusSentDeactived;
                }
              }()),
              height: 55,
            ),
            Image.asset(
              (() {
                if (stateNumber >= 2) {
                  return ImagePath.statusReceived;
                } else {
                  return ImagePath.statusReceivedDeactived;
                }
              }()),
              height: 55,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
        Stack(children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 4,
                  width: 121,
                  color: (() {
                    if (stateNumber > 0) {
                      return AppTheme.primaryGreen;
                    } else {
                      return AppTheme.greyOutline;
                    }
                  }()),
                ),
                Container(
                  height: 4,
                  width: 121,
                  color: (() {
                    if (stateNumber > 1) {
                      return AppTheme.primaryGreen;
                    } else {
                      return AppTheme.greyOutline;
                    }
                  }()),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Transform.translate(
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      color: (() {
                        if (stateNumber >= 0) {
                          return AppTheme.primaryGreen;
                        } else {
                          return AppTheme.greyOutline;
                        }
                      }()),
                      shape: BoxShape.circle),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
                offset: const Offset(-4, 0),
              ),
              Container(
                width: 15,
                height: 15,
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 10,
                ),
                decoration: BoxDecoration(
                    color: (() {
                      if (stateNumber >= 1) {
                        return AppTheme.primaryGreen;
                      } else {
                        return AppTheme.greyOutline;
                      }
                    }()),
                    shape: BoxShape.circle),
              ),
              Container(
                width: 15,
                height: 15,
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 10,
                ),
                decoration: BoxDecoration(
                    color: (() {
                      if (stateNumber >= 2) {
                        return AppTheme.primaryGreen;
                      } else {
                        return AppTheme.greyOutline;
                      }
                    }()),
                    shape: BoxShape.circle),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          )
        ])
      ],
    );
  }
}

class ProductCardInDetailOrder extends StatefulWidget {
  int index;

  ProductCardInDetailOrder({Key? key, required this.index}) : super(key: key);

  @override
  State<ProductCardInDetailOrder> createState() =>
      _ProductCardInDetailOrderState();
}

class _ProductCardInDetailOrderState extends State<ProductCardInDetailOrder> {
  var orderDetailController = Get.find<CateringPreOrderDetailController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: FancyShimmerImage(
                  imageUrl: orderDetailController
                      .preOrderDetailModel!.products![widget.index].image!,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      orderDetailController
                          .preOrderDetailModel!.products![widget.index].name!,
                      style: AppTheme.textTheme.titleLarge!
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w400)),
                  if (orderDetailController.preOrderDetailModel!
                          .products![widget.index].productOptionSummary !=
                      "")
                    Text(
                        "Kustom : " +
                            orderDetailController.preOrderDetailModel!
                                .products![widget.index].productOptionSummary!,
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 11, fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                      CurrencyFormat.convertToIdr(
                          orderDetailController.preOrderDetailModel!
                              .products![widget.index].price,
                          0),
                      style: AppTheme.textTheme.titleLarge!
                          .copyWith(fontSize: 11, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                    "x " +
                        orderDetailController.preOrderDetailModel!
                            .products![widget.index].quantity!
                            .toString(),
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 11, fontWeight: FontWeight.w500)),
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderComponent extends StatefulWidget {
  int orderIndex;
  bool isToday;

  OrderComponent({Key? key, required this.orderIndex, required this.isToday})
      : super(key: key);

  @override
  State<OrderComponent> createState() => _OrderComponentState();
}

class _OrderComponentState extends State<OrderComponent> {
  late ComplaintController complaintController;
  var subsOrderDetailController = Get.find<CateringSubsOrderDetailController>();

  void showModalComplaint() async {
    await showModalBottomSheet(
        // isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "Ajukan Komplain",
                        style: AppTheme.textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      Text(
                        subsOrderDetailController
                            .subsOrderDetailModel!.invoiceNumber!,
                        style: AppTheme.textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pilih Masalah",
                              style: AppTheme.textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Sesuaikan dengan kendalamu ya",
                              style: AppTheme.textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 11),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GroupButton(
                              options: GroupButtonOptions(
                                  mainGroupAlignment: MainGroupAlignment.start,
                                  borderRadius: BorderRadius.circular(5),
                                  selectedColor: AppTheme.primaryGreen,
                                  runSpacing: 2,
                                  unselectedTextStyle:
                                      AppTheme.textTheme.labelMedium!.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                  selectedTextStyle:
                                      AppTheme.textTheme.labelMedium!.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Colors.white)),
                              isRadio: true,
                              onSelected: (value, index, isSelected) {
                                complaintController.problem = value.toString();
                                print(value);
                              },
                              // onSelected: (index, isSelected) => print('$index button is selected'),
                              buttons: [
                                "Makanan Rusak",
                                "Belum Sampai",
                                "Ada yang Kurang",
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Gambar Bukti",
                              style: AppTheme.textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Unggah maksimal 3 foto",
                              style: AppTheme.textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 11),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            // RatingBar.builder(
                            //   initialRating: 0,
                            //   minRating: 1,
                            //   direction: Axis.horizontal,
                            //   allowHalfRating: false,
                            //   itemCount: 5,
                            //   itemPadding:
                            //       const EdgeInsets.symmetric(horizontal: 4.0),
                            //   itemBuilder: (context, _) => const Icon(
                            //     Icons.star,
                            //     color: Colors.amber,
                            //   ),
                            //   onRatingUpdate: (rating) {
                            //     // reviewController.ratingStar.value = rating;
                            //   },
                            // ),
                            // const SizedBox(
                            //   height: 12,
                            // ),
                            Obx(() {
                              if (complaintController.images.value.isNotEmpty) {
                                return ListView.builder(
                                  itemCount:
                                      complaintController.images.value.length,
                                  itemBuilder: (context, index) {
                                    var imageCount = index + 1;
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: SizedBox(
                                                          width: 80,
                                                          height: 80,
                                                          child: Image.file(
                                                            File(
                                                                complaintController
                                                                    .images
                                                                    .value[
                                                                        index]!
                                                                    .path!),
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        "Gambar ${imageCount}",
                                                        style: AppTheme
                                                            .textTheme
                                                            .labelMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      complaintController
                                                          .deleteImage(index);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: Icon(
                                                        Icons
                                                            .delete_outline_outlined,
                                                        color:
                                                            AppTheme.primaryRed,
                                                        size: 24,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            // height: 200,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[50],
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: AppTheme.greyOutline,
                                                    width: 0.6)),
                                          )),
                                        ],
                                      ),
                                    );
                                  },
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                );
                              } else {
                                return Container();
                              }
                            }),
                            GestureDetector(
                              onTap: () async {
                                // await reviewController.pickImageFromCamera();
                                if (complaintController.images.value.length ==
                                    3) {
                                  showCustomSnackBar(
                                      message:
                                          "Anda tidak dapat menambah gambar lagi!",
                                      title: "Gambar Maksimal");
                                } else {
                                  await complaintController
                                      .pickImageFromCamera();
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    height: 46,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: AppTheme.greyOutline,
                                            width: 0.6)),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.camera_alt_outlined,
                                            color: Colors.grey,
                                            size: 21,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Unggah Gambar",
                                            style: AppTheme
                                                .textTheme.labelMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: Obx(() {
                        return PrimaryButton(
                            title: 'Ajukan',
                            onTap: () async {
                              await complaintController.postComplaintSubs(
                                  order_id: subsOrderDetailController
                                      .subsOrderDetailModel!.id!
                                      .toString(),
                                  deliveryDateTime: subsOrderDetailController
                                      .subsOrderDetailModel!
                                      .orders![widget.orderIndex!]
                                      .deliveryDatetime!);
                              // await reviewController.postReview(
                              //     cateringId: orderDetailController
                              //         .subsOrderDetailModel.cateringId!,
                              //     orderId: orderDetailController
                              //         .subsOrderDetailModel.id
                              //         .toString());
                              Get.back();
                              subsOrderDetailController.getOrderDetail(
                                  subsOrderDetailController
                                      .subsOrderDetailModel!.id!);
                            },
                            state: complaintController.isLoading.value
                                ? ButtonState.loading
                                : ButtonState.idle);
                      }))
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showModalSentConfirmation() async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        context: context,
        builder: (context) {
          return Container(
            height: 400,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 16, top: 20, bottom: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Konfirmasi Pengantaran",
                            style: AppTheme.textTheme.labelMedium!.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    child: SvgPicture.asset(ImagePath.sentConfirmation),
                    width: 230,
                    height: 230,
                  ),
                  Text(
                    "Apakah yakin ingin mengantarkan pesanan ini?",
                    textAlign: TextAlign.center,
                    style: AppTheme.textTheme.labelMedium!
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          // complaintController = Get.find<ComplaintController>();
                          // showModalComplaint();
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              "Batal",
                              textAlign: TextAlign.center,
                              style: AppTheme.textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppTheme.primaryBlack),
                            ),
                          ),
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppTheme.greyOutline),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: PrimaryButton(
                              title: 'Konfirmasi',
                              onTap: () {
                                // profileController.logout();
                                Map<String, dynamic> data = {
                                  "order_id": subsOrderDetailController
                                      .subsOrderDetailModel!.id!,
                                  "delivery_datetime": subsOrderDetailController
                                      .subsOrderDetailModel!
                                      .orders![widget.orderIndex]
                                      .deliveryDatetime,
                                };
                                subsOrderDetailController
                                    .changeOrderStatusForOneDay(data);
                                Get.back();
                                // await subsOrderDetailController
                                //     .setOrderToAccepted(date: data);
                                // await subsOrderDetailController.getOrderDetail(
                                //     subsOrderDetailController
                                //         .subsOrderDetailModel.id!);
                                // Get.back();
                              },
                              state: ButtonState.idle))
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showModalDisplayComplaint() async {
    await showModalBottomSheet(
        // isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "Status Komplain",
                        style: AppTheme.textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      Text(
                        subsOrderDetailController
                            .subsOrderDetailModel!.invoiceNumber!,
                        style: AppTheme.textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Status Pengajuan Komplain",
                              style: AppTheme.textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                subsOrderDetailController.subsOrderDetailModel!
                                    .orders![widget.orderIndex].complaint!
                                    .statusWording()!,
                                style: AppTheme.textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Colors.white),
                              ),
                              decoration:
                                  BoxDecoration(color: AppTheme.primaryOrange),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Tipe Masalah",
                              style: AppTheme.textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                subsOrderDetailController.subsOrderDetailModel!
                                    .orders![widget.orderIndex].complaint!
                                    .problemWording()!,
                                style: AppTheme.textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Colors.white),
                              ),
                              decoration:
                                  BoxDecoration(color: AppTheme.primaryGreen),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Gambar Bukti",
                              style: AppTheme.textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            // RatingBar.builder(
                            //   initialRating: 0,
                            //   minRating: 1,
                            //   direction: Axis.horizontal,
                            //   allowHalfRating: false,
                            //   itemCount: 5,
                            //   itemPadding:
                            //       const EdgeInsets.symmetric(horizontal: 4.0),
                            //   itemBuilder: (context, _) => const Icon(
                            //     Icons.star,
                            //     color: Colors.amber,
                            //   ),
                            //   onRatingUpdate: (rating) {
                            //     // reviewController.ratingStar.value = rating;
                            //   },
                            // ),
                            // const SizedBox(
                            //   height: 12,
                            // ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: SizedBox(
                                                      width: 80,
                                                      height: 80,
                                                      child: FancyShimmerImage(
                                                        imageUrl:
                                                            subsOrderDetailController
                                                                .subsOrderDetailModel!
                                                                .orders![widget
                                                                    .orderIndex]
                                                                .complaint!
                                                                .images![index]
                                                                .image!,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(
                                                    "Gambar ${index + 1}",
                                                    style: AppTheme
                                                        .textTheme.labelMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // height: 200,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: AppTheme.greyOutline,
                                                width: 0.6)),
                                      )),
                                    ],
                                  ),
                                );
                              },
                              itemCount: subsOrderDetailController
                                  .subsOrderDetailModel!
                                  .orders![widget.orderIndex]
                                  .complaint!
                                  .images!
                                  .length,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                            DateFormat.MMMMEEEEd('id').format(DateTime.parse(
                                subsOrderDetailController
                                    .subsOrderDetailModel!
                                    .orders![widget.orderIndex]
                                    .deliveryDatetime!)),
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryBlack)),
                        SizedBox(
                          width: 6,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.grey,
                              size: 14,
                            ),
                            Text(
                                DateFormat.Hm().format(DateTime.parse(
                                    subsOrderDetailController
                                        .subsOrderDetailModel!
                                        .orders![widget.orderIndex]
                                        .deliveryDatetime!)),
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: AppTheme.primaryBlack)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            CurrencyFormat.convertToIdr(
                                subsOrderDetailController.subsOrderDetailModel!
                                    .orders![widget.orderIndex].subtotalPrice!,
                                0),
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryOrange)),
                        SizedBox(
                          width: 4,
                        ),
                        Text("|",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 13, fontWeight: FontWeight.w200)),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                            subsOrderDetailController.subsOrderDetailModel!
                                .orders![widget.orderIndex]
                                .statusWording(),
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 13, fontWeight: FontWeight.w400)),
                        // Text(
                        //     subsOrderDetailController
                        //         .subsOrderDetailModel!.orders![widget.orderIndex]
                        //         .statusWording(),
                        //     style: AppTheme.textTheme.titleLarge!.copyWith(
                        //         fontSize: 13,
                        //         fontWeight: FontWeight.w400,
                        //         color: AppTheme.primaryGreen)),
                      ],
                    )
                  ],
                ),
                if (subsOrderDetailController.subsOrderDetailModel!
                            .orders![widget.orderIndex].status! ==
                        "pending" &&
                    widget.isToday)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {
                              // await Get.toNamed(RouteHelper.subsPickProduct,
                              //     arguments: {"index": widget.orderIndex});
                              // subsOrderController.checkAnyFulfilled();
                              // subsOrderController.setAllTotalPrice();
                              // subsOrderController.setAllTotalQuantity();
                              showModalSentConfirmation();
                            },
                            child: Row(
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, bottom: 6, left: 12, right: 12),
                                    child: Text(
                                      "Antarkan",
                                      style: AppTheme.textTheme.titleLarge!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: AppTheme.primaryGreen,
                                      borderRadius: BorderRadius.circular(4)),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                if (subsOrderDetailController.subsOrderDetailModel!
                        .orders![widget.orderIndex].status! ==
                    "complaint")
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {
                              // await Get.toNamed(RouteHelper.subsPickProduct,
                              //     arguments: {"index": widget.orderIndex});
                              // subsOrderController.checkAnyFulfilled();
                              // subsOrderController.setAllTotalPrice();
                              // subsOrderController.setAllTotalQuantity();
                              // showModalSentConfirmation();
                              showModalDisplayComplaint();
                            },
                            child: Row(
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, bottom: 6, left: 12, right: 12),
                                    child: Text(
                                      "Lihat Komplain",
                                      style: AppTheme.textTheme.titleLarge!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: AppTheme.primaryRed,
                                      borderRadius: BorderRadius.circular(4)),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
              ],
            ),
            SelectedProductComponent(orderIndex: widget.orderIndex),
            Divider()
          ],
        ),
      ),
    );
  }
}

class SelectedProductComponent extends StatefulWidget {
  int orderIndex;

  SelectedProductComponent({Key? key, required this.orderIndex})
      : super(key: key);

  @override
  State<SelectedProductComponent> createState() =>
      _SelectedProductComponentState();
}

class _SelectedProductComponentState extends State<SelectedProductComponent> {
  @override
  Widget build(BuildContext context) {
    var subsOrderDetailController =
        Get.find<CateringSubsOrderDetailController>();
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: FancyShimmerImage(
                            imageUrl: subsOrderDetailController
                                .subsOrderDetailModel!
                                .orders![widget.orderIndex]
                                .products![index]
                                .image!),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              subsOrderDetailController
                                  .subsOrderDetailModel!
                                  .orders![widget.orderIndex]
                                  .products![index]
                                  .name!,
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w400)),
                          if (subsOrderDetailController
                                  .subsOrderDetailModel!
                                  .orders![widget.orderIndex]
                                  .products![index]
                                  .customDesc !=
                              "NULL")
                            Text(
                                "Kustom : " +
                                    subsOrderDetailController
                                        .subsOrderDetailModel!
                                        .orders![widget.orderIndex]
                                        .products![index]
                                        .customDesc!,
                                style: AppTheme.textTheme.titleLarge!.copyWith(
                                    fontSize: 11, fontWeight: FontWeight.w400)),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                              CurrencyFormat.convertToIdr(
                                  subsOrderDetailController
                                      .subsOrderDetailModel!
                                      .orders![widget.orderIndex]
                                      .products![index]
                                      .price!,
                                  0),
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 11, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                            "x " +
                                subsOrderDetailController
                                    .subsOrderDetailModel!
                                    .orders![widget.orderIndex]
                                    .products![index]
                                    .quantity
                                    .toString(),
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 11, fontWeight: FontWeight.w500)),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: subsOrderDetailController.subsOrderDetailModel!
              .orders![widget.orderIndex].products!.length,
        ),
      ),
    );
  }
}
