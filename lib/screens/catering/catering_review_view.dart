import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kateringku_mobile/base/no_glow.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';
import 'package:kateringku_mobile/models/catering_review_model.dart';

import '../../controllers/catering_review_controller.dart';
import '../../themes/app_theme.dart';

class CateringReviewView extends StatefulWidget {
  const CateringReviewView({Key? key}) : super(key: key);

  @override
  State<CateringReviewView> createState() => _CateringReviewViewState();
}

class _CateringReviewViewState extends State<CateringReviewView> {
  late int cateringId;
  late String cateringName;
  var cateringReviewController = Get.find<CateringReviewController>();

  @override
  void initState() {
    super.initState();
    cateringId = Get.arguments['cateringId'];
    cateringName = Get.arguments['cateringName'];
    cateringReviewController.getCateringReview(cateringId);
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
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ulasan dan Rating",
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          Text(cateringName,
                              style: AppTheme.textTheme.titleLarge!.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w400)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Obx(() {
              if (cateringReviewController.isLoading.value) {
                return Expanded(child: Container());
              } else {
                return Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 25, right: 25, top: 12),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppTheme.greyOutline, width: 0.6)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(cateringName,
                                        style: AppTheme.textTheme.titleLarge!
                                            .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: AppTheme.primaryOrange,
                                          size: 34,
                                        ),
                                        Text(
                                            cateringReviewController
                                                .cateringReview.rate!
                                                .toStringAsFixed(1),
                                            style: AppTheme
                                                .textTheme.titleLarge!
                                                .copyWith(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                      ],
                                    )
                                  ],
                                ),
                                Text(
                                    "Total ${cateringReviewController.cateringReview.reviews!.length} Ulasan",
                                    style: AppTheme.textTheme.titleLarge!
                                        .copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400)),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: starsBadge())
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: ScrollConfiguration(
                        behavior: NoGlow(),
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          itemBuilder: (context, index) {
                            initializeDateFormatting('id');
                            return customerReview(
                                customerName: cateringReviewController
                                    .cateringReview
                                    .reviews![index]
                                    .customer!
                                    .user!
                                    .name!,
                                star: cateringReviewController
                                    .cateringReview.reviews![index].star!,
                                date: DateFormat('d MMMM y', 'id').format(
                                    DateTime.parse(cateringReviewController
                                        .cateringReview
                                        .reviews![index]
                                        .createdAt!)),
                                reviewDesc: cateringReviewController
                                    .cateringReview
                                    .reviews![index]
                                    .description!,
                                image: cateringReviewController
                                    .cateringReview.reviews![index].hasImage);
                          },
                          itemCount: cateringReviewController
                              .cateringReview.reviews!.length,
                        ),
                      )),
                    ],
                  ),
                );
              }
            })
          ]),
        ],
      ),
    );
  }

  List<Widget> starsBadge() {
    var star1 = cateringReviewController.cateringReview.rateCount!.firstWhere(
        (element) => element.star == 1,
        orElse: () => RateCount(star: 1, total: 0));
    var star2 = cateringReviewController.cateringReview.rateCount!.firstWhere(
        (element) => element.star == 2,
        orElse: () => RateCount(star: 2, total: 0));
    var star3 = cateringReviewController.cateringReview.rateCount!.firstWhere(
        (element) => element.star == 3,
        orElse: () => RateCount(star: 3, total: 0));
    var star4 = cateringReviewController.cateringReview.rateCount!.firstWhere(
        (element) => element.star == 4,
        orElse: () => RateCount(star: 4, total: 0));
    var star5 = cateringReviewController.cateringReview.rateCount!.firstWhere(
        (element) => element.star == 5,
        orElse: () => RateCount(star: 5, total: 0));

    var starsBadgeWidget = <Widget>[];

    starsBadgeWidget.add(starWidget(star: star5.star!, total: star5.total!));
    starsBadgeWidget.add(starWidget(star: star4.star!, total: star4.total!));
    starsBadgeWidget.add(starWidget(star: star3.star!, total: star3.total!));
    starsBadgeWidget.add(starWidget(star: star2.star!, total: star2.total!));
    starsBadgeWidget.add(starWidget(star: star1.star!, total: star1.total!));

    return starsBadgeWidget;
  }

  Widget customerReview(
      {required String customerName,
      required String reviewDesc,
      required int star,
      required String date,
      String? image}) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.greyOutline, width: 0.6)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(customerName,
                      style: AppTheme.textTheme.titleLarge!
                          .copyWith(fontSize: 13, fontWeight: FontWeight.w500)),
                  Text(date,
                      style: AppTheme.textTheme.titleLarge!
                          .copyWith(fontSize: 11, fontWeight: FontWeight.w300)),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  RatingBar.builder(
                    itemSize: 11,
                    initialRating: star.toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    ignoreGestures: true,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Text(reviewDesc,
                  style: AppTheme.textTheme.titleLarge!
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w400)),
              if (image != null && image!.isNotEmpty)
                Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        final imageProvider = Image.network(image!).image;
                        showImageViewer(context, imageProvider,
                            immersive: false,
                            useSafeArea: true,
                            onViewerDismissed: () {});
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Container(
                          width: 100,
                          height: 100,
                          child: FancyShimmerImage(
                            imageUrl: image!,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget starWidget({required int star, required int total}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppTheme.greyOutline, width: 0.6)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Row(
                  children: List.generate(
                      star,
                      (index) => Icon(
                            Icons.star,
                            color: AppTheme.primaryOrange,
                            size: 10,
                          )),
                ),
                Text("(${total})",
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 13, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
