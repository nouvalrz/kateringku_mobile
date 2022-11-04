import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kateringku_mobile/constants/image_path.dart';

import 'package:kateringku_mobile/constants/vector_path.dart';
import 'package:kateringku_mobile/themes/app_theme.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Stack(children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.83,
                child: Container(color: AppTheme.primaryGreen),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * 0.83 - 20.0,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ]),
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
                    padding: const EdgeInsets.only(top: 46),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
                                    child: Text(
                                      "Jl. Bypass Ngurah Rai No. 120",
                                      style: AppTheme.textTheme.labelMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: SizedBox(
                      child: TextFormField(
                          decoration: InputDecoration(
                              hintText: "Mau cari apa?",
                              prefixIcon: Icon(
                                Icons.search_outlined,
                                color: AppTheme.secondaryBlack.withOpacity(0.7),
                              ))),
                      height: 46,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Kategori",
                      style: AppTheme.textTheme.labelMedium!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Flexible(
                        fit: FlexFit.loose,
                        child: SizedBox(
                          height: 85,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              DashboardCategory(
                                title: "Bali",
                                imagePath: ImagePath.baliCategory,
                                imageHeight: 40,
                              ),
                              DashboardCategory(
                                title: "Jawa",
                                imagePath: ImagePath.jawaCategory,
                                imageHeight: 40,
                              ),
                              DashboardCategory(
                                title: "Rice Box",
                                imagePath: ImagePath.riceboxCategory,
                                imageHeight: 35,
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
                                title: "Japanese",
                                imagePath: ImagePath.japaneseCategory,
                                imageHeight: 28,
                              ),
                              DashboardCategory(
                                title: "Sate",
                                imagePath: ImagePath.sateCategory,
                                imageHeight: 32,
                              ),
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Katering Untukmu",
                  style: AppTheme.textTheme.labelMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const DashboardSortButton(),
              ],
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Vegan Food Nayla",
                                style: AppTheme.textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 15),
                              ),
                              Text(
                                "Aneka Nasi, Vegan",
                                style: AppTheme.textTheme.labelSmall,
                              ),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.map_outlined,
                                    color: AppTheme.secondaryBlack,
                                  ),
                                  Text("Pedungan")
                                ],
                                mainAxisAlignment: MainAxisAlignment.start,
                              ),
                              const Text("Terjual 256")
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
              // Container(
              //   child: Column(
              //     children: [
              //       Row(
              //         children: Column(
              //           children: const [],
              //         ),
              //       )
              //     ],
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //   ),
              // )
            ],
          ))
        ],
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
    return Padding(
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
              height: 62,
              width: 62,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
            ),
            Container(
              height: 62,
              width: 62,
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
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              title,
              style:
                  AppTheme.textTheme.labelSmall!.copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
