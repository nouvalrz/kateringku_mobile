import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kateringku_mobile/controllers/profile_controller.dart';

import '../../components/primary_button.dart';
import '../../constants/image_path.dart';
import '../../themes/app_theme.dart';
import '../home/home_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    // print("CALL ALL CART");
    profileController.getProfile();
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
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 46),
              child: Container(
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text("Profile Akun",
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25, top: 20),
              child: Column(
                children: [
                  Obx(() =>
                  !profileController.isLoading.value
                      ? Column(
                    children: [
                      Text(profileController.profileModel!.name!,
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(
                        height: 8,
                      ),
                      Text(profileController.profileModel!.email!,
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 4,
                      ),
                      Text("+" + profileController.profileModel!.phone!,
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400)),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )
                      : Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryGreen,
                    ),
                  )),
                  SizedBox(
                    height: 68,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.map_outlined,
                        color: AppTheme.primaryGreen,
                        size: 28,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text("Daftar Alamat",
                          style: AppTheme.textTheme.titleLarge!.copyWith(
                              fontSize: 13, fontWeight: FontWeight.w500))
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(
                    thickness: 0.7,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      var homeController = Get.find<HomeController>();
                      homeController.tabController.value.index = 1;
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: AppTheme.primaryGreen,
                          size: 28,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text("Keranjang Anda",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 13, fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(
                    thickness: 0.7,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      var homeController = Get.find<HomeController>();
                      homeController.tabController.value.index = 2;
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.feed_outlined,
                          color: AppTheme.primaryGreen,
                          size: 28,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text("Pesanan Anda",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 13, fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(
                    thickness: 0.7,
                  ),
                  SizedBox(
                    height: 12,
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
                                              style: AppTheme
                                                  .textTheme.labelMedium!
                                                  .copyWith(
                                                  fontWeight:
                                                  FontWeight.w600,
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
                                      child:
                                      SvgPicture.asset(ImagePath.logout),
                                      width: 230,
                                      height: 230,
                                    ),
                                    Text(
                                      "Apakah anda yakin ingin keluar akun?",
                                      textAlign: TextAlign.center,
                                      style: AppTheme.textTheme.labelMedium!
                                          .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
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
                                                style: AppTheme
                                                    .textTheme.labelMedium!
                                                    .copyWith(
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    fontSize: 14,
                                                    color: AppTheme
                                                        .primaryBlack),
                                              ),
                                            ),
                                            width: 120,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: AppTheme.greyOutline),
                                              borderRadius:
                                              BorderRadius.circular(10),
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
                                                state: profileController.isLoading.value ?  ButtonState.dangerLoading : ButtonState.danger);
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
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: AppTheme.primaryRed,
                          size: 28,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text("Keluar Akun",
                            style: AppTheme.textTheme.titleLarge!.copyWith(
                                fontSize: 13, fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(
                    thickness: 0.7,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            )
          ])
        ],
      ),
    );
  }
}