import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kateringku_mobile/constants/app_constant.dart';

import 'package:kateringku_mobile/constants/image_path.dart';
import 'package:kateringku_mobile/constants/vector_path.dart';
import 'package:kateringku_mobile/controllers/catering_home_controller.dart';
import 'package:kateringku_mobile/controllers/customer_dashboard_controller.dart';
import 'package:kateringku_mobile/helpers/currency_format.dart';
import 'package:kateringku_mobile/models/catering_display_model.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';

import '../../base/no_glow.dart';
import '../../routes/route_helper.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  var customerDashboardController = Get.find<CustomerDashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppTheme.primaryGreen,
        child: Stack(children: [
          Align(
            child: Transform.scale(
              child: SvgPicture.asset(
                VectorPath.orangeRadial,
              ),
              scaleY: -1,
              scaleX: -1,
            ),
            alignment: Alignment.topRight,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 36),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.toNamed(RouteHelper.addAddressMap,
                              arguments: {"forEditRecommendation": true});
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lokasi anda",
                              style: AppTheme.textTheme.labelSmall!
                                  .copyWith(color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.map_outlined,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Obx(
                                      () => Row(
                                        children: [
                                          Text(
                                            customerDashboardController
                                                        .location.value.length >
                                                    45
                                                ? customerDashboardController
                                                        .location.value
                                                        .substring(0, 45) +
                                                    "..."
                                                : customerDashboardController
                                                    .location.value,
                                            style: AppTheme
                                                .textTheme.labelMedium!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.white,
                                            size: 13,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.toNamed(RouteHelper.chatList);
                      //   },
                      //   child: const Icon(
                      //     Icons.message_outlined,
                      //     color: Colors.white,
                      //   ),
                      // )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: "Mau cari apa?",
                          prefixIcon: Icon(
                            Icons.search_outlined,
                            color: AppTheme.secondaryBlack.withOpacity(0.7),
                          )),
                      controller:
                          customerDashboardController.searchInputController,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) {
                        customerDashboardController.search();
                      },
                    ),
                    height: 42,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Kategori",
                    style: AppTheme.textTheme.labelMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 0),
                  child: SizedBox(
                    height: 85,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        DashboardCategory(
                          title: "Nasi",
                          imagePath: ImagePath.riceboxCategory,
                          imageHeight: 35,
                        ),
                        DashboardCategory(
                          title: "Jajan",
                          imagePath: ImagePath.snackCategory,
                          imageHeight: 40,
                        ),
                        DashboardCategory(
                          title: "Bali",
                          imagePath: ImagePath.baliCategory,
                          imageHeight: 44,
                        ),
                        DashboardCategory(
                          title: "Jawa",
                          imagePath: ImagePath.jawaCategory,
                          imageHeight: 40,
                        ),
                        DashboardCategory(
                          title: "Mie",
                          imagePath: ImagePath.mieCategory,
                          imageHeight: 28,
                        ),
                        DashboardCategory(
                          title: "Padang",
                          imagePath: ImagePath.padangCategory,
                          imageHeight: 50,
                        ),
                        DashboardCategory(
                          title: "Vegetarian",
                          imagePath: ImagePath.vegetarianCategory,
                          imageHeight: 50,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.66,
              maxChildSize: 0.89,
              minChildSize: 0.66,
              builder: (BuildContext context, ScrollController controller) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Katering Untukmu",
                                style: AppTheme.textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                              // const DashboardSortButton(),
                            ],
                          ),
                        ),
                        Obx(() => !customerDashboardController.isLoading.value
                            ? customerDashboardController
                                    .relevantCaterings.isEmpty
                                ? Column(
                                    children: [
                                      SizedBox(
                                        child: SvgPicture.asset(
                                            ImagePath.emptyOrder),
                                        height: 260,
                                        width: 260,
                                      ),
                                      SizedBox(
                                        height: 26,
                                      ),
                                      Text("Belum ada katering disekitar anda",
                                          style: AppTheme.textTheme.titleLarge!
                                              .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                    ],
                                  )
                                : Expanded(
                                    child: ScrollConfiguration(
                                      behavior: NoGlow(),
                                      child: ListView.builder(
                                          controller: controller,
                                          padding: EdgeInsets.only(top: 15),
                                          itemBuilder: ((context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25,
                                                  right: 25,
                                                  bottom: 4),
                                              child: DashboardProductCard(
                                                cateringDistance:
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .distance!,
                                                cateringDisplayModel:
                                                    customerDashboardController
                                                            .relevantCaterings[
                                                        index],
                                                cateringLatitude: double.parse(
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .latitude!),
                                                cateringLongitude: double.parse(
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .longitude!),
                                                cateringImage:
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .image!,
                                                cateringName:
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .name!,
                                                cateringCategory:
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .mergeCategories(),
                                                cateringLocation:
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .village!
                                                        .name!
                                                        .capitalize!,
                                                categorySalesCount: 234,
                                                bestProductCatering1:
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .recommendationProducts![
                                                            0]
                                                        .name!,
                                                bestProductCatering2:
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .recommendationProducts![
                                                            1]
                                                        .name!,
                                                bestProductCateringPrice1:
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .recommendationProducts![
                                                            0]
                                                        .price!,
                                                bestProductCateringPrice2:
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .recommendationProducts![
                                                            1]
                                                        .price!,
                                                bestProductCateringImage1:
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .recommendationProducts![
                                                            0]
                                                        .image!,
                                                bestProductCateringImage2:
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .recommendationProducts![
                                                            1]
                                                        .image!,
                                                cateringId:
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .id
                                                        .toString(),
                                                cateringRate:
                                                    customerDashboardController
                                                        .relevantCaterings[
                                                            index]
                                                        .rate,
                                              ),
                                            );
                                          }),
                                          // physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: customerDashboardController
                                              .relevantCaterings.length),
                                    ),
                                  )
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryGreen,
                                ),
                              )),
                      ],
                    ),
                  ),
                );
              })
        ]),
      ),
    );
  }
}

