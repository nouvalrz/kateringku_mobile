import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kateringku_mobile/controllers/catering_dashboard_controller.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../components/primary_button.dart';
import '../../constants/image_path.dart';
import '../../constants/vector_path.dart';
import '../../controllers/profile_controller.dart';
import '../../helpers/currency_format.dart';
import '../../routes/route_helper.dart';

class CateringDashboardView extends StatefulWidget {
  const CateringDashboardView({Key? key}) : super(key: key);

  @override
  State<CateringDashboardView> createState() => _CateringDashboardViewState();
}

class _CateringDashboardViewState extends State<CateringDashboardView> {
  var cateringDashboardController = Get.find<CateringDashboardController>();

  @override
  void initState() {
    cateringDashboardController.getCateringDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryGreen,
      body: Stack(
        children: [
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
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              children: [
                CateringProfileHeader(),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                    child: Container(
                  child: Obx(() {
                    if (cateringDashboardController.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryGreen,
                        ),
                      );
                    } else {
                      return RefreshIndicator(
                        color: AppTheme.primaryGreen,
                        onRefresh: () async {
                          cateringDashboardController.getCateringDashboard();
                        },
                        child: ListView.builder(
                          // shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return OrderCardForCatering(index: index);
                          },
                          itemCount: cateringDashboardController
                              .cateringDashboardModel!.orders!.length,
                        ),
                      );
                    }
                  }),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8))),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CateringProfileHeader extends StatefulWidget {
  const CateringProfileHeader({Key? key}) : super(key: key);

  @override
  State<CateringProfileHeader> createState() => _CateringProfileHeaderState();
}

class _CateringProfileHeaderState extends State<CateringProfileHeader> {
  var cateringDashboardController = Get.find<CateringDashboardController>();
  var profileController = Get.find<ProfileController>();

  void initState() {
    profileController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cateringDashboardController.isLoading.value) {
        return Center(
          child: LoadingAnimationWidget.prograssiveDots(
              color: Colors.white, size: 50),
        );
      }
      return Container(
        padding: EdgeInsets.only(left: 25, right: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipOval(
                  child: SizedBox(
                      height: 45,
                      width: 45,
                      child: FancyShimmerImage(
                        imageUrl: cateringDashboardController
                            .cateringDashboardModel!.catering!.image!,
                      )),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Selamat datang, ",
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    Text(
                        cateringDashboardController
                            .cateringDashboardModel!.catering!.name!,
                        style: AppTheme.textTheme.titleLarge!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 400,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
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
                                        "Konfirmasi Keluar Akun",
                                        style: AppTheme.textTheme.labelMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                child: SvgPicture.asset(ImagePath.logout),
                                width: 230,
                                height: 230,
                              ),
                              Text(
                                "Apakah anda yakin ingin keluar akun?",
                                textAlign: TextAlign.center,
                                style: AppTheme.textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 13),
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
                                          style: AppTheme.textTheme.labelMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: AppTheme.primaryBlack),
                                        ),
                                      ),
                                      width: 120,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppTheme.greyOutline),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Obx(() {
                                      return PrimaryButton(
                                          title: 'Keluar Akun',
                                          onTap: () {
                                            profileController.logout();
                                          },
                                          state:
                                              profileController.isLoading.value
                                                  ? ButtonState.dangerLoading
                                                  : ButtonState.danger);
                                    }),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.logout_rounded,
                    color: AppTheme.primaryRed,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

class OrderCardForCatering extends StatefulWidget {
  int index;

  OrderCardForCatering({Key? key, required this.index}) : super(key: key);

  @override
  State<OrderCardForCatering> createState() => _OrderCardForCateringState();
}

class _OrderCardForCateringState extends State<OrderCardForCatering> {
  var cateringDashboardController = Get.find<CateringDashboardController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (cateringDashboardController
            .cateringDashboardModel!.orders![widget.index]
            .isPreOrder()) {
          Get.toNamed(RouteHelper.cateringPreOrderDetail,
              arguments: cateringDashboardController
                  .cateringDashboardModel!.orders![widget.index].id!);
        } else {
          // Get.toNamed(RouteHelper.subsOrderDetail,
          //     arguments: cateringDashboardController
          //         .cateringDashboardModel!.orders![widget.index].id!);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: 25, right: 25, bottom: 20),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!, width: 0.5),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Container(
                    //   height: 35,
                    //   width: 35,
                    //   color: Colors.grey,
                    // ),
                    if (cateringDashboardController
                        .cateringDashboardModel!.orders![widget.index]
                        .isPreOrder())
                      Image.asset(
                        ImagePath.preOrderIcon,
                        height: 35,
                      )
                    else
                      Image.asset(
                        ImagePath.subsOrderIcon,
                        height: 35,
                      ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      children: [
                        Text(
                            cateringDashboardController
                                .cateringDashboardModel!.orders![widget.index]
                                .orderTypeWording(),
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 11, fontWeight: FontWeight.w400)),
                        Text(
                            cateringDashboardController
                                .cateringDashboardModel!.orders![widget.index]
                                .deliveryDateWording(),
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w500))
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          cateringDashboardController
                              .cateringDashboardModel!.orders![widget.index]
                              .getOrderStatusBadge()!,
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                    )
                  ],
                ),
                Divider(),
                // Text(cateringDashboardController.cateringDashboardModel!.orders![widget.index].cateringName!,
                //     style: AppTheme.textTheme.titleLarge!
                //         .copyWith(fontSize: 12, fontWeight: FontWeight.w500)),
                Text(
                    "${cateringDashboardController.cateringDashboardModel!.orders![widget.index].orderQuantity!} Item",
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 11, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 8,
                ),
                Text(
                    cateringDashboardController.cateringDashboardModel!
                        .orders![widget.index].itemSummary!,
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 11, fontWeight: FontWeight.w300)),
                SizedBox(
                  height: 6,
                ),
                Text(
                    CurrencyFormat.convertToIdr(
                        cateringDashboardController.cateringDashboardModel!
                                .orders![widget.index].totalPrice! -
                            cateringDashboardController.cateringDashboardModel!
                                .orders![widget.index].useBalance,
                        0),
                    style: AppTheme.textTheme.titleLarge!
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