class DashboardProductCard extends StatefulWidget {
  String cateringId;
  String cateringName;
  String cateringCategory;
  String cateringImage;
  String cateringLocation;
  int categorySalesCount;
  double cateringLatitude;
  double cateringLongitude;
  double? cateringRate;

  String bestProductCatering1;
  String? bestProductCatering2;
  int bestProductCateringPrice1;
  String bestProductCateringImage1;
  String? bestProductCateringImage2;
  double cateringDistance;
  int? bestProductCateringPrice2;
  CateringDisplayModel cateringDisplayModel;

  bool fromSearch;

  DashboardProductCard(
      {Key? key,
      required this.cateringId,
      required this.cateringName,
      required this.cateringCategory,
      required this.cateringLocation,
      required this.cateringImage,
      required this.categorySalesCount,
      required this.bestProductCatering1,
      required this.bestProductCateringImage1,
      required this.bestProductCateringImage2,
      required this.bestProductCatering2,
      required this.bestProductCateringPrice1,
      required this.bestProductCateringPrice2,
      required this.cateringLatitude,
      required this.cateringLongitude,
      required this.cateringDisplayModel,
      required this.cateringRate,
      required this.cateringDistance,
      this.fromSearch = false})
      : super(key: key);

  @override
  State<DashboardProductCard> createState() => _DashboardProductCardState();
}

class _DashboardProductCardState extends State<DashboardProductCard> {
  @override
  Widget build(BuildContext context) {
    var productCards = [
      Container(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FancyShimmerImage(
                    imageUrl: widget.bestProductCateringImage1),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.fromSearch)
                  Text(widget.bestProductCatering1!,
                      style:
                          AppTheme.textTheme.labelSmall!.copyWith(fontSize: 12))
                else
                  Text(
                      widget.bestProductCatering1!.length > 13
                          ? '${widget.bestProductCatering1!.substring(0, 13)}...'
                          : widget.bestProductCatering1!,
                      style: AppTheme.textTheme.labelSmall!
                          .copyWith(fontSize: 12)),
                Text(
                    CurrencyFormat.convertToIdr(
                        widget.bestProductCateringPrice1, 0),
                    style: AppTheme.textTheme.labelSmall!
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w500))
              ],
            ),
          ],
        ),
      ),
      if (widget.fromSearch && widget.bestProductCatering2 != null)
        SizedBox(
          height: 12,
        ),
      if (widget.bestProductCatering2 != null)
        Container(
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FancyShimmerImage(
                      imageUrl: widget.bestProductCateringImage2!),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.fromSearch)
                    Text(widget.bestProductCatering2!,
                        style: AppTheme.textTheme.labelSmall!
                            .copyWith(fontSize: 12))
                  else
                    Text(
                        widget.bestProductCatering2!.length > 13
                            ? '${widget.bestProductCatering2!.substring(0, 13)}...'
                            : widget.bestProductCatering2!,
                        style: AppTheme.textTheme.labelSmall!
                            .copyWith(fontSize: 12)),
                  Text(
                      CurrencyFormat.convertToIdr(
                          widget.bestProductCateringPrice2, 0),
                      style: AppTheme.textTheme.labelSmall!
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w500))
                ],
              ),
            ],
          ),
        ),
      const SizedBox(
        width: 16,
      )
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          var cateringController = Get.find<CateringHomeController>();
          cateringController.products.value = [];
          cateringController.products.value.clear();
          Get.delete<CateringHomeController>();
          Get.toNamed(
              RouteHelper.getCatering(
                catering_name: this.widget.cateringName,
                catering_image: this.widget.cateringImage,
                catering_location: this.widget.cateringLocation,
                catering_id: widget.cateringId,
                catering_latitude: this.widget.cateringLatitude,
                catering_longitude: this.widget.cateringLongitude,
              ),
              arguments: [widget.cateringDisplayModel]);
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                // color: Colors.grey.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(6)),
                            width: 30,
                            height: 30,
                            child: ClipOval(
                              // borderRadius: BorderRadius.circular(6),
                              child: FancyShimmerImage(
                                imageUrl: widget.cateringImage,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.cateringName,
                                    style: AppTheme.textTheme.labelMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Row(
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3, right: 3),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: AppTheme.primaryOrange,
                                            size: 12,
                                          ),
                                          if (widget.cateringRate == null)
                                            Text("-",
                                                style: AppTheme
                                                    .textTheme.labelMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 11))
                                          else
                                            Text(
                                                widget.cateringRate!
                                                    .toStringAsFixed(1),
                                                style: AppTheme
                                                    .textTheme.labelMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 11))
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppTheme.greyOutline,
                                            width: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Icon(
                                    Icons.map_outlined,
                                    color: AppTheme.secondaryBlack
                                        .withOpacity(0.7),
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                      widget.cateringLocation +
                                          " (${widget.cateringDistance}km)",
                                      style: AppTheme.textTheme.labelSmall!
                                          .copyWith(fontSize: 11)),
                                  Text(" | ",
                                      style: AppTheme.textTheme.labelSmall!
                                          .copyWith(fontSize: 11)),
                                  Text(
                                    widget.cateringCategory,
                                    style: AppTheme.textTheme.labelSmall!
                                        .copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      // Text(
                      //   "Terjual $categorySalesCount",
                      //   style:
                      //       AppTheme.textTheme.labelSmall!.copyWith(fontSize: 11),
                      // )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              if (widget.fromSearch)
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: productCards)
              else
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: productCards),
              const SizedBox(
                height: 6,
              ),
              Divider(
                color: Colors.grey[300],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardSortButton extends StatelessWidget {
  const DashboardSortButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 80,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sort_outlined,
            color: AppTheme.secondaryBlack,
            size: 16,
          ),
          const SizedBox(
            width: 2,
          ),
          Text(
            "Urutkan",
            style: AppTheme.textTheme.labelSmall,
          ),
        ],
      )),
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.greyOutline.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(4),
          color: AppTheme.secondaryBlack.withOpacity(0.06)),
    );
  }
}

// ignore: must_be_immutable
class DashboardCategory extends StatelessWidget {
  String title;
  String imagePath;
  double imageHeight;

  DashboardCategory({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.imageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var customerDashboardController = Get.find<CustomerDashboardController>();
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.category, arguments: {
          "district_name":
              customerDashboardController.addressModel!.districtName!,
          "keyword": title,
          "customer_latitude":
              customerDashboardController.addressModel!.latitude,
          "customer_longitude":
              customerDashboardController.addressModel!.longitude,
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 11),
        child: Column(
          children: [
            Stack(children: [
              Container(
                child: Center(
                  child: Image.asset(
                    imagePath,
                    height: imageHeight,
                  ),
                ),
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              ),
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [
                          0.3,
                          1
                        ],
                        colors: [
                          AppTheme.primaryWhite.withOpacity(0),
                          AppTheme.primaryOrange.withOpacity(0.4)
                        ])),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                title,
                style: AppTheme.textTheme.labelSmall!
                    .copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
